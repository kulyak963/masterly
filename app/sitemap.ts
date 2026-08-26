import type { MetadataRoute } from 'next'
import { supabase } from '../lib/supabase'

const BASE_URL = 'https://mastersly.ru'

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const { data: programs } = await supabase.from('programs').select('id').limit(2000)

  const staticRoutes: MetadataRoute.Sitemap = [
    { url: BASE_URL, changeFrequency: 'weekly', priority: 1 },
    { url: `${BASE_URL}/login`, changeFrequency: 'monthly', priority: 0.3 },
    { url: `${BASE_URL}/privacy`, changeFrequency: 'yearly', priority: 0.2 },
    { url: `${BASE_URL}/terms`, changeFrequency: 'yearly', priority: 0.2 },
  ]

  const programRoutes: MetadataRoute.Sitemap = (programs || []).map((p) => ({
    url: `${BASE_URL}/program/${p.id}`,
    changeFrequency: 'weekly',
    priority: 0.7,
  }))

  return [...staticRoutes, ...programRoutes]
}
