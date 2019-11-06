#' Build our optimization function
#'
#' @param params Parameters to construct function
#' @param n Number of observations in \code{data}
#' @param N_max An \code{integer} indicating the maximum number of competitors
#' @param A1 Auxiliary matrix A1
#' @param A2 Auxiliary matrix A2
#' @param S1 First variable for size of the market
#' @param S2 Second variable for size of the market
#' @param N Vector of zeros
#' @return The function to be optimized
#'
#' @import stats

br2 <- function(params, n, N_max, A1, A2, S1, S2, N){

    ml <- rep(0, n)

    alpha <- params[1:(N_max)]
    gamma <- params[(N_max + 1):(2*N_max)]

    alpha1 <- A1%*%alpha
    gamma1 <- A2%*%gamma

    Pi_bar <- (S1 + params[2*N_max + 1]*S2)%*%matrix(alpha1, nrow = 1, byrow = TRUE) - rep(1, n)%*%matrix(gamma1, nrow = 1, byrow = TRUE)

    ml[N == 0] <- log(1 - stats::pnorm(Pi_bar[, 1][N == 0], mean = 0, sd = 1))

    for (j in 1:(N_max-1)){
        ml[N == j] <- log((stats::pnorm(Pi_bar[, j][N == j], mean = 0, sd = 1)) -
                          (stats::pnorm(Pi_bar[,(j + 1)][N == j], mean = 0, sd = 1)))
    }

    ml[N == N_max] = log(stats::pnorm(Pi_bar[, N_max][N == N_max], mean = 0, sd = 1))

    f = -sum(ml)

    return(f)

}
