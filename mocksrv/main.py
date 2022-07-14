import os
from fastapi import FastAPI, HTTPException

mock = FastAPI()


@mock.get("/")
async def root():
    return {"message": "Hi there!"}


@mock.get("/people/{human_id}")
async def people(human_id: int):
    if human_id >= 0 and human_id <= 100:
        delay = os.getenv("MOCK_DELAY")
        return {"message": f"Hi there! Your human ID: {human_id} Delay: {delay}"}
    else:
        raise HTTPException(
            status_code=404, detail=f"Item with ID {human_id} is not found"
        )


@mock.get("/planets/{planet_id}")
async def planets(planet_id: int):

    if planet_id >= 0 and planet_id <= 100:
        delay = os.getenv("MOCK_DELAY")
        return {"message": f"Hi there! Your planet ID: {planet_id} Delay: {delay}"}
    else:
        raise HTTPException(
            status_code=404, detail=f"Item with ID {planet_id} is not found"
        )


@mock.get("/starships/{starship_id}")
async def starships(starship_id: int):

    if starship_id >= 0 and starship_id <= 100:
        delay = os.getenv("MOCK_DELAY")
        return {"message": f"Hi there! Your starship ID: {starship_id} Delay: {delay}"}
    else:
        raise HTTPException(
            status_code=404, detail=f"Item with ID {starship_id} is not found"
        )
