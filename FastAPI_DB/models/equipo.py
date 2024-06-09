from sqlalchemy import JSON, Table, Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
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

Base = declarative_base()

class Partido(Base):
    __tablename__ = 'partidos'
    id = Column(Integer, primary_key=True)
    fecha = Column(String(40))
    lugar = Column(String(100))
    campeonato_id = Column(Integer, ForeignKey('campeonatos.id'))
    equipos = relationship("EquipoPartido", backref="partido")
    def __repr__(self):
        equipos_ids = [equipo.equipo_id for equipo in self.equipos]
        return f"Partido(id={self.id}, fecha={self.fecha}, lugar={self.lugar}, campeonato_id={self.campeonato_id}, equipos_ids={equipos_ids})"

class EquipoPartido(Base):
    __tablename__ = 'equipo_partido'
    equipo_id = Column(Integer, ForeignKey('equipos.id'), primary_key=True)
    partido_id = Column(Integer, ForeignKey('partidos.id'), primary_key=True)
