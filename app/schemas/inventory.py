from pydantic import BaseModel


class ProductBase(BaseModel):
    name: str
    sku: str
    description: str | None = None
    unit: str = "piece"
    cost_price: float
    sell_price: float
    category: str | None = None


class ProductCreate(ProductBase):
    pass


class ProductOut(ProductBase):
    id: int
    model_config = {"from_attributes": True}


class WarehouseBase(BaseModel):
    name: str
    location: str | None = None


class WarehouseCreate(WarehouseBase):
    pass


class WarehouseOut(WarehouseBase):
    id: int
    model_config = {"from_attributes": True}


class InventoryOut(BaseModel):
    id: int
    product_id: int
    warehouse_id: int
    quantity: float
    model_config = {"from_attributes": True}
