# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an n8n-based AI video generation workflow that creates professional brand videos for CrediLinq using a webhook-driven architecture. The system combines AI image generation, video creation, and video merging to produce complete marketing videos from a reference image and text prompt.

## Core Architecture

### Workflow Pipeline
The main workflow (`workflows/webhook-version.json`) processes requests through these stages:
1. **Webhook Input** - Receives image_url, prompt, and optional user_id
2. **Image Analysis** - OpenAI Vision API analyzes reference image for brand elements
3. **AI Agent Processing** - Two specialized Gemini agents generate prompts:
   - Pro Image Agent: Creates image generation prompts
   - Pro Video Agent: Creates video scene prompts
4. **Media Generation** - Parallel processing:
   - Fal AI nano-banana model generates images
   - Kie AI veo3_fast model creates videos from images
5. **Video Assembly** - Fal AI ffmpeg-api merges individual clips
6. **Response** - Returns final video URL or processing status

### Key Components
- **AI Agents**: Two LangChain agents with structured output parsers for brand-compliant content
- **API Integrations**: OpenAI (analysis), Google Gemini (agents), Fal AI (images/merging), Kie AI (videos)
- **Async Processing**: Built-in wait timers (60s images, 360s videos, 30s merging)
- **Error Handling**: Conditional checks and retry responses for incomplete processing

## Development Commands

### Local Development
```bash
# Start n8n with Docker
docker-compose up -d

# Access n8n interface
open http://localhost:5678

# Test webhook endpoint
./test-webhook.sh

# View logs
docker-compose logs -f n8n

# Stop services
docker-compose down
```

### Testing
```bash
# Manual webhook test
curl -X POST http://localhost:5678/webhook/video-generator \
  -H "Content-Type: application/json" \
  -d '{
    "image_url": "https://example.com/image.jpg",
    "prompt": "Create a professional brand video showcasing CrediLinq",
    "user_id": "test-user"
  }'

# Test with HTML client
open test-client/index.html
```

## Configuration

### Required API Keys (in .env file)
- `OPENAI_API_KEY` - For image analysis (chatgpt-4o-latest model)
- `GOOGLE_GEMINI_API_KEY` - Powers the AI agents
- `FAL_AI_API_KEY` - Image generation and video merging
- `KIE_AI_API_KEY` - Video generation (veo3_fast model)

### n8n Credentials Setup
After importing the workflow, configure these credential types in n8n:
- OpenAI API (for Analyze image node)
- Google Gemini API (for agent language models)
- HTTP Header Auth for Fal AI (for Create Image, Get Image, Combine Clips, Get Final Video nodes)
- HTTP Header Auth for Kie AI (for Create Video, Get Video nodes)

## Brand Guidelines

The workflow is specifically designed for CrediLinq brand compliance:
- **Brand Name**: Must be spelled exactly "CrediLinq"
- **Colors**: Navy (#0B0B45), Magenta (#EC1C63), White (#FFFFFF)
- **Services**: Credit-as-a-Service, B2B PayLater, GMV Financing
- **Compliance**: No APR/rate statements, guarantees, or "instant" claims
- **Style**: Professional commercial photography/videography standards

## Workflow Modification

### Importing/Exporting
- Import: n8n UI → Workflows → Import → `workflows/webhook-version.json`
- Export: n8n UI → Workflows → Download → Save to `workflows/`

### Key Nodes to Modify
- **Pro Image Agent** (`pro-image-agent`): Image generation prompts and branding
- **Pro Video Agent** (`pro-video-agent`): Video scene creation and dialogue
- **API endpoints**: Update URLs in HTTP Request nodes for different AI services
- **Wait timers**: Adjust timeout values based on API response times

## Troubleshooting

### Common Issues
- **Workflow not responding**: Ensure workflow is activated and Docker container is running
- **API failures**: Verify all credentials are configured in n8n UI
- **Long processing times**: Video generation typically takes 3-5 minutes
- **Memory issues**: Consider adjusting Docker resource limits for large workflows

### Monitoring
- Check executions in n8n UI for node-by-node debugging
- Review individual node outputs for API response validation
- Monitor Docker logs for container-level issues