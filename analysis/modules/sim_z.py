import numpy as np

def sim_gwas_z(R, N, pve, eff_sign, n_signal, prior):
    np.random.seed(int(np.sum(np.array(R))))
    # get expected z-score assuming all causal
    z_true = np.random.normal(0, np.sqrt(N * pve)) * eff_sign
    # sparsify expected z-score to allow for n_signal causal
    # FIXME: might overlap if some prior is very high; 
    # thus not gauranteed to have exactly n_signal non-zeros
    # but it is quite convenient to call this function
    z_true *= np.random.multinomial(n_signal, prior)
    # get observed z-scores
    z = np.random.multivariate_normal(z_true, np.square(R) * np.sign(R))
    return z, z_true

def simulate(R, N, pve, eff_sign, n_signal, prior):
    z_true = {k:[] for k in R}
    z = {k:[] for k in R}
    for k in R:
        z[k], z_true[k] = sim_gwas_z(R[k], N, pve, eff_sign[k], n_signal, prior)
    return z, z_true, {k: sum(z_true[k]!=0) for k in z_true}
