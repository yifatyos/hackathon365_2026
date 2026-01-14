/**
 * URL Analyzer Backend - Screenshot Only
 * Agent 1: Puppeteer (Screenshot)
 * Agent 2: Will be called from Flutter (Gemini)
 */

const express = require('express');
const cors = require('cors');
const puppeteer = require('puppeteer');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: '50mb' }));

/**
 * Take screenshot only - Gemini will be called from Flutter
 */
async function takeScreenshot(url) {
  console.log('\n🔍 Taking screenshot...');
  console.log(`   URL: ${url}`);
  
  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage']
  });

  try {
    const page = await browser.newPage();
    
    await page.setViewport({
      width: 390,
      height: 844,
      deviceScaleFactor: 1,
      isMobile: true,
      hasTouch: true
    });

    await page.setUserAgent(
      'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15'
    );

    console.log('   📱 Navigating...');
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 30000 });
    await new Promise(r => setTimeout(r, 2000));

    console.log('   📸 Capturing...');
    const screenshot = await page.screenshot({
      fullPage: false,
      encoding: 'base64',
      type: 'png'
    });

    console.log(`   ✅ Screenshot captured: 390x844`);
    
    return screenshot;
  } finally {
    await browser.close();
  }
}

/**
 * POST /screenshot - Returns screenshot only, Flutter calls Gemini
 */
app.post('/screenshot', async (req, res) => {
  const { url } = req.body;

  if (!url) {
    return res.status(400).json({ success: false, error: 'URL is required' });
  }

  let fullUrl = url;
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    fullUrl = 'https://' + url;
  }

  try {
    new URL(fullUrl);
  } catch (e) {
    return res.status(400).json({ success: false, error: 'Invalid URL format' });
  }

  console.log('\n' + '='.repeat(50));
  console.log('📸 SCREENSHOT REQUEST');
  console.log('='.repeat(50));

  try {
    const screenshot = await takeScreenshot(fullUrl);

    console.log('✅ Returning screenshot to Flutter');
    
    return res.json({
      success: true,
      image: screenshot
    });

  } catch (error) {
    console.error('❌ Failed:', error.message);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'Screenshot Service' });
});

app.listen(PORT, () => {
  console.log('\n' + '='.repeat(50));
  console.log('📸 SCREENSHOT SERVER');
  console.log('='.repeat(50));
  console.log(`📍 http://localhost:${PORT}`);
  console.log('='.repeat(50) + '\n');
});
