# main.py
from fastapi import FastAPI
from config.db import init_db

app = FastAPI()

@app.on_event("startup")
async def on_startup():
    await init_db()

# Include your router
from routes import team
app.include_router(team.router)