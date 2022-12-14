#!/bin/env python3

import molotov


@molotov.scenario(30)
async def scenario_one(session):
   async with session.get("http://localhost:5000") as resp:
   assert resp.status == 200

   
@molotov.scenario(70)
async def scenario_post(session):
    resp = await session.post("http://localhost:5000", params={'q': 'devops'})
    redirect_status = resp.history[0].status
    error = "unexpected redirect status: %s" % redirect_status
    assert redirect_status == 301, error
   
#Run this scriot in the command line with the command below
# molotov -v -r 100 molotov_load_test.py
