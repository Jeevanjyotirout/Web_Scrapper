#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  AI Web Scraper — Master Setup Script
#  Usage: ./setup.sh [local | docker | rag-only]
# ═══════════════════════════════════════════════════════════════
set -e
CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

log()  { echo -e "${CYAN}[setup]${NC} $1"; }
ok()   { echo -e "${GREEN}[  ✓  ]${NC} $1"; }
warn() { echo -e "${YELLOW}[ warn ]${NC} $1"; }
err()  { echo -e "${RED}[ ERR  ]${NC} $1"; exit 1; }

MODE=${1:-local}
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Copy env files ────────────────────────────────────────────────────────
log "Setting up environment files..."
[ ! -f "$ROOT_DIR/.env" ]                  && cp "$ROOT_DIR/.env.example"                      "$ROOT_DIR/.env"
[ ! -f "$ROOT_DIR/backend/.env" ]          && cp "$ROOT_DIR/backend/.env.example"               "$ROOT_DIR/backend/.env"
[ ! -f "$ROOT_DIR/frontend/.env.local" ]   && cp "$ROOT_DIR/frontend/.env.local.example"        "$ROOT_DIR/frontend/.env.local"
[ ! -f "$ROOT_DIR/rag-pipeline/.env" ]     && cp "$ROOT_DIR/rag-pipeline/.env.example"          "$ROOT_DIR/rag-pipeline/.env"
ok "Environment files ready"

if [ "$MODE" = "docker" ]; then
    # ── Docker mode ──────────────────────────────────────────────────────────
    log "Checking Docker..."
    command -v docker >/dev/null 2>&1 || err "Docker not found. Install from https://docs.docker.com/get-docker/"
    command -v docker compose >/dev/null 2>&1 || err "Docker Compose v2 not found."
    ok "Docker found"

    log "Building and starting all services..."
    docker compose -f "$ROOT_DIR/docker-compose.yml" up -d --build
    ok "All containers started"

    log "Pulling Ollama model (this may take a few minutes)..."
    docker exec ai-scraper-ollama ollama pull tinyllama || warn "Could not auto-pull model. Run: docker exec ai-scraper-ollama ollama pull tinyllama"

    echo ""
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}  AI Web Scraper is running!            ${NC}"
    echo -e "${GREEN}  Frontend  → http://localhost:3000     ${NC}"
    echo -e "${GREEN}  API Docs  → http://localhost:8000/docs${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"

elif [ "$MODE" = "rag-only" ]; then
    # ── RAG pipeline only ────────────────────────────────────────────────────
    log "Setting up RAG pipeline..."
    cd "$ROOT_DIR/rag-pipeline"
    python3 -m venv venv && source venv/bin/activate
    pip install -r requirements.txt -q
    ok "RAG pipeline ready. Run: python main.py --demo"

else
    # ── Local dev mode ───────────────────────────────────────────────────────
    log "Checking prerequisites..."
    command -v python3 >/dev/null 2>&1 || err "Python 3.11+ required"
    command -v node    >/dev/null 2>&1 || err "Node.js 18+ required"
    command -v ollama  >/dev/null 2>&1 || warn "Ollama not found. Install: curl -fsSL https://ollama.ai/install.sh | sh"

    # Backend
    log "Setting up Python backend..."
    cd "$ROOT_DIR/backend"
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt -q
    playwright install chromium --with-deps
    ok "Backend dependencies installed"

    # Frontend
    log "Installing frontend dependencies..."
    cd "$ROOT_DIR/frontend"
    npm install --silent
    ok "Frontend dependencies installed"

    # Ollama model
    log "Pulling Ollama model (tinyllama)..."
    ollama pull tinyllama 2>/dev/null || warn "Skipping model pull. Run manually: ollama pull tinyllama"

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Setup complete! Start the platform:                   ${NC}"
    echo -e "${GREEN}                                                        ${NC}"
    echo -e "${GREEN}  Terminal 1: cd backend && source venv/bin/activate   ${NC}"
    echo -e "${GREEN}              uvicorn app.main:app --reload --port 8000 ${NC}"
    echo -e "${GREEN}                                                        ${NC}"
    echo -e "${GREEN}  Terminal 2: cd frontend && npm run dev               ${NC}"
    echo -e "${GREEN}                                                        ${NC}"
    echo -e "${GREEN}  Open: http://localhost:3000                          ${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
fi
