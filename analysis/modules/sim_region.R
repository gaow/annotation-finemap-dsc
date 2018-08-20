get_loci = function(X, N) {
    segs = floor(ncol(X) / N)
    lapply(1:segs, function(i) X[,i:(i+N-1)])
}
get_prior = function(N, chunks, g, q) {
    foo = function(x) N * (q-1-g*q+g) * x^2 - (N*q-N-N*q*g+g-1) * x - 1
    p0 = uniroot(foo, lower=0, upper=1, tol = .Machine$double.eps^0.8)$root
    p1 = g * p0 / (1-p0+g*p0)
    per_chunk_len = N * q / chunks
    n_bins = floor(N/chunks)
    annotated = unlist(lapply(1:chunks, function(i) ((i-1) * n_bins + 1):((i-1) * n_bins + per_chunk_len)))
    prior = rep(p0, N)
    prior[annotated] = p1                          
    list(prior=prior, annotation=annotated)                          
}
get_sign = function(X) {
    lapply(1:length(X), function(i) apply(X[[i]], 2, function(x) (-1)^as.integer((mean(x)/2) > 0.5)))
}
