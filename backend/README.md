# URL Analyzer Backend

Node.js server for analyzing URLs and finding optimal ad placements.

## Setup

1. Install dependencies:
```bash
cd backend
npm install
```

2. Create `.env` file:
```bash
# Create .env file with your Gemini API key
echo "GOOGLE_API_KEY=your_api_key_here" > .env
```

3. Start the server:
```bash
npm start
```

## API Endpoints

### POST /analyze
Analyzes a URL and returns screenshot with optimal ad placements.

**Request:**
```json
{
  "url": "https://example.com"
}
```

**Response:**
```json
{
  "success": true,
  "url": "https://example.com",
  "image": "base64_encoded_screenshot",
  "dimensions": { "width": 1080, "height": 1920 },
  "placements": [
    {
      "id": 1,
      "type": "banner",
      "y_position": 25,
      "x_position": 0,
      "width": 100,
      "height": 8,
      "suggestion_text": "...",
      "hex_color": "#00C853"
    }
  ]
}
```

### GET /health
Health check endpoint.

## Flutter Connection

- **Android Emulator:** Use `http://10.0.2.2:3000`
- **iOS Simulator:** Use `http://localhost:3000`
- **Physical Device:** Use your computer's IP address
