from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class Partido(BaseModel):
    id: int
    fecha: datetime
    equipos_ids: Optional[List[int]]
    lugar: str
    campeonato_id: Optional[int]

    class Config:
        orm_mode = True