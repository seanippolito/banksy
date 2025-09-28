
# 🏦 Banksy – Full-Stack Banking Boilerplate

Banksy is a full-stack boilerplate using:

- **Frontend:** Next.js 19 (App Router), Tailwind v4, Clerk for auth
- **Backend:** FastAPI (async), SQLAlchemy, Alembic migrations, SQLite (dev) or Postgres (prod-ready)
- **Tooling:** pnpm workspaces, Poetry, Docker (multi-stage), docker-compose for local/prod orchestration

---

## 📦 Prerequisites

- [Node.js 20+](https://nodejs.org) and [pnpm](https://pnpm.io/)
- [Python 3.12+](https://www.python.org/) and [Poetry](https://python-poetry.org/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

---

## ⚙️ Local Development (no Docker)

Clone and install:

```bash
git clone <your-repo-url> banksy
cd banksy
pnpm install    # install frontend deps via workspace
````

### Frontend

```bash
cd apps/frontend
pnpm dev
# runs on http://localhost:3000
```

### Backend

```bash
cd apps/backend
poetry install
poetry run alembic upgrade head   # run DB migrations
poetry run uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
# runs on http://127.0.0.1:8000
```

---

## 🐳 Run with Docker (recommended)

### Development stack (hot reload)

```bash
make dev
```

* Frontend: [http://localhost:3000](http://localhost:3000)
* Backend: [http://localhost:8000](http://localhost:8000)

Mounts your code into containers, reloads on changes.

### Production stack

```bash
docker compose up --build
```

* Builds multi-stage images
* Runs Alembic migrations on container start
* Serves optimized Next.js frontend + FastAPI backend

---

## 🔑 Environment Variables

All sensitive values should be stored in `.env.local` or Docker secrets.
See `.env.example` for required variables:

```ini
# Clerk
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...

# JWT template for backend auth
CLERK_JWT_TEMPLATE_NAME=banksy-backend
CLERK_JWKS_URL=https://<tenant>.clerk.accounts.dev/.well-known/jwks.json
JWT_ISSUER=https://<tenant>.clerk.accounts.dev

# Backend DB (SQLite dev)
DATABASE_URL=sqlite+aiosqlite:///./data/banksy.db

# Frontend API base
NEXT_PUBLIC_API_URL=http://localhost:8000
INTERNAL_API_URL=http://backend:8000

# CORS
CORS_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

---

## 🛠️ Database Migrations

Generate new migration:

```bash
make db-rev m="add accounts table"
```

Apply migrations:

```bash
make db-upgrade
```

Rollback:

```bash
make db-downgrade
```

---

## 🌱 Seeding Data

Create a demo account for your first signed-in user:

```bash
make seed
```

---

## 🚀 Features Implemented

* [x] pnpm monorepo + Docker Compose
* [x] Clerk auth (frontend + backend JWT validation)
* [x] User table auto-upsert on first request
* [x] Accounts + Transactions models & APIs
* [x] Alembic migrations
* [x] Full hot-reload dev & multi-stage prod builds

---

## 📚 Next Steps

* Add Postgres support for production
* Build richer dashboard UI (balances, transaction history)
* Add role-based access / permissions
* Deploy to Fly.io / Render / AWS ECS
