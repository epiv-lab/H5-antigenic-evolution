#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb  8 01:36:24 2023

@author: avicenna
"""

import PyRacmacs as pr
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

if __name__=="__main__":

  map_3D = pr.read_racmap("../map_making/output/map_3D_conservative_sd_1.5_n4.ace")
  map_4D = pr.read_racmap("../map_making/output/map_4D_conservative_sd_1.5_n4.ace")

  final_stresses = []

  cols = ["dim1", "dim2", "dim3", "dim4", "label"]

  compare_sera = True
  load = False

  for npieces in [1,2,3,4,5]:

    _,final_labels,_,stresses = pr.piecewise_procrustes(map_3D, map_4D, npieces,
                                                        ninitial_conditions=500,
                                                        num_cpus=8,
                                                        compare_sera=compare_sera)
    pc_data =\
      pr.piecewise_procrustes_data(map_3D, map_4D, labels=final_labels,
                                   compare_sera=compare_sera)

    nag = map_3D.num_antigens
    nsr = map_3D.num_sera

    final_stresses.append(stresses[-1]/(nag+nsr))

    df_ag = pd.DataFrame(np.concatenate([pc_data[:nag,:].astype(object),
                                         final_labels[:nag,None]], axis=1),
                                         index = map_3D.ag_names,
                                         columns=cols)

    df_ag.to_csv(f"./output/ag_ppc_data_{npieces}.csv", header=True, index=True)

    if compare_sera:
      df_sr = pd.DataFrame(np.concatenate([pc_data[nag:nsr+nag,:].astype(object),
                                           final_labels[nag:nsr+nag,None]], axis=1),
                                           index = map_3D.sr_names,
                                           columns=cols)
      df_sr.to_csv(f"./output/sr_ppc_data_{npieces}.csv", header=True, index=True)





  fig,ax = plt.subplots(1,1, figsize=(5,5))

  ax.plot([1,2,3,4,5], final_stresses, marker='o', markerfacecolor="none",
          markeredgecolor="black", color="black", alpha=0.6)


  ax.grid("on", alpha=0.5)
  ax.set_xticks([1,2,3,4,5])
  ax.set_ylabel("Mean Squared Distance")
  ax.set_xlabel("Number of pieces")
  ax.set_ylim(0, 5)

  fig.tight_layout()
  fig.savefig("./visuals/msd.png")
