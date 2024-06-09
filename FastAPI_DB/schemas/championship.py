from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class Campeonato(BaseModel):
    id: int
    fecha: datetime
    juego: str
    lista_reglas: List[str]
    premios: List[str]
    # partidos_ids: Optional[List[int]]

    class Config:
        orm_mode = True
