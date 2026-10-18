import fs from 'fs'
import fetch from 'node-fetch'

const API_KEY = process.env.CLAUDE_API_KEY
const API_URL = process.env.CLAUDE_API_URL || 'https://api.anthropic.com/v1/complete'

if (!API_KEY) {
  console.error('Error: CLAUDE_API_KEY is not set')
  process.exit(1)
}

const prompt = process.argv[2] || 'Write a short update for the repo documentation about the current project status.'

async function generate(prompt) {
  const body = {
    prompt,
    // Many Claude-compatible endpoints accept fields such as "model" and "max_tokens"; adjust as needed.
    model: process.env.CLAUDE_MODEL || 'claude-v1',
    max_tokens: 300
  }

  const res = await fetch(API_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${API_KEY}`
    },
    body: JSON.stringify(body)
  })

  if (!res.ok) {
    const text = await res.text()
    throw new Error(`Claude API error ${res.status}: ${text}`)
  }

  const json = await res.json()
  // Response shapes vary between providers; try a few common fields
  const output = json.completion || json.output || json.text || JSON.stringify(json)
  return output
}

generate(prompt)
  .then(output => {
    fs.writeFileSync('claude_output.md', `# Claude output\n\n${output}\n`)
    console.log('Wrote claude_output.md')
  })
  .catch(err => {
    console.error('Generation failed:', err)
    process.exit(2)
  })
