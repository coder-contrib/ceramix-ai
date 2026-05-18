from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.finance import Expense, Return, Treasury
from app.models.user import User
from app.schemas.finance import (
    ExpenseCreate,
    ExpenseOut,
    ReturnCreate,
    ReturnOut,
    TreasuryCreate,
    TreasuryOut,
)

router = APIRouter(tags=["finance"])


@router.post("/treasury", response_model=TreasuryOut, status_code=status.HTTP_201_CREATED)
def create_treasury_entry(
    data: TreasuryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entry = Treasury(**data.model_dump(), user_id=current_user.id)
    db.add(entry)
    db.commit()
    db.refresh(entry)
    return entry


@router.get("/treasury", response_model=list[TreasuryOut])
def list_treasury(db: Session = Depends(get_db), _: User = Depends(get_current_user)):
    return db.query(Treasury).all()


@router.post("/expenses", response_model=ExpenseOut, status_code=status.HTTP_201_CREATED)
def create_expense(
    data: ExpenseCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    expense = Expense(**data.model_dump(), user_id=current_user.id)
    db.add(expense)
    db.commit()
    db.refresh(expense)
    return expense


@router.get("/expenses", response_model=list[ExpenseOut])
def list_expenses(db: Session = Depends(get_db), _: User = Depends(get_current_user)):
    return db.query(Expense).all()


@router.post("/returns", response_model=ReturnOut, status_code=status.HTTP_201_CREATED)
def create_return(
    data: ReturnCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    ret = Return(**data.model_dump(), user_id=current_user.id)
    db.add(ret)
    db.commit()
    db.refresh(ret)
    return ret


@router.get("/returns", response_model=list[ReturnOut])
def list_returns(db: Session = Depends(get_db), _: User = Depends(get_current_user)):
    return db.query(Return).all()
