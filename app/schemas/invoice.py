from pydantic import BaseModel


class SalesItemCreate(BaseModel):
    product_id: int
    quantity: float
    unit_price: float


class SalesItemOut(SalesItemCreate):
    id: int
    total: float
    model_config = {"from_attributes": True}


class SalesInvoiceCreate(BaseModel):
    customer_id: int
    discount: float = 0
    paid: float = 0
    payment_type: str = "cash"
    notes: str | None = None
    items: list[SalesItemCreate]


class SalesInvoiceOut(BaseModel):
    id: int
    invoice_number: str
    customer_id: int
    total: float
    discount: float
    net_total: float
    paid: float
    payment_type: str
    notes: str | None
    items: list[SalesItemOut] = []
    model_config = {"from_attributes": True}


class PurchaseItemCreate(BaseModel):
    product_id: int
    quantity: float
    unit_price: float


class PurchaseItemOut(PurchaseItemCreate):
    id: int
    total: float
    model_config = {"from_attributes": True}


class PurchaseInvoiceCreate(BaseModel):
    supplier_id: int
    paid: float = 0
    payment_type: str = "cash"
    notes: str | None = None
    items: list[PurchaseItemCreate]


class PurchaseInvoiceOut(BaseModel):
    id: int
    invoice_number: str
    supplier_id: int
    total: float
    paid: float
    payment_type: str
    notes: str | None
    items: list[PurchaseItemOut] = []
    model_config = {"from_attributes": True}
