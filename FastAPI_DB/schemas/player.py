from pydantic import BaseModel

class Jugador(BaseModel):
    id: int
    nombre: str
    juego: str
    edad: int
    caracteristicas: str
    equipo_id: int

    class Config:
        orm_mode = True