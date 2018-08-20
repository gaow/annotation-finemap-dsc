#!/usr/bin/env dsc
%include modules/zzz

DSC:
    define:
        fit: dap, dapa
    run: simulate_region * simulate_z * fit * evaluate
    exec_path: modules
    global:
        data_file: gtex-manifest.txt
        n_units: 150
    output: xh_grant
