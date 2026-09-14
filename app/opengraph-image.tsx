import { ImageResponse } from 'next/og'

export const alt = 'Mastersly — магистратура в Европе'
export const size = { width: 1200, height: 630 }
export const contentType = 'image/png'

export default function Image() {
  return new ImageResponse(
    (
      <div style={{
        width: '100%', height: '100%', display: 'flex', flexDirection: 'column',
        justifyContent: 'center', background: '#0D0D0F', padding: '80px',
        fontFamily: 'sans-serif', position: 'relative',
      }}>
        <div style={{ display: 'flex', fontSize: 40, color: '#ECEAE2', fontWeight: 700, marginBottom: 28 }}>
          Mastersly
        </div>
        <div style={{ display: 'flex', fontSize: 60, color: '#ECEAE2', fontWeight: 800, lineHeight: 1.15, maxWidth: 980 }}>
          Магистратура в Европе
        </div>
        <div style={{ display: 'flex', fontSize: 26, color: '#8C94A0', marginTop: 28, maxWidth: 820, lineHeight: 1.4 }}>
          Персональный гид поступления — шортлист программ, дедлайны стипендий и roadmap за 3 минуты
        </div>
        <div style={{ display: 'flex', fontSize: 20, letterSpacing: 3, color: '#F2A93B', marginTop: 'auto', textTransform: 'uppercase' }}>
          mastersly.ru
        </div>
      </div>
    ),
    { ...size }
  )
}
