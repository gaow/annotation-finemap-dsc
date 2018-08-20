
simulate_region: sim_region.R + R(data = readRDS(dataset);
                                  X = get_loci(data$X, M);
                                  R = lapply(1:length(X), function(i) round(cor(X[[i]]),4));
                                  eff_sign = get_sign(X);
                                  prior = get_prior(M, g, q);
                                  status = lapply(1:length(R), function(i) write.table(R[[i]],paste0(ld_file, '.', i),quote=F,col.names=F,row.names=F)))                           
  dataset: Shell{head -${n_units} ${data_file}}
  M: 500
  g: (3, 55), (4.5, 55), (6, 55)
  q: (0.1269, 0.00668)
  $eff_sign: eff_sign
  $R: R
  $prior: prior$prior
  $annotation: prior$annotation
  $ld_file: file(ld)
