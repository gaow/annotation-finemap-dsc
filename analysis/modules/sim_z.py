import numpy as np

def sim_gwas_z(R, N, pve, eff_sign, n_signal, prior):
    np.random.seed(int(np.sum(np.array(R[:,1]))))
    # get expected z-score assuming all causal
    # it really does not matter to our purpose whether Z is positive or negative
    # because it is only a matter of allele coding ...
    z_true = np.random.normal(0, np.sqrt(N * pve)) * eff_sign
    # sparsify expected z-score to allow for n_signal causal
    # FIXME: might overlap if some prior is very high; 
    # thus not gauranteed to have exactly n_signal non-zeros
    # but it is quite convenient to call this function
    z_true *= np.random.multinomial(n_signal, prior)
    # get observed z-scores
    # FIXME: there is a PSD warning I cannot get rid of for now
    # simply ignore it ...
    z = np.random.multivariate_normal(np.ravel(R @ z_true), R, check_valid = 'ignore')
    return z, z_true

def simulate(R, N, pve, eff_sign, n_signal, prior):
    z_true = {k:[] for k in R}
    z = {k:[] for k in R}
    for k in R:
        z[k], z_true[k] = sim_gwas_z(R[k], N, pve, eff_sign[k], n_signal, prior)
    return z, z_true, {k: sum(z_true[k]!=0) for k in z_true}
