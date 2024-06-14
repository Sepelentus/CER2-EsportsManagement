from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import MetaData
from dotenv import load_dotenv
import os

Base = declarative_base()

load_dotenv()
DATABASE_URL = os.getenv('DOMAIN_URL')

engine = create_async_engine(DATABASE_URL, echo=True)

SessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False
)

meta = MetaData()

from models.equipo import Equipo, Jugador, Partido, EquipoPartido, Resultado
from models.campeonato import Campeonato

async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
