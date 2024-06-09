from pydantic import BaseModel
from typing import List
from .player import Jugador
from .game import Partido

class Equipo(BaseModel):
    id: int
    nombre: str

    class Config:
        orm_mode = True
