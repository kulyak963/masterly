import type { Metadata } from "next";
import { Overpass, Overpass_Mono } from "next/font/google";
import Script from "next/script";
import "./globals.css";
const overpass = Overpass({
  variable: "--font-overpass",
  weight: ["400", "500", "600", "700", "800", "900"],
  style: ["normal", "italic"],
  subsets: ["latin", "cyrillic"],
  display: "swap",
});

const overpassMono = Overpass_Mono({
  variable: "--font-overpass-mono",
  weight: ["400", "500", "600", "700"],
  subsets: ["latin", "cyrillic"],
  display: "swap",
});
export const viewport = {
  width: 'device-width',
  initialScale: 1,
}
const siteTitle = "Mastersly — магистратура в Европе"
const siteDescription = "Персональный гид поступления в европейскую магистратуру. Шортлист программ, дедлайны стипендий и roadmap за 3 минуты."

export const metadata: Metadata = {
  metadataBase: new URL("https://mastersly.ru"),
  title: { default: siteTitle, template: "%s — Mastersly" },
  description: siteDescription,
  keywords: [
    "магистратура в Европе", "поступление в магистратуру", "учеба за рубежом",
    "master's degree Europe", "гранты на обучение", "стипендии для студентов",
    "европейские университеты для россиян", "DAAD", "Erasmus",
  ],
  alternates: { canonical: "/" },
  robots: { index: true, follow: true },
  openGraph: {
    title: siteTitle,
    description: siteDescription,
    url: "https://mastersly.ru",
    siteName: "Mastersly",
    locale: "ru_RU",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: siteTitle,
    description: siteDescription,
  },
};

const jsonLd = {
  '@context': 'https://schema.org',
  '@type': 'WebSite',
  name: 'Mastersly',
  url: 'https://mastersly.ru',
  description: siteDescription,
  inLanguage: 'ru',
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="ru"
      className={`${overpass.variable} ${overpassMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />
        <Script id="yandex-metrika" strategy="afterInteractive" dangerouslySetInnerHTML={{
          __html: `(function(m,e,t,r,i,k,a){
            m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
            m[i].l=1*new Date();
            for (var j = 0; j < document.scripts.length; j++) {if (document.scripts[j].src === r) { return; }}
            k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)
          })(window, document,'script','https://mc.yandex.ru/metrika/tag.js?id=112578663', 'ym');
          ym(112578663, 'init', {ssr:true, webvisor:true, clickmap:true, ecommerce:"dataLayer", referrer: document.referrer, url: location.href, accurateTrackBounce:true, trackLinks:true});`,
        }} />
        <noscript>
          <div>
            <img src="https://mc.yandex.ru/watch/112578663" style={{ position: 'absolute', left: -9999 }} alt="" />
          </div>
        </noscript>
        {children}
      </body>
    </html>
  );
}