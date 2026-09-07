import type { MetadataRoute } from 'next'
import { supabase } from '../lib/supabase'

const BASE_URL = 'https://mastersly.ru'

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  // PostgREST caps any query at 1000 rows regardless of .limit() — paginate
  // with .range() so all program pages actually make it into the sitemap.
  const programs: { id: string }[] = []
  for (let from = 0; ; from += 1000) {
    const { data } = await supabase.from('programs').select('id').range(from, from + 999)
    if (!data?.length) break
    programs.push(...data)
    if (data.length < 1000) break
  }

  const staticRoutes: MetadataRoute.Sitemap = [
    { url: BASE_URL, changeFrequency: 'weekly', priority: 1 },
    { url: `${BASE_URL}/login`, changeFrequency: 'monthly', priority: 0.3 },
    { url: `${BASE_URL}/privacy`, changeFrequency: 'yearly', priority: 0.2 },
    { url: `${BASE_URL}/terms`, changeFrequency: 'yearly', priority: 0.2 },
    { url: `${BASE_URL}/offer`, changeFrequency: 'yearly', priority: 0.2 },
    { url: `${BASE_URL}/cookies`, changeFrequency: 'yearly', priority: 0.2 },
  ]

  const programRoutes: MetadataRoute.Sitemap = (programs || []).map((p) => ({
    url: `${BASE_URL}/program/${p.id}`,
    changeFrequency: 'weekly',
    priority: 0.7,
  }))

  return [...staticRoutes, ...programRoutes]
}
