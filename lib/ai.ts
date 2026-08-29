import Anthropic from '@anthropic-ai/sdk'

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
  baseURL: process.env.ANTHROPIC_BASE_URL,
})

export async function askAI(prompt: string, opts?: { model?: string; maxTokens?: number }): Promise<string> {
  const msg = await client.messages.create({
    model: opts?.model ?? process.env.ANTHROPIC_MODEL ?? 'claude-sonnet-5',
    max_tokens: opts?.maxTokens ?? 800,
    messages: [{ role: 'user', content: prompt }],
  })
  const block = msg.content.find((b) => b.type === 'text')
  if (!block || block.type !== 'text') throw new Error('Unexpected AI response type')
  return block.text.trim()
}

export function extractJson<T = unknown>(text: string): T {
  const start = text.indexOf('{')
  const end = text.lastIndexOf('}')
  if (start === -1 || end === -1) throw new Error('Invalid JSON response from AI')
  return JSON.parse(text.slice(start, end + 1))
}
