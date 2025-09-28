# 🧭 ONBOARDING – Banksy Full-Stack Boilerplate

Welcome! This guide will help you get Banksy running locally in under 5 minutes.

---

## 1. Clone the Repository

```bash
git clone <your-repo-url> banksy
cd banksy
````
---

## 2. Set Up Environment Variables

Copy the example file:

```bash
cp .env.example .env
```

Open `.env` and fill in the following:

* **Clerk Keys**:

    * `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`
    * `CLERK_SECRET_KEY`
* **Clerk JWT Template** (must exist in your Clerk dashboard):

    * `CLERK_JWT_TEMPLATE_NAME` (default: `banksy-backend`)
* **Database**: leave as SQLite for dev:

    * `DATABASE_URL=sqlite+aiosqlite:///./data/banksy.db`
* **CORS Origins**:

    * `CORS_ORIGINS=http://localhost:3000,http://127.0.0.1:3000`

---

## 3. Start in Docker (Recommended)

Bring up the development stack with hot reload:

```bash
make dev
```

This will:

* Run the frontend at **[http://localhost:3000](http://localhost:3000)**
* Run the backend at **[http://localhost:8000](http://localhost:8000)**
* Mount source code for hot reload
* Apply Alembic migrations on startup

Stop the stack:

```bash
make down
```

---

## 4. Run Locally (without Docker)

### Install Dependencies

Frontend:

```bash
pnpm install
```

Backend:

```bash
cd apps/backend
poetry install
```

### Start Servers

Frontend:

```bash
cd apps/frontend
pnpm dev
# http://localhost:3000
```

Backend:

```bash
cd apps/backend
poetry run alembic upgrade head
poetry run uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
# http://127.0.0.1:8000
```

---

## 5. Sign Up via Clerk

* Visit **[http://localhost:3000](http://localhost:3000)**
* Use the sign-up flow (Clerk dev instance) to create a user
* On first request, the backend will upsert the user in the DB

---

## 6. Verify Database

Check that users/accounts/transactions are being written:

```bash
make be-sh
sqlite3 data/banksy.db
.tables
select * from users;
```

---

## 7. Optional: Seed Data

Create a demo account for your user:

```bash
make seed
```

---

## ✅ You’re Ready!

At this point:

* Auth works end-to-end with Clerk
* Backend persists users/accounts/transactions in SQLite
* Frontend dashboard and transactions pages are live

Next steps:

* Add more features
* Switch DB to Postgres for production
* Deploy to your hosting provider

