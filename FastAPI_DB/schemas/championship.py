from pydantic import BaseModel
from typing import List
from datetime import datetime

class Campeonato(BaseModel):
    id: int
    fecha: datetime
    juego: str
    lista_reglas: List[str]
    premios: List[str]

    class Config:
        orm_mode = True
