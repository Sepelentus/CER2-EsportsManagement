from pydantic import BaseModel
from typing import List
from datetime import datetime

class Partido(BaseModel):
    id: int
    fecha: datetime
    equipos: List[int]
    lugar: str
    campeonato_id: int

    class Config:
        orm_mode = True