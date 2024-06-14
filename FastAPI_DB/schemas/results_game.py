from pydantic import BaseModel
from typing import Optional

class Result(BaseModel):
    id: int
    result: str
    partido_id: Optional[int]

    class Config:
        orm_mode = True