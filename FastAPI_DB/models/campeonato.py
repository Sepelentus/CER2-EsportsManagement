from sqlalchemy import Table, Column, Integer, String, Date, JSON, ForeignKey
from config.db import meta
from typing import Optional

Campeonato = Table(
    'campeonatos', meta,
    Column('id', Integer, primary_key=True),
    Column('fecha', Date),
    Column('juego', String(40)),
    Column('lista_reglas', JSON),
    Column('premios', JSON)
    # Column('partidos_ids', Integer, ForeignKey('partidos.id'),)
)
