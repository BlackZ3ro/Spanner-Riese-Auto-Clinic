import os
import sys
import requests

API_KEY = os.environ.get('CLAUDE_API_KEY')
API_URL = os.environ.get('CLAUDE_API_URL', 'https://api.anthropic.com/v1/complete')

if not API_KEY:
    print('Error: CLAUDE_API_KEY is not set', file=sys.stderr)
    sys.exit(1)

prompt = sys.argv[1] if len(sys.argv) > 1 else 'Write a short update for the repo documentation about the current project status.'

payload = {
    'prompt': prompt,
    'model': os.environ.get('CLAUDE_MODEL', 'claude-v1'),
    'max_tokens': 300,
}

headers = {
    'Authorization': f'Bearer {API_KEY}',
    'Content-Type': 'application/json',
}

resp = requests.post(API_URL, json=payload, headers=headers)
if not resp.ok:
    print(f'Claude API error {resp.status_code}: {resp.text}', file=sys.stderr)
    sys.exit(2)

j = resp.json()
output = j.get('completion') or j.get('output') or j.get('text') or str(j)
with open('claude_output.md', 'w') as f:
    f.write('# Claude output\n\n')
    f.write(output)

print('Wrote claude_output.md')
