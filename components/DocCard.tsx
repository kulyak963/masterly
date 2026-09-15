import { line, t1, t2, t3, gold, blue, grn, sans, mono } from '@/lib/theme'

export interface DocStep { name: string; what: string; where: string; next?: string; cost?: string }

export default function DocCard({ step, n }: { step: DocStep; n: number }) {
  return (
    <div style={{ display: 'flex', gap: 12, marginBottom: 18, paddingBottom: 18, borderBottom: `1px solid ${line}` }}>
      <div style={{
        width: 24, height: 24, borderRadius: '50%', background: `${gold}18`, border: `1px solid ${gold}40`,
        color: gold, fontFamily: mono, fontSize: 11, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>{n}</div>
      <div>
        <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 5 }}>{step.name}</div>
        <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 6 }}>{step.what}</div>
        <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: step.next ? 4 : 0 }}>
          <span style={{ color: blue, fontWeight: 600 }}>Где получить: </span>{step.where}
        </div>
        {step.next && (
          <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: step.cost ? 4 : 0 }}>
            <span style={{ color: gold, fontWeight: 600 }}>Что дальше: </span>{step.next}
          </div>
        )}
        {step.cost && (
          <div style={{ fontFamily: sans, fontSize: 12, color: t3, lineHeight: 1.6 }}>
            <span style={{ color: grn, fontWeight: 600 }}>Сколько стоит и ждать: </span>{step.cost}
          </div>
        )}
      </div>
    </div>
  )
}
