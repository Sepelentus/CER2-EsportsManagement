from sqlalchemy import JSON, Table, Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from config.db import Base
from sqlalchemy.ext.declarative import declarative_base
from config.db import meta

class Equipo(Base):
    __tablename__ = 'equipos'
    id = Column(Integer, primary_key=True)
    nombre = Column(String(40))

class Jugador(Base):
    __tablename__ = 'jugadores'
    id = Column(Integer, primary_key=True)
    nombre = Column(String(40))
    juego = Column(String(40))
    edad = Column(Integer)
    caracteristicas = Column(String(100))
    equipo_id = Column(Integer, ForeignKey('equipos.id'))

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

class Resultado(Base):
    __tablename__ = 'resultados'
    id = Column(Integer, primary_key=True)
    result = Column(String(10))
    partido_id = Column(Integer, ForeignKey('partidos.id'))