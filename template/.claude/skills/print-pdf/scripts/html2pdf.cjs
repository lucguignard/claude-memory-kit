// Usage: node html2pdf.cjs page.html output.pdf
// Renders an HTML page to PDF with Chromium (Playwright), honouring @page (size, margins, bleed).
const { chromium } = require("playwright");
const path = require("path");
const { pathToFileURL } = require("url");
(async () => {
  const [, , src, out] = process.argv;
  if (!src || !out) { console.error("Usage: node html2pdf.cjs page.html output.pdf"); process.exit(1); }
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(pathToFileURL(path.resolve(src)).href, { waitUntil: "networkidle" });
  await page.evaluate(() => document.fonts.ready);
  await page.pdf({ path: out, printBackground: true, preferCSSPageSize: true });
  await browser.close();
  console.log("PDF written:", out);
})();
