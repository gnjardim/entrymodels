br1 <- function(params){

    ml <- rep(0, n)

    alpha <- params[1:(N_max)]
    gamma <- params[(N_max + 1):length(params0)]

    alpha1 <- A1%*%alpha
    gamma1 <- A2%*%gamma

    Pi_bar <- S%*%matrix(alpha1, nrow = 1, byrow = TRUE) -
              rep(1, n)%*%matrix(gamma1, nrow = 1, byrow = TRUE)

    ml[N == 0] <- log(1 - pnorm(Pi_bar[, 1][N == 0], mean = 0, sd = 1))

    for (j in 1:(N_max-1)){
        ml[N == j] <- log((pnorm(Pi_bar[, j][N == j], mean = 0, sd = 1)) -
                          (pnorm(Pi_bar[,(j + 1)][N == j], mean = 0, sd = 1)))
    }

    ml[N == N_max] = log(pnorm(Pi_bar[, N_max][N == N_max], mean = 0, sd = 1))

    f = -sum(ml)

    return(f)

}
