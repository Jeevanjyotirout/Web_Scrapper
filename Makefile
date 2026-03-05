# ═══════════════════════════════════════════════════════════════
#  AI Web Scraper — Makefile
#  Usage: make <target>
# ═══════════════════════════════════════════════════════════════

.PHONY: help setup setup-docker dev-backend dev-frontend dev \
        docker-up docker-down docker-logs test test-backend test-rag \
        install-backend install-frontend clean

help:
	@echo ""
	@echo "  AI Web Scraper — Available Commands"
	@echo "  ───────────────────────────────────────────────────────"
	@echo "  make setup           Local dev setup (Python + Node)"
	@echo "  make setup-docker    Docker all-in-one setup"
	@echo "  make dev             Start both backend + frontend (dev)"
	@echo "  make dev-backend     Start FastAPI backend only"
	@echo "  make dev-frontend    Start Next.js frontend only"
	@echo "  make docker-up       Start all Docker containers"
	@echo "  make docker-down     Stop all Docker containers"
	@echo "  make docker-logs     Tail container logs"
	@echo "  make test            Run all tests"
	@echo "  make test-backend    Run backend tests only"
	@echo "  make test-rag        Run RAG pipeline tests only"
	@echo "  make clean           Remove venvs and node_modules"
	@echo ""

setup:
	chmod +x setup.sh && ./setup.sh local

setup-docker:
	chmod +x setup.sh && ./setup.sh docker

install-backend:
	cd backend && python3 -m venv venv && . venv/bin/activate && \
	pip install -r requirements.txt && playwright install chromium

install-frontend:
	cd frontend && npm install

dev-backend:
	cd backend && . venv/bin/activate && \
	uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

dev-frontend:
	cd frontend && npm run dev

dev:
	@echo "Starting backend and frontend in parallel..."
	$(MAKE) dev-backend & $(MAKE) dev-frontend

docker-up:
	docker compose up -d --build

docker-down:
	docker compose down

docker-logs:
	docker compose logs -f

test: test-backend test-rag

test-backend:
	cd backend && . venv/bin/activate && \
	pytest tests/ -v --cov=app --cov-report=term-missing

test-rag:
	cd rag-pipeline && . venv/bin/activate && \
	pytest tests/ -v

rag-demo:
	cd rag-pipeline && . venv/bin/activate && python main.py --demo

clean:
	rm -rf backend/venv backend/__pycache__
	rm -rf rag-pipeline/venv rag-pipeline/__pycache__
	rm -rf frontend/node_modules frontend/.next
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
