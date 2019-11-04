#' Estimate our (basic) entry model with only one variable for the market size
#'
#' @param data A \code{data.frame} object containing your data
#' @param Sm A string indicating the market size variable, present in \code{data}
#' @param y A string indicating the outcome variable, present in \code{data}
#' @param N_max An \code{integer} indicating the maximum number of competitors. Defaults to 5.
#' @return A tibble of the critical market sizes, as explained in Bresnahan and Reiss (1991)
#'
#' @import stats
#' @importFrom magrittr %>%
#' @importFrom dplyr as_tibble
#' @importFrom dplyr select
#' @importFrom dplyr tibble
#'
#' @examples
#' tb <- load_example_data()
#' em <- em_basic(tb, "Populacao", "n_agencias")
#' @export

em_basic <- function(data, Sm, y, N_max = 5) {

    ### to tibble
    data <- dplyr::as_tibble(data)


    # parameters --------------------------------------------------------------
    n <- nrow(data)
    N <- rep(0, n)
    N <- rep(0, n)


    # build N vector ----------------------------------------------------------
    n_ag <- data %>% dplyr::select(y)

    for (i in 1:(N_max-1)){
        N[n_ag == i] <- i
    }

    N[n_ag >= N_max] <- N_max


    # build auxiliary ---------------------------------------------------------
    aux <- aux_matrix(data, y, N_max, n)
    A1  <- aux[[1]]
    A2  <- aux[[2]]


    # initial conditions ------------------------------------------------------
    alpha0  <- 0.1*rep(1, N_max)
    gamma0  <- rep(1, N_max)
    params0 <- c(alpha0, gamma0)


    # size of market ----------------------------------------------------------
    S <- data %>%
         dplyr::select(Sm) %>%
         log() %>%
         as.matrix()


    # optimization ------------------------------------------------------------
    A <- 1*diag(2*N_max)
    b <- rep(0, 2*N_max)
    l_params <- length(params0)

    br.restricted1 <- stats::constrOptim(theta = params0, f = br1,
                                         grad = NULL, ui = A, ci = b,
                                         n = n, N_max = N_max,
                                         A1 = A1, A2 = A2,
                                         S = S, N = N,
                                         l_params = l_params
                                         )

    alpha_star_restricted1 <- A1%*%br.restricted1$par[1:N_max]
    gamma_star_restricted1 <- A2%*%br.restricted1$par[(N_max+1):(length(br.restricted1$par))]
    S_critical_restricted1 <- dplyr::tibble(market_size     = 1:N_max,
                                            critical_values = exp(gamma_star_restricted1/alpha_star_restricted1)
                                            )

}
