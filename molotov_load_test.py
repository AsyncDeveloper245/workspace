#!/bin/env python3

import molotov


@molotov.scenario(100)
async def scenario_one(session):
   async with session.get("http://localhost:5000") as resp:
   assert resp.status == 200
