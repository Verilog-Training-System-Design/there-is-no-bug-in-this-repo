wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/WangYanTing/there-is-no-bug-in-this-repo/build/top.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/i_DRAM"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/dram"
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 )} 
wvSetPosition -win $_nWave1 {("G1" 5)}
wvGetSignalClose -win $_nWave1
wvZoomAll -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 0.000000 239282516.808511
wvZoom -win $_nWave1 164443091.338615 211960186.875057
wvSelectGroup -win $_nWave1 {G2}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 3 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSelectGroup -win $_nWave1 {G2}
wvSetCursor -win $_nWave1 191268345.272648 -snap {("G2" 0)}
wvZoom -win $_nWave1 197570257.943084 204815772.510697
wvZoom -win $_nWave1 198135510.852530 199389344.579124
wvZoom -win $_nWave1 198237773.886939 198778434.103796
wvZoom -win $_nWave1 198283787.522377 198329034.263930
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 200282313.633792 212243369.987946
wvZoom -win $_nWave1 205092185.231434 207357151.221902
wvZoom -win $_nWave1 206224668.226634 207068006.627340
wvZoom -win $_nWave1 206637365.741839 206869433.330118
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 206826167.537727 206853488.970106
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 2779358464.468085 2879570800.567376
wvZoom -win $_nWave1 2816458350.598376 2822997027.847407
wvZoom -win $_nWave1 2817997954.035361 2818985711.662342
wvZoom -win $_nWave1 2818192703.411100 2818393057.085793
wvZoomOut -win $_nWave1
wvSelectGroup -win $_nWave1 {G2}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectGroup -win $_nWave1 {G2}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvMoveSelected -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/dram"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/IFID_pipe"
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 )} 
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 )} 
wvSetPosition -win $_nWave1 {("G2" 2)}
wvGetSignalClose -win $_nWave1
wvSetSearchMode -win $_nWave1 -value 
wvSetSearchMode -win $_nWave1 -value 79703
wvSearchPrev -win $_nWave1
wvSearchPrev -win $_nWave1
wvSearchPrev -win $_nWave1
wvSelectGroup -win $_nWave1 {G3}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSearchPrev -win $_nWave1
wvSearchPrev -win $_nWave1
wvSearchPrev -win $_nWave1
wvSearchPrev -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 4656162.561935 -snap {("G2" 1)}
wvSearchNext -win $_nWave1
wvZoom -win $_nWave1 201088020.643561 234845199.217589
wvSetCursor -win $_nWave1 209323814.565107 -snap {("G3" 0)}
wvSetCursor -win $_nWave1 208749224.291506 -snap {("G3" 0)}
wvSetCursor -win $_nWave1 208318281.586306 -snap {("G3" 0)}
wvZoom -win $_nWave1 209323814.565107 210137817.452707
wvZoom -win $_nWave1 209565128.896318 209652302.255203
wvZoomOut -win $_nWave1
wvSelectGroup -win $_nWave1 {G3}
wvSetPosition -win $_nWave1 {("G3" 0)}
wvMoveSelected -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/dram"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/IFID_pipe"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/Regster_file"
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top_tb/TOP/CPU/cpu/Regster_file/clk} \
{/top_tb/TOP/CPU/cpu/Regster_file/rd_reg1_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/rd_reg1_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/rd_reg2_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/rd_reg2_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_reg_addr\[4:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top_tb/TOP/CPU/cpu/Regster_file/clk} \
{/top_tb/TOP/CPU/cpu/Regster_file/rd_reg1_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/rd_reg1_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/rd_reg2_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/rd_reg2_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_reg_addr\[4:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave1 {("G3" 7)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G4" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 1)}
wvSetPosition -win $_nWave1 {("G4" 1)}
wvSetPosition -win $_nWave1 {("G4" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 0)}
wvSetPosition -win $_nWave1 {("G4" 1)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSelectGroup -win $_nWave1 {G5}
wvSelectSignal -win $_nWave1 {( "G3" 1 )} 
wvSelectSignal -win $_nWave1 {( "G3" 2 )} 
wvSelectSignal -win $_nWave1 {( "G3" 2 3 4 5 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSelectGroup -win $_nWave1 {G5}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/IFID_pipe"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/dram"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/Regster_file"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/MEMWB_pipe"
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top_tb/TOP/CPU/cpu/Regster_file/clk} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_reg_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/MEM_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/WB_data_memory\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvAddSignal -win $_nWave1 -group {"G5" \
}
wvSelectSignal -win $_nWave1 {( "G3" 4 5 )} 
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top_tb/TOP/CPU/cpu/Regster_file/clk} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_reg_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/MEM_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/WB_data_memory\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvAddSignal -win $_nWave1 -group {"G5" \
}
wvSelectSignal -win $_nWave1 {( "G3" 4 5 )} 
wvSetPosition -win $_nWave1 {("G3" 5)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G3" 5 )} 
wvSelectSignal -win $_nWave1 {( "G3" 5 )} 
wvSelectSignal -win $_nWave1 {( "G3" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSearchNext -win $_nWave1
wvSearchPrev -win $_nWave1
wvSearchPrev -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/IFID_pipe"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/Regster_file"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/dram"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/MEMWB_pipe"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/alu"
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top_tb/TOP/CPU/cpu/Regster_file/clk} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_reg_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/MEM_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/WB_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/alu/out\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvAddSignal -win $_nWave1 -group {"G5" \
}
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top_tb/TOP/CPU/cpu/Regster_file/clk} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_reg_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/MEM_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/WB_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/alu/out\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvAddSignal -win $_nWave1 -group {"G5" \
}
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSetPosition -win $_nWave1 {("G3" 6)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 2781403614.184397 2879570800.567376
wvZoom -win $_nWave1 2815796940.477044 2824430083.109305
wvZoom -win $_nWave1 2817952164.736969 2818595058.337244
wvZoom -win $_nWave1 2818212057.893558 2818264492.477978
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 1421330.592309 -snap {("G2" 1)}
wvSelectSignal -win $_nWave1 {( "G3" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSearchNext -win $_nWave1
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 209606106.907330 -snap {("G2" 1)}
wvSetCursor -win $_nWave1 209597776.874061 -snap {("G2" 1)}
wvSetCursor -win $_nWave1 209604619.401389 -snap {("G2" 1)}
wvSelectSignal -win $_nWave1 {( "G3" 5 )} 
wvSelectSignal -win $_nWave1 {( "G3" 4 )} 
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top_tb"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/IFID_pipe"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/MEMWB_pipe"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/Regster_file"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/dram"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/alu"
wvGetSignalSetScope -win $_nWave1 "/top_tb/TOP/CPU/cpu/MEMWB_pipe"
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top_tb/TOP/CPU/cpu/Regster_file/clk} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_reg_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/MEM_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/WB_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/alu/out\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/MEM_rd_data\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvAddSignal -win $_nWave1 -group {"G5" \
}
wvSelectSignal -win $_nWave1 {( "G3" 7 )} 
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/dram/DRAM_CASn} \
{/top_tb/TOP/dram/DRAM_RASn} \
{/top_tb/TOP/dram/DRAM_WEn\[3:0\]} \
{/top_tb/TOP/dram/DRAM_D\[31:0\]} \
{/top_tb/TOP/dram/DRAM_Q\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top_tb/TOP/CPU/cpu/IFID_pipe/instr\[31:0\]} \
{/top_tb/TOP/CPU/cpu/IFID_pipe/pc\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top_tb/TOP/CPU/cpu/Regster_file/clk} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_reg_addr\[4:0\]} \
{/top_tb/TOP/CPU/cpu/Regster_file/w_data\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/MEM_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/WB_data_memory\[31:0\]} \
{/top_tb/TOP/CPU/cpu/alu/out\[31:0\]} \
{/top_tb/TOP/CPU/cpu/MEMWB_pipe/MEM_rd_data\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvAddSignal -win $_nWave1 -group {"G5" \
}
wvSelectSignal -win $_nWave1 {( "G3" 7 )} 
wvSetPosition -win $_nWave1 {("G3" 7)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 209685390.973985 -snap {("G2" 1)}
