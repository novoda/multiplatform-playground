#! /bin/bash
firebase login
NEWS_API_KEY=$(firebase functions:secrets:access NEWS_API_KEY --project news-multiplatform) 
echo "NEWS_API_KEY=$NEWS_API_KEY" > .secrets_env
echo "API secrets successfully written on .secrets_env"
