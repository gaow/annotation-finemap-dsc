
dap: fit_dap.py + Python(posterior = dap_batch_z(z, ld, L, cache, None, args))
  ld: $ld_file
  z: $z
  L: $L
  args: "-ld_control 0.20 --all"
  cache: file(DAP)
  $posterior: posterior

dapa(dap): fit_dap.py + Python(posterior = dap_batch_z(z, ld, L, cache, prior, args))
  prior: $prior
