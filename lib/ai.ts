import Anthropic from '@anthropic-ai/sdk'

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
  baseURL: process.env.ANTHROPIC_BASE_URL,
})

type ChatMessage = { role: 'user' | 'assistant'; content: string }

export async function askAI(promptOrMessages: string | ChatMessage[], opts?: { model?: string; maxTokens?: number; system?: string }): Promise<string> {
  const messages = typeof promptOrMessages === 'string' ? [{ role: 'user' as const, content: promptOrMessages }] : promptOrMessages
  const msg = await client.messages.create({
    model: opts?.model ?? process.env.ANTHROPIC_MODEL ?? 'claude-sonnet-5',
    max_tokens: opts?.maxTokens ?? 800,
    ...(opts?.system ? { system: opts.system } : {}),
    messages,
  // Прокси иногда просто виснет — соединение открыто, но ни ответа, ни
  // ошибки не приходит (см. тот же баг у scripts/research-programs.mjs).
  // Без таймаута такой запрос завис бы навсегда, а клиент — с вечным
  // "печатает…" без единого способа выйти из этого состояния.
  }, { timeout: 60_000 })
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
