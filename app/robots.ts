import type { MetadataRoute } from 'next'

export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      disallow: ['/dashboard', '/api/', '/reset-password'],
    },
    sitemap: 'https://mastersly.ru/sitemap.xml',
  }
}
