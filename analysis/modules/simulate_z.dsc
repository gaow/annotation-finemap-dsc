simulate_z: sim_z.py + Python(z, z_true, L = simulate(R, N, pve, eff_sign, n_signal, prior))
  R: $R
  eff_sign: $eff_sign
  prior: $prior
  N: 50000, 80000, 150000
  n_signal: 1
  pve: 1.34E-4
  $z: z
  $z_true: z_true
  $L: L
