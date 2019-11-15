#' Basic Entry Model
#' @description Estimate our basic entry model with only one variable for the market size.
#'
#' @param data A \code{data.frame} object containing your data
#' @param Sm A string indicating the market size variable, present in \code{data}
#' @param y A string indicating the outcome variable, present in \code{data}
#' @param N_max An \code{integer} indicating the maximum number of competitors. Defaults to 5.
#' @param alpha0 A \code{vector} of type \code{numeric} and length \code{N_max} indicating the initial condition for alpha. Defaults to a vector of 0.1's.
#' @param gamma0 A \code{vector} of type \code{numeric} and length \code{N_max} indicating the initial condition for gamma. Defaults to a vector of 1's.
#' @return A tibble of critical market sizes, as explained in Bresnahan and Reiss (1991)
#'
#' @import stats
#' @importFrom magrittr %>%
#' @importFrom dplyr as_tibble
#' @importFrom dplyr select
#' @importFrom dplyr tibble
#'
#' @examples
#' \donttest{
#' tb <- data.frame(Sm = 1:5, y = 1:5)
#'
#' # estimate default model
#' em_n5 <- em_basic(tb, "Sm", "y")
#'
#' # estimate model with 3 competitors only
#' em_n3 <- em_basic(tb, "Sm", "y", N_max = 3)
#'
#' # estimate model with different initial conditions
#' em_difc <- em_basic(tb, "Sm", "y", alpha0 = rep(0.2, 5), gamma0 = rep(1.1, 5))
#' }
#'
#' \dontrun{
#' tb <- load_example_data()
#' em <- em_basic(tb, "Populacao", "n_agencias")
#' }
#'
#' @references
#' Bresnahan, T. F., & Reiss, P. C. (1991). Entry and competition in concentrated markets. Journal of political economy, 99(5), 977-1009.
#'
#' @author Guilherme N. Jardim, Department of Economics, Pontifical Catholic University of Rio de Janeiro
#'
#' @export

em_basic <- function(data, Sm, y, N_max = 5, alpha0 = rep(0.1, N_max), gamma0 = rep(1, N_max)) {

    ### to tibble
    data <- dplyr::as_tibble(data)


    # parameters --------------------------------------------------------------
    n <- nrow(data)
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
    S_critical_restricted1 <- dplyr::tibble(n_competitors   = 1:N_max,
                                            critical_values = exp(gamma_star_restricted1/alpha_star_restricted1)
                                            )

}
