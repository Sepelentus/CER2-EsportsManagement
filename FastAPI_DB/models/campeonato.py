from sqlalchemy import Table, Column, Integer, String, Date, JSON, ForeignKey
from config.db import meta

Campeonato = Table(
    'campeonatos', meta,
    Column('id', Integer, primary_key=True),
    Column('fecha', Date),
    Column('juego', String(40)),
    Column('lista_reglas', JSON),
    Column('premios', JSON),
)
