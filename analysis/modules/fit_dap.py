import subprocess
import pandas as pd
import numpy as np

def write_dap_z(z, prefix):
    '''z-score vesion of dap input is the same as FINEMAP'''
    ids = np.array([str(i+1) for i in range(z.shape[0])])
    with open(f'{prefix}.z', 'w') as f:
        np.savetxt(f,  np.vstack((ids, z)).T, fmt = '%s', delimiter = ' ')

def write_prior(prior, prefix):
    with open(f'{prefix}.prior', 'w') as f:
        f.write('\n'.join([f'{i+1}\t{p}' for i, p in enumerate(prior)]))

def run_dap_z(ld, r, prior, prefix, args):
    cmd = ['dap-g', '-d_z', f'{prefix}.z', '-d_ld', f'{ld}.{r}', '-o', f'{prefix}.result', '--output_all'] + ' '.join(args).split()
    if prior is not None:
        cmd.extend(['-p', f'{prefix}.prior'])
    subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()    
    
def extract_dap_output(prefix):
    out = [x.strip().split() for x in open(f'{prefix}.result').readlines()]
    pips = []
    clusters = []
    still_pip = True
    for line in out:
        if len(line) == 0:
            continue
        if len(line) > 2 and line[2] == 'cluster_pip':
            still_pip = False
            continue
        if still_pip and (not line[0].startswith('((')):
            continue
        if still_pip:
            pips.append([line[1], float(line[2]), float(line[3]), int(line[4])])
        else:
            clusters.append([len(clusters) + 1, float(line[2]), float(line[3])])
    pips = pd.DataFrame(pips, columns = ['snp', 'snp_prob', 'snp_log10bf', 'cluster'])
    clusters = pd.DataFrame(clusters, columns = ['cluster', 'cluster_prob', 'cluster_avg_r2'])
    clusters = pd.merge(clusters, pips.groupby(['cluster'])['snp'].apply(','.join).reset_index(), on = 'cluster')
    return {'snp': pips, 'set': clusters}

def dap_single_z(z, ld, prefix, r, prior, args):
    write_dap_z(z,prefix)
    if prior is not None:
        write_prior(prior, prefix)
    run_dap_z(ld, r, prior, prefix, args)
    return extract_dap_output(prefix)


def dap_batch_z(Z, ld, prefix, prior, *args):
    return dict([(k, dap_single_z(Z[k], ld, f'{prefix}_condition_{k}', k, prior, args)) for k in Z])
