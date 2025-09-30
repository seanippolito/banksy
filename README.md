# Banksy – Full-Stack Banking MVP

Banksy is a **full-stack banking application MVP** built with:

* **Frontend**: Next.js (App Router) + React 19 + Tailwind CSS v4 + Clerk for authentication
* **Backend**: FastAPI + SQLAlchemy + Alembic + SQLite (dev) / Postgres (prod)
* **DevOps**: Docker + Docker Compose + Poetry for Python dependency management

The application provides a simulated online banking platform with user authentication, accounts, transactions, money transfers, cards, account holders, and statements. It is designed as an **MVP** but with a production-ready foundation.

---

## ✨ Features Implemented

* **Authentication**

    * Clerk-based JWT validation between frontend and backend
* **Users**

    * Persisted on first login
* **Accounts**

    * Create, list, view by ID
    * Primary holder automatically assigned
* **Transactions**

    * Create debit/credit transactions
    * List per account
* **Money Transfers**

    * Double-entry style (debit sender, credit recipient)
* **Cards**

    * Ship new cards (simulated digital cards linked to accounts)
* **Account Holders**

    * Add/remove account holders (Primary, Joint, Business, Trust, etc.)
* **Statements**

    * Dynamic generation (date-filtered, aggregated transactions)
* **Error Logging**

    * ApplicationLogger DB table for error capture
    * `/api/v1/errors` endpoint for reporting
* **Frontend**

    * Dashboard with user profile + accounts
    * Accounts page with create/view accounts
    * Account detail with holders, cards, statements
    * Transactions page with debit/credit entry
    * Money transfers page
    * Error reporting UI

---

## 🛠️ Prerequisites

* Node.js 20+
* Python 3.12+
* [Poetry](https://python-poetry.org/) (Python dependency manager)
* Docker + Docker Compose
* Clerk account (for authentication)

---

## ⚙️ Environment Variables

Create a `.env` file in the backend and frontend:

### Backend `.env`

```env
DATABASE_URL=sqlite+aiosqlite:///./data/banksy.db
CLERK_JWKS_URL=https://<your-clerk-instance>/.well-known/jwks.json
CLERK_JWT_ISSUER=https://<your-clerk-instance>/
CLERK_AUDIENCE=banksy-backend
```

### Frontend `.env.local`

```env
NEXT_PUBLIC_API_URL=http://localhost:8000
CLERK_PUBLISHABLE_KEY=<your-publishable-key>
CLERK_SECRET_KEY=<your-secret-key>
```

---

## 💾 Database Setup

Banksy stores its data in `banksy.db` (SQLite in development).

### Data Directory

```bash
mkdir -p apps/backend/data
```

### Run Migrations

```bash
cd apps/backend
poetry run alembic upgrade head
```

### Seed Basic Data

```bash
make seed
```

---

## 🚀 Running the Application

### Local Development (without Docker)

1. Start backend

   ```bash
   cd apps/backend
   poetry install
   poetry run uvicorn app.main:app --reload
   ```

2. Start frontend

   ```bash
   cd apps/frontend
   pnpm install
   pnpm dev
   ```

Access:

* API: [http://localhost:8000](http://localhost:8000)
* API docs: [http://localhost:8000/docs](http://localhost:8000/docs)
* Frontend: [http://localhost:3000](http://localhost:3000)

---

### Docker Development Environment

```bash
make dev
```

Runs both frontend + backend in containers with live reload.

---

### Docker Production Environment

```bash
make up
```

Runs production builds for both services.

---

## 📖 API Documentation

FastAPI provides interactive API docs at:

👉 [http://localhost:8000/docs](http://localhost:8000/docs)

---

## 🧪 Testing

Run backend tests with coverage report included:

```bash
cd apps/backend
poetry run pytest -v
```

In-memory SQLite is used for testing to isolate from dev/prod data.

---

## 🔮 Next Steps

* Improve test coverage (currently ~65%)
* Add real card tokenization/PCI-safe mock layer
* Expand statements (export to PDF/CSV)
* Implement scheduled/recurring transfers
* UI polish (charts, analytics)
* Deployment pipeline (CI/CD to cloud)
* Multi-tenant support

---
