# Default mode (dev or prod)
MODE ?= dev
ARGS ?=
SERVICE ?= backend

# Compose files
DEV_COMPOSE = docker/compose.development.yaml
PROD_COMPOSE = docker/compose.production.yaml

ifeq ($(MODE),prod)
  COMPOSE_FILE = $(PROD_COMPOSE)
else
  COMPOSE_FILE = $(DEV_COMPOSE)
endif

# -----------------------------
# Docker Services
# -----------------------------
up:
    docker compose -f $(COMPOSE_FILE) --env-file .env up $(ARGS)

down:
    docker compose -f $(COMPOSE_FILE) --env-file .env down $(ARGS)

build:
    docker compose -f $(COMPOSE_FILE) --env-file .env build $(ARGS)

logs:
    docker compose -f $(COMPOSE_FILE) --env-file .env logs -f $(SERVICE)

restart:
    docker compose -f $(COMPOSE_FILE) --env-file .env restart $(ARGS)

shell:
    docker compose -f $(COMPOSE_FILE) --env-file .env exec $(SERVICE) sh

ps:
    docker compose -f $(COMPOSE_FILE) --env-file .env ps

# -----------------------------
# Convenience Aliases
# -----------------------------
dev-up: MODE=dev
dev-up: up

dev-down: MODE=dev
dev-down: down

dev-build: MODE=dev
dev-build: build

dev-logs: MODE=dev
dev-logs: logs

dev-restart: MODE=dev
dev-restart: restart

dev-shell: MODE=dev
dev-shell: shell

dev-ps: MODE=dev
dev-ps: ps

backend-shell:
    docker compose -f $(COMPOSE_FILE) --env-file .env exec backend sh

gateway-shell:
    docker compose -f $(COMPOSE_FILE) --env-file .env exec gateway sh

mongo-shell:
    docker compose -f $(COMPOSE_FILE) --env-file .env exec mongo mongosh

prod-up: MODE=prod
prod-up: up

prod-down: MODE=prod
prod-down: down

prod-build: MODE=prod
prod-build: build

prod-logs: MODE=prod
prod-logs: logs

prod-restart: MODE=prod
prod-restart: restart

# -----------------------------
# Backend Utilities
# -----------------------------
backend-build:
    npm run build --prefix backend

backend-install:
    npm install --prefix backend

backend-type-check:
    npm run type-check --prefix backend

backend-dev:
    npm run dev --prefix backend

# -----------------------------
# Database Utilities
# -----------------------------
db-reset:
    docker compose -f $(COMPOSE_FILE) --env-file .env down -v
    docker volume rm cuet-cse-fest-devops-hackathon-preli_mongo_data || true

db-backup:
    docker compose -f $(COMPOSE_FILE) --env-file .env exec mongo mongodump --out /data/db/backup

# -----------------------------
# Cleanup
# -----------------------------
clean:
    docker compose -f $(DEV_COMPOSE) down
    docker compose -f $(PROD_COMPOSE) down

clean-all:
    docker system prune -af
    docker volume prune -f

clean-volumes:
    docker volume prune -f

# -----------------------------
# Utilities
# -----------------------------
status: ps

health:
    docker compose -f $(COMPOSE_FILE) --env-file .env ps

help:
    @grep -E '^#' Makefile
