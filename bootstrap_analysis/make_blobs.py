#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 19 16:57:22 2023

@author: avicenna
"""


import PyRacmacs as pr
import pandas as pd


blobs_path = "./outputs/bootstrapped_map_bayesian.ace"
bootstrapped_map = pr.read_racmap(blobs_path)

map_with_blobs = pr.bootstrap_blobs(bootstrapped_map, conf=0.68,
                                    grid_spacing=0.25, smoothing=8)

ag_blobs, sr_blobs = map_with_blobs.get_blobs()

ag_vol, ag_maxsize = pr.analyse_blobs(ag_blobs)
sr_vol, sr_maxsize = pr.analyse_blobs(sr_blobs)

names = ["ag","sr"]

for indt,vol_type in enumerate([ag_maxsize, sr_maxsize]):
  df = pd.DataFrame(list(vol_type.values()), index=vol_type, dtype=object)
  df.to_csv(f"./tables/maxsize_{names[indt]}.csv", index=True)

for indt,vol_type in enumerate([ag_vol, sr_vol]):
  df = pd.DataFrame(list(vol_type.values()), index=vol_type, dtype=object)
  df.to_csv(f"./tables/vol_{names[indt]}.csv", index=True)
