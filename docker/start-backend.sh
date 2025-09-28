#!/usr/bin/env sh
set -e

# Run migrations (Alembic uses app settings DB URL via env.py)
echo "[entrypoint] Running alembic upgrade head..."
poetry run alembic upgrade head || {
  echo "[entrypoint] Alembic failed"; exit 1;
}

if [ "$1" = "prod" ]; then
  echo "[entrypoint] Starting Uvicorn (prod)"
  exec uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2
else
  echo "[entrypoint] Starting Uvicorn (dev, --reload)"
  exec uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
fi
