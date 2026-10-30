import { createClient } from 'npm:@supabase/supabase-js@2'
import { GoogleAuth } from 'npm:google-auth-library@9'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const FIREBASE_PROJECT_ID = Deno.env.get('FIREBASE_PROJECT_ID')!
const FIREBASE_SERVICE_ACCOUNT = JSON.parse(
  new TextDecoder().decode(
    Uint8Array.from(atob(Deno.env.get('FIREBASE_SERVICE_ACCOUNT_B64')!), (c) => c.charCodeAt(0)),
  ),
)
const WEBHOOK_SECRET = Deno.env.get('WEBHOOK_SECRET')!

const phaseLabels: Record<string, string> = {
  booked_in: 'Book-in & inspection',
  labor_in_progress: 'Labor in progress',
  reassembly: 'Reassembly',
  ready_for_pickup: 'Finished — ready for pickup',
  finalized: 'Finalized — booked out to customer',
}

Deno.serve(async (req) => {
  // Confirms this call genuinely came from your own Database Webhook,
  // not a random request to the function's public URL.
  const authHeader = req.headers.get('Authorization')
  if (authHeader !== `Bearer ${WEBHOOK_SECRET}`) {
    return new Response('Unauthorized', { status: 401 })
  }

  const payload = await req.json()
  const record = payload.record
  const oldRecord = payload.old_record

  if (!record || !oldRecord || record.phase === oldRecord.phase) {
    return new Response(JSON.stringify({ skipped: true }), { status: 200 })
  }

  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY)
  const { data: tokens } = await supabase
    .from('booking_push_tokens')
    .select('fcm_token')
    .eq('booking_id', record.id)

  if (!tokens || tokens.length === 0) {
    return new Response(JSON.stringify({ skipped: true, reason: 'no tokens' }), { status: 200 })
  }

  const auth = new GoogleAuth({
    credentials: FIREBASE_SERVICE_ACCOUNT,
    scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
  })
  const client = await auth.getClient()
  const accessToken = (await client.getAccessToken()).token

  const title = `${record.brand} ${record.model} — update`
  const body = phaseLabels[record.phase] ?? record.phase

  for (const { fcm_token } of tokens) {
    await fetch(
      `https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`,
      {
        method: 'POST',
        headers: { Authorization: `Bearer ${accessToken}`, 'Content-Type': 'application/json' },
        body: JSON.stringify({
          message: {
            token: fcm_token,
            notification: {title, body},
            data: {reference_code : String(record.reference_code)}
          }
        }),
      },
    )
  }

  return new Response(JSON.stringify({ sent: tokens.length }), { status: 200 })
})