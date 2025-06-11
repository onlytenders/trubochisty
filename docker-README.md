# Trubochisty Docker Setup 🐳

This project uses Docker to containerize both the Spring Boot backend and Flutter web frontend.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

### Build and run the entire application:
```bash
docker-compose up --build
```

### Run in background (detached mode):
```bash
docker-compose up -d --build
```

### Stop the application:
```bash
docker-compose down
```

## Access Points

- **Frontend (Flutter Web)**: http://localhost:3000
- **Backend (Spring Boot)**: http://localhost:8080
- **API calls from frontend**: Automatically proxied to backend via `/api/*` routes

## Individual Services

### Build backend only:
```bash
docker build -t trubo-backend ./server/truboserver
```

### Build frontend only:
```bash
docker build -t trubo-frontend ./client/trubochisty_front
```

### Run backend only:
```bash
docker run -p 8080:8080 trubo-backend
```

### Run frontend only:
```bash
docker run -p 3000:80 trubo-frontend
```

## Development Tips

- Backend logs: `docker-compose logs backend`
- Frontend logs: `docker-compose logs frontend`
- Rebuild specific service: `docker-compose up --build backend`
- Remove all containers and images: `docker-compose down --rmi all`

## Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Flutter Web   │    │   Spring Boot   │
│   (Port 3000)   │────│   (Port 8080)   │
│                 │    │                 │
│   nginx proxy   │    │   REST API      │
│   /api/* routes │    │                 │
└─────────────────┘    └─────────────────┘
```

The frontend automatically proxies API calls to the backend through nginx configuration. 