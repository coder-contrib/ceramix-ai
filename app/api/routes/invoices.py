import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.inventory import Inventory, InventoryMovement
from app.models.invoice import PurchaseInvoice, PurchaseItem, SalesInvoice, SalesItem
from app.models.user import User
from app.schemas.invoice import (
    PurchaseInvoiceCreate,
    PurchaseInvoiceOut,
    SalesInvoiceCreate,
    SalesInvoiceOut,
)

router = APIRouter(tags=["invoices"])


@router.post("/sales", response_model=SalesInvoiceOut, status_code=status.HTTP_201_CREATED)
def create_sales_invoice(
    data: SalesInvoiceCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    invoice_number = f"SI-{uuid.uuid4().hex[:8].upper()}"
    total = sum(item.quantity * item.unit_price for item in data.items)
    net_total = total - data.discount

    invoice = SalesInvoice(
        invoice_number=invoice_number,
        customer_id=data.customer_id,
        user_id=current_user.id,
        total=total,
        discount=data.discount,
        net_total=net_total,
        paid=data.paid,
        payment_type=data.payment_type,
        notes=data.notes,
    )
    db.add(invoice)
    db.flush()

    for item_data in data.items:
        item = SalesItem(
            invoice_id=invoice.id,
            product_id=item_data.product_id,
            quantity=item_data.quantity,
            unit_price=item_data.unit_price,
            total=item_data.quantity * item_data.unit_price,
        )
        db.add(item)

        inv = db.query(Inventory).filter(
            Inventory.product_id == item_data.product_id
        ).first()
        if inv:
            inv.quantity -= item_data.quantity

        db.add(InventoryMovement(
            product_id=item_data.product_id,
            warehouse_id=inv.warehouse_id if inv else 1,
            movement_type="out",
            quantity=item_data.quantity,
            reference=invoice_number,
        ))

    db.commit()
    db.refresh(invoice)
    return invoice


@router.get("/sales", response_model=list[SalesInvoiceOut])
def list_sales_invoices(db: Session = Depends(get_db), _: User = Depends(get_current_user)):
    return db.query(SalesInvoice).all()


@router.get("/sales/{invoice_id}", response_model=SalesInvoiceOut)
def get_sales_invoice(invoice_id: int, db: Session = Depends(get_db), _: User = Depends(get_current_user)):
    invoice = db.query(SalesInvoice).filter(SalesInvoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return invoice


@router.post("/purchases", response_model=PurchaseInvoiceOut, status_code=status.HTTP_201_CREATED)
def create_purchase_invoice(
    data: PurchaseInvoiceCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    invoice_number = f"PI-{uuid.uuid4().hex[:8].upper()}"
    total = sum(item.quantity * item.unit_price for item in data.items)

    invoice = PurchaseInvoice(
        invoice_number=invoice_number,
        supplier_id=data.supplier_id,
        user_id=current_user.id,
        total=total,
        paid=data.paid,
        payment_type=data.payment_type,
        notes=data.notes,
    )
    db.add(invoice)
    db.flush()

    for item_data in data.items:
        item = PurchaseItem(
            invoice_id=invoice.id,
            product_id=item_data.product_id,
            quantity=item_data.quantity,
            unit_price=item_data.unit_price,
            total=item_data.quantity * item_data.unit_price,
        )
        db.add(item)

        inv = db.query(Inventory).filter(
            Inventory.product_id == item_data.product_id
        ).first()
        if inv:
            inv.quantity += item_data.quantity
        else:
            db.add(Inventory(product_id=item_data.product_id, warehouse_id=1, quantity=item_data.quantity))

        db.add(InventoryMovement(
            product_id=item_data.product_id,
            warehouse_id=inv.warehouse_id if inv else 1,
            movement_type="in",
            quantity=item_data.quantity,
            reference=invoice_number,
        ))

    db.commit()
    db.refresh(invoice)
    return invoice


@router.get("/purchases", response_model=list[PurchaseInvoiceOut])
def list_purchase_invoices(db: Session = Depends(get_db), _: User = Depends(get_current_user)):
    return db.query(PurchaseInvoice).all()
