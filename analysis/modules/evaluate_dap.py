def dap_summary(cluster, snp, z_true):
    signal_expected = [f'{idx+1}' for idx, i in enumerate(z_true) if i != 0]
    cluster = cluster.loc[cluster['cluster_prob'] > 0.95]
    if cluster.shape[0] == 0:
        return ["failed"] * 5
    # to return
    purity = cluster['cluster_prob'].tolist()
    cluster = [x.split(',') for x in cluster['snp']]
    signal_detected = sum(cluster, [])
    # to return
    size = [len(c) for c in cluster]
    snp = [snp.loc[snp['snp'].isin(c)] for c in cluster]
    top_snp = [s.loc[s['snp_prob'] == max(s['snp_prob'])]['snp'].tolist()[0] for s in snp]
    # to return
    is_top_true = [1 if x in signal_expected else 0 for x in top_snp]
    # to return
    is_recovered = [1 if x in signal_detected else 0 for x in signal_expected]
    # to return
    is_cs_true = [1 if len(set(x).intersection(signal_expected)) else 0 for x in cluster]
    return is_recovered, is_cs_true, is_top_true, size, purity

is_recovered = dict()
is_cs_true = dict()
is_top_true = dict()
size = dict()
purity = dict()
for k in posterior:
    is_recovered[k], is_cs_true[k], is_top_true[k], size[k], purity[k] = dap_summary(posterior[k]['set'], posterior[k]['snp'], z_true[k])
