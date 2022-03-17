#! /bin/bash

firebase login
NEWS_API_KEY=$(firebase functions:secrets:access NEWS_API_KEY --project news-multiplatform)

if [ $? -eq 0 ]; then
  echo "NEWS_API_KEY=$NEWS_API_KEY" > .secrets_env
  echo "API secrets successfully written on .secrets_env"
else
  echo "Unable to grant access to secret. Please check the account on which you are logged in"
fi
