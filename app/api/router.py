from fastapi import APIRouter

from app.api.routes import auth, finance, inventory, invoices, parties

api_router = APIRouter(prefix="/api")
api_router.include_router(auth.router)
api_router.include_router(parties.router)
api_router.include_router(inventory.router)
api_router.include_router(invoices.router)
api_router.include_router(finance.router)
