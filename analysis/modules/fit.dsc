
dap: fit_dap.py + Python(posterior = dap_batch_z(z, ld, cache, None, args))
  ld: $ld_file
  z: $z
  args: "-ld_control 0.20 --all"
  cache: file(DAP)
  $posterior: posterior

dapa(dap): fit_dap.py + Python(posterior = dap_batch_z(z, ld, cache, prior, args))
  prior: $prior
