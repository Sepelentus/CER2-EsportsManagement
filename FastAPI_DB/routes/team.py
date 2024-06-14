from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy import insert, update, select, join, delete
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import joinedload
from typing import List

from config.db import SessionLocal
from models.equipo import Equipo, Jugador, Partido, EquipoPartido, Resultado
from models.campeonato import Campeonato
from schemas.team import Equipo as EquipoSchema
from schemas.player import Jugador as JugadorSchema
from schemas.game import Partido as PartidoSchema
from schemas.results_game import Result as ResultSchema
from schemas.championship import Campeonato as CampeonatoSchema

import ast

router = APIRouter()

# Dependency to get DB session
async def get_db():
    async with SessionLocal() as session:
        yield session

@router.post("/equipos/", response_model=EquipoSchema)
async def create_equipo(equipo: EquipoSchema, db: AsyncSession = Depends(get_db)):
    # Crear equipo
    query = insert(Equipo).values(nombre=equipo.nombre)
    result = await db.execute(query)
    await db.commit()
    equipo_id = result.lastrowid

    return equipo


@router.post("/jugadores/", response_model=JugadorSchema)
async def create_jugador(jugador: JugadorSchema, db: AsyncSession = Depends(get_db)):
    # Asociar jugadores existentes al equipo
    query = insert(Jugador).values(
        nombre=jugador.nombre,
        juego=jugador.juego,
        edad=jugador.edad,
        caracteristicas=jugador.caracteristicas,
        equipo_id= jugador.equipo_id,
    )
    result = await db.execute(query)
    await db.commit()
    jugador_id = result.lastrowid

    return jugador

@router.post("/partidos/", response_model=PartidoSchema)
async def create_partido(partido: PartidoSchema, db: AsyncSession = Depends(get_db)):
    # Crear partidos y relacionar con el equipo
    query = insert(Partido).values(
        fecha=partido.fecha,
        lugar=partido.lugar,
        campeonato_id=partido.campeonato_id  # Asignar campeonato
    )
    result = await db.execute(query)
    await db.commit()
    partido_id = result.lastrowid

    # Associate equipos with the partido
    if partido.equipos_ids is not None:  # Check if equipos_ids is provided
        for equipo_id in partido.equipos_ids:
            query = insert(EquipoPartido).values(
                equipo_id=equipo_id,
                partido_id=partido_id
            )
            await db.execute(query)

    await db.commit()

    return partido

@router.post("/resultados/", response_model=ResultSchema)
async def create_resultado(result: ResultSchema, db: AsyncSession = Depends(get_db)):
    # Asociar jugadores existentes al equipo
    query = insert(Resultado).values(
        result=result.result,
        partido_id=result.partido_id
    )
    result_proxy = await db.execute(query)
    await db.commit()
    result_id = result_proxy.lastrowid

    return {"id": result_id, "result": result.result, "partido_id": result.partido_id}

@router.post("/campeonatos/", response_model=CampeonatoSchema)
async def create_campeonato(campeonato: CampeonatoSchema, db: AsyncSession = Depends(get_db)):
    query = insert(Campeonato).values(
        fecha=campeonato.fecha,
        juego=campeonato.juego,
        lista_reglas=str(campeonato.lista_reglas),
        premios=str(campeonato.premios)
    )

    result = await db.execute(query)
    await db.commit()
    campeonato_id = result.lastrowid

    # Associate partidos with the campeonato
    # for partido_id in campeonato.partidos_ids:
    #     query = update(Partido).where(Partido.id == partido_id).values(campeonato_id=campeonato_id)
    #     await db.execute(query)

    await db.commit()

    return {**campeonato.dict(), "id": campeonato_id}

@router.put("/equipos/{equipo_id}", response_model=EquipoSchema)
async def update_equipo(equipo_id: int, equipo: EquipoSchema, db: AsyncSession = Depends(get_db)):
    query = update(Equipo).where(Equipo.id == equipo_id).values(nombre=equipo.nombre)
    await db.execute(query)
    await db.commit()
    return {**equipo.dict(), "id": equipo_id}

@router.put("/jugadores/{jugador_id}", response_model=JugadorSchema)
async def update_jugador(jugador_id: int, jugador: JugadorSchema, db: AsyncSession = Depends(get_db)):
    query = update(Jugador).where(Jugador.id == jugador_id).values(nombre=jugador.nombre, juego=jugador.juego, edad=jugador.edad, caracteristicas=jugador.caracteristicas, equipo_id=jugador.equipo_id)
    await db.execute(query)
    await db.commit()
    return {**jugador.dict(), "id": jugador_id}

@router.put("/partidos/{partido_id}", response_model=PartidoSchema)
async def update_partido(partido_id: int, partido: PartidoSchema, db: AsyncSession = Depends(get_db)):
    query = update(Partido).where(Partido.id == partido_id).values(fecha=partido.fecha, lugar=partido.lugar, campeonato_id=partido.campeonato_id)
    await db.execute(query)
    if partido.equipos_ids is not None:  # Check if equipos_ids is provided
        await db.execute(delete(EquipoPartido).where(EquipoPartido.partido_id == partido_id))
        # Create new relationships
        for equipo_id in partido.equipos_ids:
            query = insert(EquipoPartido).values(
                equipo_id=equipo_id,
                partido_id=partido_id
            )
            await db.execute(query)
    await db.commit()
    return {**partido.dict(), "id": partido_id}

@router.put("/campeonatos/{campeonato_id}", response_model=CampeonatoSchema)
async def update_campeonato(campeonato_id: int, campeonato: CampeonatoSchema, db: AsyncSession = Depends(get_db)):
    query = update(Campeonato).where(Campeonato.id == campeonato_id).values(fecha=campeonato.fecha, juego=campeonato.juego, lista_reglas=str(campeonato.lista_reglas), premios=str(campeonato.premios))
    await db.execute(query)
    await db.commit()
    return {**campeonato.dict(), "id": campeonato_id}


@router.get("/equipos/", response_model=List[EquipoSchema])
async def read_equipos(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Equipo))
    equipos = result.scalars().all()
    return [EquipoSchema(
        id=equipo.id,
        nombre=equipo.nombre,
    ) for equipo in equipos]

@router.get("/equipos/{equipo_id}", response_model=EquipoSchema)
async def read_equipo_by_id(equipo_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Equipo).where(Equipo.id == equipo_id))
    equipo = result.scalars().one()
    if equipo is None:
        raise HTTPException(status_code=404, detail="Equipo not found")
    return EquipoSchema(
        id=equipo.id,
        nombre=equipo.nombre
    )

# Get equipos of the campeonato
@router.get("/equipos/campeonato/{campeonato_id}", response_model=List[EquipoSchema])
async def get_equipos_for_campeonato(campeonato_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Partido).where(Partido.campeonato_id == campeonato_id))
    partidos = result.scalars().all()

    # Get the 'equipo_id's from the 'partidos'
    equipo_ids = []
    for partido in partidos:
        result = await db.execute(
            select(EquipoPartido.equipo_id).join(Equipo, Equipo.id == EquipoPartido.equipo_id).where(EquipoPartido.partido_id == partido.id)
        )
        equipo_ids += [row[0] for row in result.fetchall()]

    # Query all 'equipos' at once
    result = await db.execute(select(Equipo).where(Equipo.id.in_(equipo_ids)))
    equipos = result.scalars().all()

    return [EquipoSchema(
        id=equipo.id,
        nombre=equipo.nombre,
    ) for equipo in equipos]

@router.get("/jugadores/", response_model=List[JugadorSchema])
async def read_jugadores(db: AsyncSession = Depends(get_db)):
    # Start a SELECT query for Jugador
    query = select(Jugador)

    # Join with Equipo on the condition Jugador.equipo_id == Equipo.id
    query = query.join(Equipo, Jugador.equipo_id == Equipo.id)

    # Select additional columns from Equipo
    query = query.add_columns(Equipo.nombre.label('equipo_nombre'))

    result = await db.execute(query)
    jugadores = result.scalars().all()

    return [JugadorSchema(
        id=jugador.id,
        nombre=jugador.nombre,
        juego=jugador.juego,
        edad=jugador.edad,
        caracteristicas=jugador.caracteristicas,
        equipo_id=jugador.equipo_id,
    ) for jugador in jugadores]

#Use ast.literal_eval to make a string to a list.
#Getters for the tables

@router.get("/partidos/", response_model=List[PartidoSchema])
async def read_partidos(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Partido).options(joinedload(Partido.equipos)))
    partidos = result.unique().scalars().all()
    return [PartidoSchema(
        id=partido.id,
        fecha=partido.fecha,
        lugar=partido.lugar,
        campeonato_id=partido.campeonato_id,
        equipos_ids=[equipo.equipo_id for equipo in partido.equipos]
    ) for partido in partidos]

@router.get("/partidos/{partido_id}", response_model=PartidoSchema)
async def read_partido_by_id(partido_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Partido).options(joinedload(Partido.equipos)).where(Partido.id == partido_id))
    partido = result.scalars().first()
    if partido is None:
        raise HTTPException(status_code=404, detail="Partido not found")
    return PartidoSchema(
        id=partido.id,
        fecha=partido.fecha,
        lugar=partido.lugar,
        campeonato_id=partido.campeonato_id,
        equipos_ids=[equipo.equipo_id for equipo in partido.equipos]
    )

@router.get("/campeonatos/", response_model=List[CampeonatoSchema])
async def read_campeonatos(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Campeonato))
    campeonatos = result.scalars().all()
    return [CampeonatoSchema(
        id=campeonato.id,
        fecha=campeonato.fecha,
        juego=campeonato.juego,
        lista_reglas=ast.literal_eval(campeonato.lista_reglas),
        premios=ast.literal_eval(campeonato.premios)
    ) for campeonato in campeonatos]

@router.get("/campeonatos/{campeonato_id}", response_model=CampeonatoSchema)
async def read_campeonato(campeonato_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Campeonato).where(Campeonato.id == campeonato_id))
    campeonato = result.fetchone()
    # Query the Partido table to get the list of partido_ids associated with this campeonato
    result = await db.execute(select(Partido.id).where(Partido.campeonato_id == campeonato_id))
    partidos = result.scalars().all()
    partido_ids = [partido.id for partido in partidos]
    return {**campeonato._asdict(), "partidos_ids": partido_ids, "lista_reglas": ast.literal_eval(campeonato.lista_reglas), "premios": ast.literal_eval(campeonato.premios)}
#Deletes by id and all of a table

# Get all resultados
@router.get("/resultados/", response_model=List[ResultSchema])
async def read_resultados(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Resultado))
    resultados = result.scalars().all()
    return resultados

@router.get("/resultados/{resultado_id}", response_model=ResultSchema)
async def read_resultado_by_id(resultado_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Resultado).where(Resultado.id == resultado_id))
    resultado = result.scalar_one_or_none()
    if resultado is None:
        raise HTTPException(status_code=404, detail="Resultado not found")
    return resultado

@router.delete("/equipos/{equipo_id}")
async def delete_equipo(equipo_id: int, db: AsyncSession = Depends(get_db)):
    query = delete(Equipo).where(Equipo.id == equipo_id)
    await db.execute(query)
    await db.commit()
    return {"message": f"Deleted equipo with id {equipo_id}"}

@router.delete("/jugadores/{jugador_id}")
async def delete_jugador(jugador_id: int, db: AsyncSession = Depends(get_db)):
    query = delete(Jugador).where(Jugador.id == jugador_id)
    await db.execute(query)
    await db.commit()
    return {"message": f"Deleted jugador with id {jugador_id}"}

@router.delete("/partidos/{partido_id}")
async def delete_partido(partido_id: int, db: AsyncSession = Depends(get_db)):
    query = delete(Partido).where(Partido.id == partido_id)
    await db.execute(query)
    await db.commit()
    return {"message": f"Deleted jugador with id {partido_id}"}

@router.delete("/campeonatos/{campeonato_id}")
async def delete_campeonato(campeonato_id: int, db: AsyncSession = Depends(get_db)):
    query = delete(Campeonato).where(Campeonato.id == campeonato_id)
    await db.execute(query)
    await db.commit()
    return {"message": f"Deleted campeonato with id {campeonato_id}"}

@router.delete("/resultados/{resultado_id}")
async def delete_resultado_by_id(resultado_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(delete(Resultado).where(Resultado.id == resultado_id))
    if result.rowcount == 0:
        raise HTTPException(status_code=404, detail="Resultado not found")
    await db.commit()
    return {"message": f"Resultado {resultado_id} has been deleted"}

@router.delete("/equipos/")
async def delete_all_equipos(db: AsyncSession = Depends(get_db)):
    query = delete(Equipo)
    await db.execute(query)
    await db.commit()
    return {"message": "Deleted all equipos"}

@router.delete("/jugadores/")
async def delete_all_jugadores(db: AsyncSession = Depends(get_db)):
    query = delete(Jugador)
    await db.execute(query)
    await db.commit()
    return {"message": "Deleted all jugadores"}

@router.delete("/partidos/")
async def delete_all_partidos(db: AsyncSession = Depends(get_db)):
    query = delete(Partido)
    await db.execute(query)
    await db.commit()
    return {"message": "Deleted all partidos"}

@router.delete("/campeonatos/")
async def delete_all_campeonatos(db: AsyncSession = Depends(get_db)):
    query = delete(Campeonato)
    await db.execute(query)
    await db.commit()
    return {"message": "Deleted all campeonatos"}

@router.delete("/resultados/")
async def delete_resultados(db: AsyncSession = Depends(get_db)):
    await db.execute(delete(Resultado))
    await db.commit()
    return {"message": "All resultados have been deleted"}