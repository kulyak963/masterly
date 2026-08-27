import type { Metadata } from "next";
import { Overpass, Overpass_Mono } from "next/font/google";
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
export const metadata: Metadata = {
  metadataBase: new URL("https://mastersly.ru"),
  title: "Mastersly — магистратура в Европе",
  description: "Персональный гид поступления в европейскую магистратуру. Шортлист программ, дедлайны стипендий и roadmap за 3 минуты.",
};

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
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}