#!/bin/bash

# Setup script for n8n Campaign Video Generator

echo "🚀 Setting up n8n Campaign Video Generator..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p n8n-data
mkdir -p test-outputs

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env file and add your API keys"
    echo "   Required keys:"
    echo "   - OPENAI_API_KEY"
    echo "   - GOOGLE_GEMINI_API_KEY"
    echo "   - FAL_AI_API_KEY"
    echo "   - KIE_AI_API_KEY"
else
    echo "✅ .env file already exists"
fi

# Start Docker Compose
echo "🐳 Starting n8n with Docker Compose..."
docker-compose up -d

# Wait for n8n to be ready
echo "⏳ Waiting for n8n to be ready..."
sleep 10

# Check if n8n is running
if curl -s http://localhost:5678 > /dev/null; then
    echo "✅ n8n is running at http://localhost:5678"
    echo ""
    echo "📋 Next steps:"
    echo "1. Open http://localhost:5678 in your browser"
    echo "2. Import the workflow from workflows/webhook-version.json"
    echo "3. Configure your API credentials in n8n"
    echo "4. Activate the workflow"
    echo "5. Test using test-client/index.html"
    echo ""
    echo "🎉 Setup complete!"
else
    echo "❌ n8n is not responding. Check Docker logs with:"
    echo "   docker-compose logs n8n"
    exit 1
fi