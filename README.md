# Ceramix AI ERP

AI-powered Smart ERP system for Ceramic Showroom management.

## Tech Stack

- **Backend:** Python + FastAPI
- **Database:** PostgreSQL
- **ORM:** SQLAlchemy + Alembic (migrations)
- **Auth:** JWT + bcrypt

## Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Copy env file and configure
cp .env.example .env

# Create database
createdb ceramix

# Run migrations
alembic revision --autogenerate -m "initial"
alembic upgrade head

# Start server
uvicorn app.main:app --reload
```

API docs available at `http://localhost:8000/docs`

## Project Structure

```
ceramix-ai/
├── app/
│   ├── api/routes/       # API endpoints
│   ├── core/             # Config, security, dependencies
│   ├── db/               # Database session & base
│   ├── models/           # SQLAlchemy models
│   ├── schemas/          # Pydantic schemas
│   ├── services/         # Business logic (future)
│   └── main.py           # FastAPI app entry
├── alembic/              # Database migrations
├── tests/                # Test suite
├── requirements.txt
└── alembic.ini
```

## Modules

- **Auth** — JWT login, registration, roles (admin, accountant, warehouse, sales)
- **Customers & Suppliers** — CRUD with balance tracking
- **Products & Inventory** — Stock management across warehouses
- **Sales & Purchases** — Invoice creation with auto inventory updates
- **Finance** — Treasury, expenses, returns

## License

MIT
