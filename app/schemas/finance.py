from pydantic import BaseModel


class TreasuryCreate(BaseModel):
    transaction_type: str
    amount: float
    reference: str | None = None
    notes: str | None = None


class TreasuryOut(TreasuryCreate):
    id: int
    user_id: int
    model_config = {"from_attributes": True}


class ExpenseCreate(BaseModel):
    category: str
    amount: float
    description: str | None = None


class ExpenseOut(ExpenseCreate):
    id: int
    user_id: int
    model_config = {"from_attributes": True}


class ReturnCreate(BaseModel):
    return_type: str
    invoice_id: int
    product_id: int
    quantity: float
    amount: float
    reason: str | None = None


class ReturnOut(ReturnCreate):
    id: int
    user_id: int
    model_config = {"from_attributes": True}
