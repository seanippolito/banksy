
# Banksy — Full-Stack Banking Boilerplate

Secure, production-ready starter for a banking app.

- **Frontend:** Next.js 19.1+ (App Router), Tailwind v4, TypeScript, **Turbopack** dev server, **pnpm** workspaces  
- **Backend:** FastAPI (async), Pydantic v2, SQLAlchemy 2.x, SQLite (dev) → Postgres-ready  
- **Auth:** (next step) Clerk (frontend) + JWT validation (backend)  
- **Containerization:** Multi-stage Dockerfiles, **docker compose** with dev & prod targets  
- **Package management:** pnpm (frontend), **Poetry** via `pyproject.toml` (backend)


## Repo Layout

```

banksy/
├─ apps/
│  ├─ frontend/          # Next.js app (App Router, TS, Tailwind v4)
│  └─ backend/           # FastAPI app (app/main.py)
├─ packages/
│  └─ shared-types/      # Shared TS DTOs / API types
├─ docker/
│  ├─ frontend.Dockerfile
│  └─ backend.Dockerfile
├─ docker-compose.yml                # prod defaults (optimized)
├─ docker-compose.override.yml       # dev overrides (hot reload)
├─ pnpm-workspace.yaml
├─ package.json
├─ pnpm-lock.yaml
└─ README.md

````

---

## Prerequisites

**Local (optional, for non-Docker runs)**
- Node.js **>= 20**
- **pnpm** → `npm i -g pnpm`
- Python **3.12**
- **Poetry** → `pip install "poetry>=1.8.3"`

**Docker**
- Docker Engine & Docker Compose v2

---

## Environment Variables

Create a root **`.env`** (used by compose) if you want to override defaults:

```bash
# Frontend
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxxxxxxxx

# Backend
DATABASE_URL=sqlite:///./banksy.db
CLERK_SECRET_KEY=sk_test_xxxxxxxxx
CLERK_JWKS_URL=https://your-clerk-tenant.jwks.host/.well-known/jwks.json
JWT_AUDIENCE=your-app-audience
JWT_ISSUER=https://your-clerk-tenant
````

> In dev compose we point frontend at `http://backend:8000` inside the Docker network.

---

## Install & Run Locally (no Docker)

Useful for quick hacking without containers.

### 1. Install deps

```bash
# Frontend deps
pnpm install

# Backend deps
cd apps/backend
poetry install
cd ../../
```

### 2. Run backend

```bash
cd apps/backend
poetry run uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

### 3. Run frontend (in a second terminal)

```bash
pnpm --filter frontend dev --turbo
# opens http://localhost:3000
```

---

## Run with Docker Compose (Dev: hot reload)

Hot reload for **both** apps:

* Frontend: Next.js + **Turbopack**
* Backend: FastAPI + `uvicorn --reload`

```bash
docker compose -f docker-compose.yml -f docker-compose.override.yml up --build
```

* Frontend → [http://localhost:3000](http://localhost:3000)
* Backend  → [http://localhost:8000](http://localhost:8000)

**Notes**

* We **mount only source code** for the frontend (`apps/frontend`, `packages`) so the container manages `node_modules`.
* Backend virtualenv lives in `/opt/venv` so mounting `/app` doesn’t break `uvicorn`.
* If you edit code, both services reload automatically.

Stop:

```bash
docker compose -f docker-compose.yml -f docker-compose.override.yml down
```

---

## Run with Docker Compose (Prod: optimized)

Optimized `next build` → `next start`, and `uvicorn` multi-worker:

```bash
docker compose up --build
```

* Frontend → [http://localhost:3000](http://localhost:3000)
* Backend  → [http://localhost:8000](http://localhost:8000)

Stop & clean:

```bash
docker compose down
```

---

## Common Commands

```bash
# Rebuild clean dev
docker compose -f docker-compose.yml -f docker-compose.override.yml build --no-cache
docker compose -f docker-compose.yml -f docker-compose.override.yml up

# Rebuild clean prod
docker compose build --no-cache
docker compose up

# Tear down + volumes
docker compose down -v
```

---

## Troubleshooting

**Frontend: `Cannot find module .../node_modules/next/dist/bin/next`**

* Cause: host `node_modules` or volume mount overwrote container deps.
* Fix: we mount only source (`apps/frontend`, `packages`) and let container run `pnpm install`. Keep `.dockerignore` excluding `node_modules`.

**pnpm lockfile errors (`ERR_PNPM_NO_LOCKFILE`, `OUTDATED_LOCKFILE`)**

* Always run `pnpm install` at repo root after changing any `package.json`, commit `pnpm-lock.yaml`.
* In Docker, we use `--frozen-lockfile` for prod images (determinism). For dev we install inside the container after volumes mount.

**Backend: `exec: "uvicorn": executable file not found`**

* Cause: venv wiped by mount.
* Fix: venv is pinned to `/opt/venv` and added to `PATH`. Do **not** mount over `/opt/venv`.

**Uvicorn prints `http://0.0.0.0:8000`**

* That’s correct for container binding. Access from host via `http://127.0.0.1:8000`.
* Optionally add a startup print in `app/main.py` to echo the host URL.

**Windows/WSL file change detection**

* If hot reload is flaky, add `:delegated`/`:cached` on volumes (already set) and ensure your editor saves to disk.

---

## Next Steps

1. **Clerk Authentication**

    * Frontend: `@clerk/nextjs` provider + protected routes
    * Backend: JWT middleware validating Clerk JWKS

2. **Database**

    * Switch from SQLite to Postgres for multi-user
    * Add Alembic migrations

3. **Contracts**

    * Share DTOs in `packages/shared-types`
    * Optionally generate TS client from FastAPI OpenAPI

4. **CI/CD**

    * Build and push images for backend/frontend
    * Lint, type-check, tests; use `--frozen-lockfile` in CI

---

### Quick URLs

* **Frontend (dev/prod):** [http://localhost:3000](http://localhost:3000)
* **Backend (dev/prod):** [http://localhost:8000](http://localhost:8000)
* **Health Check:** `GET /api/v1/health` → `{"status":"ok"}`
