from sqlalchemy import Table, Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from config.db import meta

Equipo = Table(
    'equipos', meta, 
    Column('id', Integer, primary_key=True),
    Column('nombre', String(40)),
)

Jugador = Table(
    'jugadores', meta,
    Column('id', Integer, primary_key=True),
    Column('nombre', String(40)),
    Column('juego', String(40)),
    Column('edad', Integer),
    Column('caracteristicas', String(100)),
    Column('equipo_id', Integer, ForeignKey('equipos.id'))
)

Partido = Table(
    'partidos', meta,
    Column('id', Integer, primary_key=True),
    Column('fecha', String(40)),
    Column('lugar', String(100)),
    Column('campeonato_id', Integer, ForeignKey('campeonatos.id'))  # Relación con campeonato
)

EquipoPartido = Table(
    'equipo_partido', meta,
    Column('equipo_id', Integer, ForeignKey('equipos.id'), primary_key=True),
    Column('partido_id', Integer, ForeignKey('partidos.id'), primary_key=True)
)
