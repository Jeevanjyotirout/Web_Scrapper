# ⚡ AI Web Scraper — Fully Automated Web Scraping Platform

> **100% Free · Open Source · Runs Locally · No Cloud API Keys Required**

A production-grade platform combining AI-powered intelligence with automated web scraping
to generate structured datasets from any website — all running on your own machine.

---

## 🏗️ Project Structure

```
ai-web-scraper/
│
├── 📦 backend/                   FastAPI application (main API server)
│   ├── app/
│   │   ├── main.py               App entry point & router registration
│   │   ├── api/
│   │   │   ├── middleware.py     Rate limiting, auth, request logging
│   │   │   └── routes/
│   │   │       ├── scrape.py     POST /api/scrape — start a job
│   │   │       ├── jobs.py       GET  /api/jobs   — list / track jobs
│   │   │       ├── export.py     GET  /api/export  — download datasets
│   │   │       └── health.py     GET  /health      — liveness probe
│   │   ├── core/
│   │   │   ├── config.py         Pydantic settings (reads .env)
│   │   │   ├── exceptions.py     Custom exception classes
│   │   │   ├── logging.py        Structured logging setup
│   │   │   └── redis_client.py   Redis connection pool
│   │   ├── models/
│   │   │   └── job.py            Job state machine & schemas
│   │   ├── modules/              Core business logic
│   │   │   ├── scraping_engine.py   Playwright + BS4 scraper
│   │   │   ├── ai_processing.py     LLM extraction pipeline
│   │   │   ├── instruction_parser.py Natural-language instruction parsing
│   │   │   ├── dataset_builder.py   Pandas DataFrame assembly
│   │   │   └── export_engine.py     Excel / Word / CSV / JSON export
│   │   ├── workers/
│   │   │   ├── celery_app.py     Celery worker configuration
│   │   │   └── tasks.py          Async scraping tasks
│   │   └── utils/
│   │       ├── job_manager.py    Background job tracking
│   │       └── text_utils.py     Text cleaning helpers
│   ├── tests/                    pytest test suite
│   ├── scripts/
│   │   ├── setup.sh              Backend-only setup
│   │   └── start_worker.sh       Start Celery worker
│   ├── requirements.txt          Python dependencies
│   ├── Dockerfile
│   └── .env.example
│
├── 🎨 frontend/                  Next.js 14 application
│   ├── src/
│   │   ├── app/
│   │   │   ├── layout.tsx        Root layout
│   │   │   ├── page.tsx          Dashboard page
│   │   │   └── globals.css       Tailwind base styles
│   │   ├── components/
│   │   │   ├── scraper/
│   │   │   │   ├── ScrapeForm.tsx    URL + instruction input form
│   │   │   │   └── JobProgress.tsx   Real-time job progress display
│   │   │   ├── ui/
│   │   │   │   ├── ProgressBar.tsx   Reusable progress bar
│   │   │   │   └── StatusBadge.tsx   Job status indicator
│   │   │   └── layout/
│   │   │       └── ArchitectureDiagram.tsx  System diagram
│   │   ├── hooks/
│   │   │   └── useScraper.ts     React hook for scraping API
│   │   ├── lib/
│   │   │   └── api.ts            Typed API client
│   │   └── types/
│   │       └── index.ts          TypeScript type definitions
│   ├── package.json
│   ├── tailwind.config.ts
│   ├── next.config.js
│   ├── Dockerfile
│   └── .env.local.example
│
├── 🧠 rag-pipeline/              Local RAG (Retrieval Augmented Generation)
│   ├── src/
│   │   ├── embeddings/
│   │   │   ├── encoder.py        sentence-transformers embedding generator
│   │   │   └── embedder.py       Batch embedding orchestrator
│   │   ├── tokenizer/
│   │   │   ├── chunker.py        Token-aware text splitter
│   │   │   └── tokenizer_chunker.py  HuggingFace tokenizer chunker
│   │   ├── vector_store/
│   │   │   ├── store.py          FAISS index management
│   │   │   └── vector_store.py   High-level vector DB interface
│   │   ├── llm/
│   │   │   ├── engine.py         Ollama LLM client
│   │   │   └── processor.py      Structured output generator
│   │   ├── pipeline/
│   │   │   ├── pipeline.py       End-to-end RAG orchestrator
│   │   │   ├── rag_pipeline.py   Master 8-stage pipeline
│   │   │   ├── retriever.py      Semantic retrieval logic
│   │   │   └── schema.py         Pydantic models for pipeline I/O
│   │   └── utils/
│   │       ├── logger.py
│   │       ├── text_cleaner.py
│   │       └── formatter.py      Output formatting helpers
│   ├── config/settings.py        Pipeline configuration
│   ├── tests/                    pytest suite for all RAG components
│   ├── data/raw/                 Raw scraped text files (gitignored)
│   ├── data/indices/             Saved FAISS indices (gitignored)
│   ├── models/                   Downloaded Ollama model cache
│   ├── scripts/download_model.sh Pull required Ollama model
│   ├── main.py                   CLI entrypoint
│   ├── requirements.txt
│   └── .env.example
│
├── 🕷️  scraper-engine/            Standalone Playwright scraping engine
│   ├── engine/
│   │   ├── engine.py             Core Playwright browser manager
│   │   ├── extractor.py          CSS + XPath data extractor
│   │   ├── paginator.py          Multi-page crawling logic
│   │   ├── orchestrator.py       Job orchestration
│   │   └── settings.py           Scraper configuration
│   ├── models/
│   │   ├── extracted_data.py     Scraped data schema
│   │   └── page_result.py        Per-page result model
│   ├── utils/
│   │   ├── url_utils.py          URL normalisation & validation
│   │   ├── text_utils.py         Text cleaning utilities
│   │   └── visited_tracker.py   De-duplication tracker
│   ├── tests/test_scraper.py
│   └── main.py
│
├── 📤 export-service/            Standalone export utilities
│   ├── excel_exporter.py         xlsx generation with openpyxl
│   ├── word_exporter.py          docx generation with python-docx
│   ├── build_docx.js             Node.js Word document builder
│   ├── data.py                   Sample data models
│   └── main.py
│
├── 🐳 infra/                     Docker & infrastructure config
│   ├── docker/
│   │   ├── docker-compose.full.yml   Full production stack
│   │   ├── docker-compose.dev.yml    Development overrides
│   │   ├── Dockerfile.worker         Celery worker image
│   │   ├── redis.conf                Redis config
│   │   └── qdrant.yaml               Qdrant vector DB config
│   └── nginx/
│       ├── nginx.conf                Main Nginx config
│       └── datavault.conf            Virtual host config
│
├── 📋 sample-outputs/            Example generated files
│   ├── articles_report.xlsx      Sample Excel export
│   └── articles_report.docx      Sample Word export
│
├── 📚 docs/
│   └── architecture.md           Detailed architecture documentation
│
├── docker-compose.yml            ← START HERE for Docker deployment
├── Makefile                      Convenience commands
├── setup.sh                      Automated setup script
├── .env.example                  Environment variables template
└── .gitignore
```

---

## 🚀 Quick Start

### Option A — Docker (Recommended, one command)

```bash
cp .env.example .env
make setup-docker
# or: docker compose up -d --build
```

Open **http://localhost:3000**

### Option B — Local Development

**Prerequisites:** Python 3.11+ · Node.js 18+ · [Ollama](https://ollama.ai)

```bash
# 1. Install Ollama and pull a model
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull tinyllama

# 2. Run setup
chmod +x setup.sh && ./setup.sh local

# 3. Start backend (Terminal 1)
cd backend && source venv/bin/activate
uvicorn app.main:app --reload --port 8000

# 4. Start frontend (Terminal 2)
cd frontend && npm run dev

# 5. Open http://localhost:3000
```

### Option C — RAG Pipeline standalone

```bash
cd rag-pipeline
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python main.py --demo
```

---

## 🔌 API Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/scrape` | Start a scraping job |
| `GET`  | `/api/jobs` | List all jobs |
| `GET`  | `/api/jobs/{job_id}` | Get job status |
| `GET`  | `/api/jobs/{job_id}/stream` | SSE live progress stream |
| `GET`  | `/api/export/{job_id}` | Download result (xlsx/docx/csv) |
| `DELETE` | `/api/jobs/{job_id}` | Cancel/delete a job |
| `GET`  | `/health` | Health check |

Interactive docs: **http://localhost:8000/docs**

---

## ⚙️ Configuration

All config lives in `.env` (copy from `.env.example`):

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_MODEL` | `tinyllama` | LLM model to use |
| `MAX_CONCURRENT_JOBS` | `3` | Parallel scraping jobs |
| `MAX_PAGES_PER_JOB` | `10` | Max pages per scrape |
| `CHUNK_SIZE` | `512` | RAG chunk size (tokens) |
| `EMBEDDING_MODEL` | `all-MiniLM-L6-v2` | Sentence transformer model |

---

## 🧪 Running Tests

```bash
make test           # all tests
make test-backend   # FastAPI + modules
make test-rag       # RAG pipeline
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 14, TailwindCSS, TypeScript |
| Backend | FastAPI, Celery, Redis |
| Scraping | Playwright, BeautifulSoup4 |
| AI / LLM | Ollama (TinyLlama/Phi), LangChain |
| Embeddings | sentence-transformers, FAISS |
| Export | pandas, openpyxl, python-docx |
| Infrastructure | Docker, Nginx, Qdrant |

---

## 📄 License

MIT License — free for personal and commercial use.
