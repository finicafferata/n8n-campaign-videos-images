# CrediLinq Video Generator - n8n Workflow

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/deploy?template=https%3A%2F%2Fgithub.com%2Ffinicafferata%2Fn8n-campaign-videos-images&envs=N8N_BASIC_AUTH_USER%2CN8N_BASIC_AUTH_PASSWORD%2CN8N_ENCRYPTION_KEY%2CGOOGLE_GEMINI_API_KEY%2CFAL_AI_API_KEY%2CKIE_AI_API_KEY&N8N_BASIC_AUTH_USERDesc=Admin+username+for+n8n&N8N_BASIC_AUTH_PASSWORDDesc=Admin+password+for+n8n&N8N_ENCRYPTION_KEYDesc=32+character+encryption+key&GOOGLE_GEMINI_API_KEYDesc=Your+Google+Gemini+API+key&FAL_AI_API_KEYDesc=Your+Fal+AI+API+key&KIE_AI_API_KEYDesc=Your+Kie+AI+API+key)

A sophisticated n8n workflow for generating AI-powered brand videos using webhooks. This workflow creates professional marketing videos by combining AI image generation and video creation with brand-specific prompts.

## Features

- **Webhook-based triggering** - No Telegram dependencies
- **AI Image Generation** - Using Fal AI's nano-banana model
- **AI Video Creation** - Using Kie AI's veo model
- **Automated video merging** - Combines multiple clips into a final video
- **Brand compliance** - Maintains CrediLinq brand guidelines
- **Railway deployment ready** - One-click deployment to Railway
- **Local development** - Run on your machine with Docker

## Prerequisites

- Docker and Docker Compose installed
- API Keys for:
  - Google Gemini API (for image analysis and AI agents)
  - Fal AI API (for image generation and video merging)
  - Kie AI API (for video generation)

## Deployment Options

### Option 1: Deploy to Railway (Recommended)

Click the button at the top of this README to deploy to Railway in one click. You'll need to provide:
- Admin credentials for n8n
- Your API keys (Gemini, Fal AI, Kie AI)
- A 32-character encryption key

After deployment, access your n8n instance at your Railway URL and import the workflow from `workflows/webhook-version.json`.

### Option 2: Local Development

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd n8n-campaign-videos-images
```

### 2. Create Environment File

Create a `.env` file in the root directory:

```env
# Google Gemini Configuration
GOOGLE_GEMINI_API_KEY=your_gemini_api_key

# Fal AI Configuration
FAL_AI_API_KEY=your_fal_ai_api_key

# Kie AI Configuration
KIE_AI_API_KEY=your_kie_ai_api_key

# n8n Configuration (for local development)
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=changeme
N8N_ENCRYPTION_KEY=your-32-character-encryption-key
```

### 3. Start n8n with Docker Compose

```bash
docker-compose up -d
```

This will start n8n on `http://localhost:5678`

### 4. Import the Workflow

1. Access n8n at `http://localhost:5678`
2. Go to **Workflows** → **Import**
3. Select the file: `workflows/webhook-version.json`
4. Configure your API credentials in n8n:
   - Go to **Credentials** → **New**
   - Add credentials for:
     - Google Gemini API
     - Fal AI API (HTTP Header Auth)
     - Kie AI API (HTTP Header Auth)

### 5. Activate the Workflow

1. Open the imported workflow
2. Click **Activate** toggle
3. Note the webhook URL: `http://localhost:5678/webhook/video-generator`

### 6. Test the Workflow

Open the test client in your browser:

```bash
open test-client/index.html
```

Or use curl:

```bash
curl -X POST http://localhost:5678/webhook/video-generator \
  -H "Content-Type: application/json" \
  -d '{
    "image_url": "https://example.com/image.jpg",
    "prompt": "Create a professional brand video showcasing CrediLinq",
    "user_id": "test-user"
  }'
```

## Workflow Architecture

### Input (Webhook)

```json
{
  "image_url": "URL to reference image",
  "prompt": "Video generation instructions",
  "user_id": "Optional user identifier"
}
```

### Processing Pipeline

1. **Image Analysis** - Analyzes the reference image using OpenAI Vision
2. **Image Prompt Generation** - Creates detailed prompts for image scenes
3. **Image Generation** - Generates brand-compliant images
4. **Video Prompt Generation** - Creates video scene descriptions
5. **Video Generation** - Creates video clips from images
6. **Video Merging** - Combines clips into final video
7. **Response** - Returns video URL or processing status

### Output

```json
{
  "success": true,
  "video_url": "https://path-to-generated-video.mp4",
  "user_id": "test-user",
  "processing_time": "completed"
}
```

## API Configuration

### Google Gemini
- Used for image analysis (replacing OpenAI)
- Model: `gemini-1.5-flash`
- Powers the AI agents for prompt generation
- Used for both image and video prompt creation

### Fal AI
- Image generation: `nano-banana/edit` endpoint
- Video merging: `ffmpeg-api/merge-videos` endpoint

### Kie AI
- Video generation: `veo/generate` endpoint
- Model: `veo3_fast`
- Default aspect ratio: `9:16`

## Development

### Local Testing without Docker

```bash
# Install n8n globally
npm install n8n -g

# Start n8n
n8n start

# Access at http://localhost:5678
```

### Modifying the Workflow

1. Edit the workflow in n8n's visual editor
2. Export the workflow: **Workflows** → **Download**
3. Save to `workflows/webhook-version.json`

### Debugging

Check n8n logs:
```bash
docker-compose logs -f n8n
```

View workflow executions:
- Go to **Executions** in n8n UI
- Check individual node outputs
- Review error messages

## Troubleshooting

### Common Issues

1. **Webhook not responding**
   - Ensure workflow is activated
   - Check Docker container is running
   - Verify port 5678 is not blocked

2. **API errors**
   - Verify all API keys are correctly configured
   - Check API rate limits
   - Ensure sufficient API credits

3. **Video generation timeout**
   - Video generation can take 3-5 minutes
   - The workflow has built-in wait timers
   - Consider increasing timeout values if needed

4. **Image URL access issues**
   - Ensure image URLs are publicly accessible
   - Use HTTPS URLs when possible
   - Test image URL accessibility before sending

## Advanced Configuration

### Custom Branding

Edit the agent prompts in the workflow to customize:
- Brand colors
- Company name
- Product descriptions
- Compliance requirements

### Performance Optimization

- Adjust wait timers based on API response times
- Modify batch processing settings
- Configure parallel processing for multiple requests

### Scaling

For production use:
- Deploy n8n on a cloud server
- Use a proper database (PostgreSQL)
- Configure authentication
- Set up SSL/HTTPS
- Implement rate limiting

## Support

For issues or questions:
1. Check the workflow execution logs in n8n
2. Review API documentation for external services
3. Test individual nodes in the workflow
4. Verify all credentials are properly configured

## License

This project is configured for local development and testing. Ensure you comply with all API terms of service when using external services.

## Credits

Built with:
- [n8n](https://n8n.io/) - Workflow automation
- [OpenAI](https://openai.com/) - Image analysis
- [Google Gemini](https://ai.google.dev/) - AI agents
- [Fal AI](https://fal.ai/) - Image generation
- [Kie AI](https://kie.ai/) - Video generation