import logging
import os
import random
import time
from fastapi import FastAPI, HTTPException

mock = FastAPI()

logger = logging.getLogger()

global delay_var

try:
    delay_var = os.getenv("MOCK_DELAY")
    if delay_var:
        delay_var = int(delay_var)
except Exception as e:
    raise EnvironmentError("Env delay value is wrong")


def check_delay():
    time_delay = 0
    if delay_var:
        time_delay = random.uniform(0.3, 3)
        logger.info(f"Responce delay will be: {time_delay} seconds")
        time.sleep(time_delay)
    else:
        logger.info("Responce will be without delay")
    return time_delay


@mock.get("/")
async def root():
    return {"message": "Hi there!"}


@mock.get("/people/{human_id}")
async def people(human_id: int):
    time_delay = check_delay()
    if human_id >= 0 and human_id <= 100:
        return {"message": f"Hi there! Your human ID: {human_id} Delay: {time_delay}"}
    else:
        raise HTTPException(
            status_code=404, detail=f"Item with ID {human_id} is not found"
        )


@mock.get("/planets/{planet_id}")
async def planets(planet_id: int):
    time_delay = check_delay()

    if planet_id >= 0 and planet_id <= 100:
        return {"message": f"Hi there! Your planet ID: {planet_id} Delay: {time_delay}"}
    else:
        raise HTTPException(
            status_code=404, detail=f"Item with ID {planet_id} is not found"
        )


@mock.get("/starships/{starship_id}")
async def starships(starship_id: int):
    time_delay = check_delay()

    if starship_id >= 0 and starship_id <= 100:
        return {
            "message": f"Hi there! Your starship ID: {starship_id} Delay: {time_delay}"
        }
    else:
        raise HTTPException(
            status_code=404, detail=f"Item with ID {starship_id} is not found"
        )
