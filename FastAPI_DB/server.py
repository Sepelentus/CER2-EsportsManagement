from fastapi import FastAPI
from routes import team

app = FastAPI()

app.include_router(team.router, prefix="/equipos", tags=["equipos"])

@app.get("/")
async def read_root():
    return {"message": "Hello World"}
