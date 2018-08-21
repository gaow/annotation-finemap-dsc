CorrectCM <- function(CM)
  {
  n <- dim(var(CM))[1L]
  E <- eigen(CM)
  CM1 <- E$vectors %*% tcrossprod(diag(pmax(E$values, 0), n), E$vectors)
  Balance <- diag(1/sqrt(diag(CM1)))
  CM2 <- Balance %*% CM1 %*% Balance  
  return(CM2)
}

get_loci = function(X, N) {
    segs = floor(ncol(X) / N)
    lapply(1:segs, function(i) X[,i:(i+N-1)])
}
get_prior = function(M, g, q) {
    foo = function(x) M * (sum(q * g * x / (1 - x + g * x)) + (1 - sum(q)) * x) - 1
    p0 = uniroot(foo, lower=0, upper=1, tol = .Machine$double.eps^0.8)$root
    p1 = g * p0 / (1-p0+g*p0)
    n_anns = floor(M * q)
    annotated = lapply(1:length(n_anns), function(i) sample(c(rep(1,n_anns[i]), rep(0, M - n_anns[i]))))
    prior = rep(p0, M)
    annotation = rep(0, M)
    for (i in 1:length(p1)) {
        prior[which(annotated[[i]] == 1)] = p1[i]
        annotation = annotation + annotated[[i]]
    }
    list(prior=prior, annotation=annotation)   
}
get_sign = function(X) {
    lapply(1:length(X), function(i) apply(X[[i]], 2, function(x) (-1)^as.integer((mean(x)/2) > 0.5)))
}
