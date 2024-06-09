from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from sqlalchemy import MetaData
from dotenv import load_dotenv
import os

load_dotenv()
DATABASE_URL = os.getenv('DOMAIN_URL')

engine = create_async_engine(DATABASE_URL, echo=True)

SessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False
)

meta = MetaData()

from models.equipo import Equipo, Jugador, Partido, EquipoPartido
from models.campeonato import Campeonato

async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(meta.create_all)
