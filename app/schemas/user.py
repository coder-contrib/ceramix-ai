from pydantic import BaseModel, EmailStr


class RoleBase(BaseModel):
    name: str
    description: str | None = None


class RoleCreate(RoleBase):
    pass


class RoleOut(RoleBase):
    id: int
    model_config = {"from_attributes": True}


class UserBase(BaseModel):
    username: str
    email: EmailStr
    full_name: str
    role_id: int


class UserCreate(UserBase):
    password: str


class UserOut(UserBase):
    id: int
    is_active: bool
    model_config = {"from_attributes": True}


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class LoginRequest(BaseModel):
    username: str
    password: str
