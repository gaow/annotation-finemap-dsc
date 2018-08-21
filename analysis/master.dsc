#!/usr/bin/env dsc
%include modules/zzz

DSC:
    define:
        fit: dap, dapa
    # FIXME: I should run 2 separate pipelines for dap and dap
    # because dap only runs one scenario but dapa runs multiple
    # now I in fact run the same dap multiple times; but i can live with it
    # because dap is really fast in this simulation and the result is easier to parse
    # with this DSC logic.
    run: sample_region * simulate_prior * simulate_z * fit * evaluate
    exec_path: modules
    global:
        data_file: gtex-manifest.txt
        n_units: 150
        unit_length: 500
    output: xh_grant
