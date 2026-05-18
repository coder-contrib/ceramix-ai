from pydantic import BaseModel


class CustomerBase(BaseModel):
    name: str
    phone: str | None = None
    email: str | None = None
    address: str | None = None


class CustomerCreate(CustomerBase):
    pass


class CustomerOut(CustomerBase):
    id: int
    balance: float
    model_config = {"from_attributes": True}


class SupplierBase(BaseModel):
    name: str
    phone: str | None = None
    email: str | None = None
    address: str | None = None


class SupplierCreate(SupplierBase):
    pass


class SupplierOut(SupplierBase):
    id: int
    balance: float
    model_config = {"from_attributes": True}
