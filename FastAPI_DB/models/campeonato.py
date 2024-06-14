from sqlalchemy import Table, Column, Integer, String, Date, JSON, ForeignKey
from config.db import meta, Base
from typing import Optional

class Campeonato(Base):
    __tablename__ = 'campeonatos'
    id = Column(Integer, primary_key=True)
    fecha = Column(Date)
    juego = Column(String(40))
    lista_reglas = Column(JSON)
    premios = Column(JSON)