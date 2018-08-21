
sample_region: sim_region.R + R(data = readRDS(dataset);
                                X = get_loci(data$X, M);
                                R = lapply(1:length(X), function(i) round(cor(X[[i]]),4));
                                eff_sign = get_sign(X);
                                status = lapply(1:length(R), function(i) write.table(R[[i]],paste0(ld_file, '.', i),quote=F,col.names=F,row.names=F)))                           
  dataset: Shell{head -${n_units} ${data_file}}
  M: 500
  $eff_sign: eff_sign
  $R: R
  $ld_file: file(ld)

simulate_prior: sim_region.R + R(prior = get_prior(nrow(read.table(paste0(ld_file, '.1'))), eparam[[1]], eparam[[2]]))
  ld_file: $ld_file
  # enrichment parameters:
  # should be (gamma, p) where gamma is a vector of odds ratios, p is the corresponding vector of proportions of annotated regions
  eparam: ((3, 55), (0.1269, 0.00668)), ((5, 55), (0.1269, 0.00668)), ((7, 55), (0.1269, 0.00668)), (3, 0.1336), (5, 0.1336), (7, 0.1336)
  $prior: prior$prior
  $annotation: prior$annotation
