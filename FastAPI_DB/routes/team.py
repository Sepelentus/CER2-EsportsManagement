from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List

from config.db import conn
from models.equipo import Equipo, Jugador, Partido, EquipoPartido
from models.campeonato import Campeonato
from schemas.team import Equipo as EquipoSchema
from schemas.player import Jugador as JugadorSchema
from schemas.game import Partido as PartidoSchema
from schemas.championship import Campeonato as CampeonatoSchema

router = APIRouter()

@router.post("/equipos/", response_model=EquipoSchema)
async def create_equipo(equipo: EquipoSchema):
    # Crear equipo
    query = Equipo.insert().values(nombre=equipo.nombre)
    result = await conn.execute(query)
    equipo_id = result.lastrowid

    # Crear jugadores
    for jugador in equipo.lista_jugadores:
        query = Jugador.insert().values(
            nombre=jugador.nombre,
            juego=jugador.juego,
            edad=jugador.edad,
            caracteristicas=jugador.caracteristicas,
            equipo_id=equipo_id
        )
        await conn.execute(query)

    # Crear partidos y relacionar con el equipo
    for partido in equipo.lista_juegos:
        query = Partido.insert().values(
            fecha=partido.fecha,
            lugar=partido.lugar,
            campeonato_id=partido.campeonato_id  # Asignar campeonato
        )
        result = await conn.execute(query)
        partido_id = result.lastrowid

        query = EquipoPartido.insert().values(
            equipo_id=equipo_id,
            partido_id=partido_id
        )
        await conn.execute(query)

    return equipo

@router.post("/campeonatos/", response_model=CampeonatoSchema)
async def create_campeonato(campeonato: CampeonatoSchema):
    query = Campeonato.insert().values(
        fecha=campeonato.fecha,
        juego=campeonato.juego,
        lista_reglas=campeonato.lista_reglas,
        premios=campeonato.premios
    )
    result = await conn.execute(query)
    campeonato_id = result.lastrowid
    return {**campeonato.dict(), "id": campeonato_id}
