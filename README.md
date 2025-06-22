# Deployment Guide

This repository contains a Flutter frontend and Django backend. The provided Dockerfile builds the Flutter web app and serves the Django API using Gunicorn. The GitHub Actions workflow builds the container, pushes it to Azure Container Registry (ACR) and deploys it to an Azure Web App for Containers.

## Azure Setup Steps

1. **Create an Azure Container Registry** and an **Azure Web App for Containers** in your Azure account.
2. Generate an Azure service principal and configure repository secrets:
   - `AZURE_CREDENTIALS` – output of `az ad sp create-for-rbac --name <name> --sdk-auth`.
   - `ACR_LOGIN_SERVER`, `ACR_USERNAME`, `ACR_PASSWORD` – values from your ACR.
   - `AZURE_WEBAPP_NAME` – name of the Web App.
3. Push your code to the `main` branch. The workflow will build and deploy the container automatically.
4. Ensure your Web App configuration sets environment variables for Postgres connection (`POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_HOST`, `POSTGRES_PORT`).

