# Multi-stage build for Flutter frontend and Django backend

# Stage 1: build flutter web
FROM cirrusci/flutter:latest AS flutter-build
WORKDIR /app/frontend
COPY frontend/ ./
RUN flutter build web --release

# Stage 2: python dependencies and app setup
FROM python:3.11-slim AS backend
RUN apt-get update && apt-get install -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ ./backend/
COPY --from=flutter-build /app/frontend/build/web ./frontend_static
WORKDIR /app/backend
RUN python manage.py collectstatic --noinput

# Final stage
FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY --from=backend /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=backend /app/backend /app/backend
COPY --from=backend /app/frontend_static /app/frontend_static
ENV PORT=8000
CMD ["gunicorn", "backend.wsgi:application", "--bind", "0.0.0.0:8000"]
