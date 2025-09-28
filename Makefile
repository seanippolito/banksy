# ===== Banksy Makefile (root) =====
# Compute the absolute directory of THIS Makefile
PROJECT_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

COMPOSE_DEV := -f $(PROJECT_ROOT)/docker-compose.yml -f $(PROJECT_ROOT)/docker-compose.override.yml
COMPOSE_PROD := -f $(PROJECT_ROOT)/docker-compose.yml

.PHONY: dev up down rebuild logs be-sh fe-sh db-rev db-upgrade db-downgrade seed

dev:
	docker compose $(COMPOSE_DEV) up --build

up:
	docker compose $(COMPOSE_PROD) up --build -d

down:
	docker compose $(COMPOSE_DEV) down -v

rebuild:
	docker compose $(COMPOSE_DEV) build --no-cache

logs:
	docker compose $(COMPOSE_DEV) logs -f --tail=200

be-sh:
	docker compose $(COMPOSE_DEV) exec backend sh

fe-sh:
	docker compose $(COMPOSE_DEV) exec frontend sh

# Alembic helpers (inside backend container)
db-rev:
	@if [ -z "$(m)" ]; then echo "Usage: make db-rev m=\"your message\""; exit 1; fi
	docker compose $(COMPOSE_DEV) exec backend poetry run alembic revision --autogenerate -m "$(m)"

db-upgrade:
	docker compose $(COMPOSE_DEV) exec backend poetry run alembic upgrade head

db-downgrade:
	docker compose $(COMPOSE_DEV) exec backend poetry run alembic downgrade -1

seed:
	docker compose $(COMPOSE_DEV) exec backend poetry run python -m app.scripts.seed
