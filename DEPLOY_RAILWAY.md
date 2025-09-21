# Railway Deployment Guide for n8n Campaign Video Workflow

## Prerequisites
- Railway account (https://railway.app)
- Railway CLI installed (optional)

## Step-by-Step Deployment

### 1. Create Railway Project

1. Go to https://railway.app/new
2. Choose "Deploy from GitHub repo" OR "Empty Project"
3. If using GitHub:
   - Connect your GitHub account
   - Select this repository
4. If using Empty Project:
   - You'll deploy via Railway CLI later

### 2. Add PostgreSQL Database

1. In your Railway project, click "New Service"
2. Select "Database" → "Add PostgreSQL"
3. Railway will automatically configure the database variables

### 3. Configure Environment Variables

Click on your n8n service and go to "Variables" tab. Add these:

```bash
# n8n Configuration
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your-secure-password-here
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=${{RAILWAY_STATIC_URL}}
N8N_EDITOR_BASE_URL=${{RAILWAY_STATIC_URL}}

# Database (auto-configured by Railway)
DB_TYPE=postgresdb
DB_POSTGRESDB_DATABASE=${{PGDATABASE}}
DB_POSTGRESDB_HOST=${{PGHOST}}
DB_POSTGRESDB_PORT=${{PGPORT}}
DB_POSTGRESDB_USER=${{PGUSER}}
DB_POSTGRESDB_PASSWORD=${{PGPASSWORD}}

# API Keys
GOOGLE_GEMINI_API_KEY=AIzaSyBArf65EIH2tBjG1kaTRb6i5aEGSTtSS94
FAL_AI_API_KEY=9556a276-12c3-49d8-b605-cc64ab53a727:12c32cdbba109d9658c9fdfefff4a9ed
KIE_AI_API_KEY=f72000145b3e4180cceb67d6efdcd911

# Generate a secure 32-character encryption key
N8N_ENCRYPTION_KEY=your-32-character-encryption-key
```

### 4. Deploy via Railway CLI (if not using GitHub)

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Link to your project
railway link

# Deploy
railway up
```

### 5. Access n8n

1. Once deployed, Railway will provide a URL like: `https://your-app.railway.app`
2. Access n8n at this URL
3. Login with the credentials you set (admin/your-password)

### 6. Import the Workflow

1. In n8n, go to "Workflows" → "Import"
2. Upload the `workflows/webhook-version.json` file
3. Open the imported workflow

### 7. Configure Credentials in n8n

You need to create these credentials in n8n UI:

1. **Google Gemini API**
   - Go to Credentials → Add Credential → Google Gemini API
   - Name: "Google Gemini API"
   - API Key: `AIzaSyBArf65EIH2tBjG1kaTRb6i5aEGSTtSS94`

2. **Fal AI API**
   - Go to Credentials → Add Credential → HTTP Header Auth
   - Name: "Fal AI API"
   - Header Name: `Authorization`
   - Header Value: `Key 9556a276-12c3-49d8-b605-cc64ab53a727:12c32cdbba109d9658c9fdfefff4a9ed`

3. **Kie AI API**
   - Go to Credentials → Add Credential → HTTP Header Auth
   - Name: "Kie AI API"
   - Header Name: `X-API-Key`
   - Header Value: `f72000145b3e4180cceb67d6efdcd911`

### 8. Activate the Workflow

1. Open your workflow in n8n
2. Click the "Inactive" toggle to activate it
3. Your webhook will be available at:
   ```
   https://your-app.railway.app/webhook/video-generator
   ```

### 9. Test the Deployment

```bash
curl -X POST https://your-app.railway.app/webhook/video-generator \
  -H "Content-Type: application/json" \
  -d '{
    "image_url": "https://example.com/test-image.jpg",
    "prompt": "Create a professional brand video for CrediLinq",
    "user_id": "test-user"
  }'
```

## Important Notes

1. **Persistence**: Railway provides persistent storage by default with PostgreSQL
2. **Scaling**: You can scale your n8n instance in Railway settings
3. **Custom Domain**: Add a custom domain in Railway project settings
4. **Monitoring**: Use Railway's built-in metrics and logs
5. **Backup**: Regular database backups are recommended

## Webhook URL

Your production webhook endpoint will be:
```
https://your-app.railway.app/webhook/video-generator
```

## Troubleshooting

- **Workflow not triggering**: Ensure the workflow is activated
- **Credentials error**: Double-check all API keys are correctly configured
- **Database connection**: Railway auto-configures this, but verify variables are set
- **Memory issues**: Upgrade your Railway plan if needed for video processing

## Security Recommendations

1. Change the default admin password immediately
2. Generate a strong N8N_ENCRYPTION_KEY
3. Consider IP whitelisting if needed
4. Enable 2FA on your Railway account
5. Regularly rotate API keys