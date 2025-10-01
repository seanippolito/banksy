# 🚀 Onboarding Guide – Banksy MVP

Welcome to **Banksy**, our full-stack banking MVP. This document is designed to help new developers quickly set up their environment, understand the workflow, and start contributing effectively.

---

## 📖 Overview

Banksy simulates a **modern online banking system** with:

* **Frontend**: Next.js + Tailwind CSS v4 + Clerk
* **Backend**: FastAPI + SQLAlchemy + Alembic
* **Database**: SQLite (dev/test), PostgreSQL (prod-ready)
* **Auth**: Clerk JWT-based authentication
* **DevOps**: Docker, Docker Compose, Poetry, pnpm

---

## 🛠️ Prerequisites

Ensure you have the following installed:

* [Node.js 20+](https://nodejs.org/)
* [Python 3.12+](https://www.python.org/)
* [Poetry](https://python-poetry.org/docs/#installation)
* [pnpm](https://pnpm.io/installation)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* [Clerk](https://clerk.dev/) account (for authentication keys)
* You must create an account with Clerk to enable User Authentication or the App won't run do to missing .env keys.
  In addition to creating an account you will need to generate a JWT Template to communicate with the database securely. See the image below for assistance.

![img.png](img.png)

---

## ⚙️ Environment Setup

1. **Clone the repository**

   ```bash
   git clone --recurse-submodules https://github.com/seanippolito/banksy.git
   cd banksy
   ```

2. **Install dependencies**

   **Backend**

   ```bash
   cd apps/backend
   poetry install
   ```

   **Frontend**

   ```bash
   cd apps/frontend
   pnpm install
   ```

3. **Environment variables**

   Create a `.env.local` for local runs, `.env.development` for docker development runs, `.env.production` for docker production runs file in the backend, frontend, and for docker ensure the .env files are copied into the root directory:
   The test_db also needs a separate `.env.test` for testing on a separate standalone database that doesn't impact the development database



   **Backend `.env`**

   ```env
   DATABASE_URL=sqlite+aiosqlite:///./data/banksy.db
   CLERK_JWKS_URL=https://<your-clerk-instance>/.well-known/jwks.json
   CLERK_JWT_ISSUER=https://<your-clerk-instance>/
   CLERK_AUDIENCE=banksy-backend
   ```

   **Frontend `.env.local`**

   ```env
   NEXT_PUBLIC_API_URL=http://localhost:8000
   CLERK_PUBLISHABLE_KEY=<your-publishable-key>
   CLERK_SECRET_KEY=<your-secret-key>
   ```

---

## 💾 Database Setup

1. **Create a data directory**

   ```bash
   mkdir -p apps/backend/data
   ```

2. **Run migrations**

   ```bash
   cd apps/backend
   poetry run alembic upgrade head
   ```

3. **Seed initial data**

   Backend service must be running in docker to seed the account.

   ```bash
   make seed
   ```

---

## 🚦 Running the Application

### Local Development (no Docker)

Backend:

   ```bash
   cd apps/backend
   poetry install
   make run
   ```

   if make is not installed run through poetry
   ```bash
   poetry run uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
   ```

Frontend:

   ```bash
   cd apps/frontend
   pnpm install
   pnpm dev
   ```

Start both at same time from root directory (banksy) using concurrently
Changes to backend will cause the backend app to hot reload, crashing the frontend app that is reliant on the backend being up

  ```bash
  pnpm install
  pnpm dev
  ```

Open:

* Frontend: [http://localhost:3000](http://localhost:3000)
* Backend API: [http://localhost:8000](http://localhost:8000)
* API Docs: [http://localhost:8000/docs](http://localhost:8000/docs)

---

### Development with Docker

From the root directory ./banksy

```bash
make dev
```

This runs both frontend and backend with live reload inside Docker.

---

### Production with Docker

```bash
make prod
```

Runs production-optimized builds for both services.

---

## 🧪 Testing

Run backend tests:

```bash
cd apps/backend
poetry run pytest -v --cov=app --cov-report=term-missing
```

* Tests run against **in-memory SQLite** so dev data is never touched.
* Aim for **80%+ coverage**.

---

## 👨‍💻 Developer Workflow

1. **Create a feature branch**

   ```bash
   git checkout -b feature/my-feature
   ```

2. **Add backend logic**

  * Model → Schema → Route → Test
  * Run `alembic revision --autogenerate` for DB schema changes

3. **Add frontend integration**

  * Update React page/components
  * Use `useApi()` hook for backend calls

4. **Run tests + linting**

   ```bash
   poetry run pytest
   pnpm lint
   ```

5. **Commit and push**

   ```bash
   git push origin feature/my-feature
   ```

---

## 🔮 Next Steps

* Increase test coverage to >80%
* Improve frontend UI polish (charts, summaries, analytics)
* Export statements (PDF/CSV)
* Add recurring transfers
* Implement real-world card tokenization mock
* Setup CI/CD for cloud deployment


