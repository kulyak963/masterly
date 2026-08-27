import { ImageResponse } from 'next/og'
import { supabase } from '../../../lib/supabase'

export const alt = 'Mastersly'
export const size = { width: 1200, height: 630 }
export const contentType = 'image/png'

const CNAME: Record<string, string> = {
  de: 'Германия', nl: 'Нидерланды', se: 'Швеция', ch: 'Швейцария',
  fi: 'Финляндия', fr: 'Франция', cz: 'Чехия', at: 'Австрия',
  dk: 'Дания', be: 'Бельгия', ie: 'Ирландия', it: 'Италия',
  es: 'Испания', pt: 'Португалия', no: 'Норвегия', pl: 'Польша',
  hu: 'Венгрия', ee: 'Эстония', lt: 'Литва', lv: 'Латвия',
}

export default async function Image({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const { data: program } = await supabase
    .from('programs')
    .select('name, tuition_eur, university:universities(name, country)')
    .eq('id', id)
    .single()

  const uniName = (program?.university as any)?.name || 'Mastersly'
  const country = CNAME[(program?.university as any)?.country] || ''
  const cost = program?.tuition_eur === 0 ? 'Бесплатно' : program?.tuition_eur ? `€${program.tuition_eur}/год` : ''

  return new ImageResponse(
    (
      <div style={{
        width: '100%', height: '100%', display: 'flex', flexDirection: 'column',
        background: '#0D0D0F', padding: '70px', fontFamily: 'sans-serif',
        position: 'relative',
      }}>
        <div style={{ display: 'flex', fontSize: 30, color: '#ECEAE2', fontWeight: 700, marginBottom: 40 }}>
          Mastersly
        </div>
        <div style={{ display: 'flex', fontSize: 22, letterSpacing: 4, color: '#F2A93B', marginBottom: 24, textTransform: 'uppercase' }}>
          {uniName}{country ? ` · ${country}` : ''}
        </div>
        <div style={{ display: 'flex', fontSize: 56, color: '#ECEAE2', fontWeight: 800, lineHeight: 1.15, maxWidth: 950 }}>
          {program?.name || 'Программа магистратуры'}
        </div>
        {cost && (
          <div style={{ display: 'flex', marginTop: 'auto', fontSize: 26, color: '#8C94A0' }}>
            {cost}
          </div>
        )}
      </div>
    ),
    { ...size }
  )
}
