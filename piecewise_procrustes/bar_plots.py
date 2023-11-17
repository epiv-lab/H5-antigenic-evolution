#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 17 19:00:28 2023

@author: avicenna
"""

import PyRacmacs as pr
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


if __name__=="__main__":

  map_3D = pr.read_racmap("../map_making/output/map_3D_conservative_sd_1.5_n4.ace")
  map_4D = pr.read_racmap("../map_making/output/map_4D_conservative_sd_1.5_n4.ace")

  compare_sera = True

  for npieces in [1,2,3,4,5]:

    nag = map_3D.num_antigens
    nsr = map_3D.num_sera

    df_ag = pd.read_csv(f"./output/ag_ppc_data_{npieces}.csv", header=0,
                        index_col=0)
    df_sr = pd.read_csv(f"./output/sr_ppc_data_{npieces}.csv", header=0,
                        index_col=0)

    pc_data_ag = df_ag.iloc[:,:3].values
    pc_data_sr = df_sr.iloc[:,:3].values

    fig1,ax1 = plt.subplots(1,1, figsize=(0.175*nag+1, 7.5))

    ax1.bar(map_3D.ag_names, np.linalg.norm(pc_data_ag, axis=1),
            facecolor="grey", edgecolor="black")

    ax1.set_xticks(range(nag))
    ax1.set_xticklabels(map_3D.ag_names, rotation=90)
    ax1.set_xlim(-1, nag)
    ax1.set_ylim([0,8])
    ax1.set_ylabel("Mean Squared Distance")
    ax1.grid("on", alpha=0.3)

    fig1.tight_layout()
    fig1.savefig(f"./visuals/bars_ag_{npieces}.png")


    if compare_sera:

      fig2,ax2 = plt.subplots(1,1, figsize=(0.175*nsr+1, 6.1))

      ax2.bar(map_3D.sr_names, np.linalg.norm(pc_data_sr, axis=1),
              facecolor="grey", edgecolor="black")
      ax2.set_xticks(range(nsr))
      ax2.set_xticklabels(map_3D.sr_names, rotation=90)
      ax2.set_xlim(-1, nsr)
      ax2.set_ylim([0,8])
      ax2.set_ylabel("Mean Squared Distance")
      ax2.grid("on", alpha=0.3)

      fig2.tight_layout()
      fig2.savefig(f"./visuals/bars_sr_{npieces}.png")
