#!/bin/bash

# Test webhook for n8n video generator
# Make sure your workflow is imported and activated first!

echo "🧪 Testing n8n Webhook Video Generator..."

# Test with a sample image and prompt
curl -X POST http://localhost:5678/webhook/video-generator \
  -H "Content-Type: application/json" \
  -d '{
    "image_url": "https://images.unsplash.com/photo-1556075798-4825dfaaf498?w=800",
    "prompt": "Create a professional brand video showcasing a coffee shop owner discussing their business growth. Scene 1: Owner looking concerned about cash flow. Scene 2: Using CrediLinq platform on laptop. Scene 3: Business thriving with happy customers.",
    "user_id": "test-user-123"
  }' | jq '.'

echo ""
echo "✅ Test request sent!"
echo "ℹ️  If the workflow is properly configured, you should see a JSON response."
echo "ℹ️  Video generation takes 3-5 minutes - check the n8n executions tab for progress."