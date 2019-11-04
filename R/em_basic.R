#' Estimate our (basic) entry model with only one variable for the market size
#'
#' @param data A \code{data.frame} object containing your data
#' @param Sm A string indicating the market size variable, present in \code{data}
#' @param y A string indicating the outcome variable, present in \code{data}
#' @param max An \code{integer} indicating the maximum number of competitors
#' @return A tibble of the critical market sizes, as explained in Bresnahan and Reiss (1991)
#'
#' @export
#' @import stats
#' @importFrom magrittr %>%
#' @importFrom dplyr as_tibble
#' @importFrom dplyr select
#' @importFrom dplyr tibble
em_basic <- function(data, Sm, y, max = 5) {

    ### to tibble
    data <- dplyr::as_tibble(data)


    # build auxiliary ---------------------------------------------------------
    aux <- aux_matrix(data, y, max)
    A1  <- aux[[1]]
    A2  <- aux[[2]]


    # initial conditions ------------------------------------------------------
    alpha0  <- 0.1*rep(1, max)
    gamma0  <- rep(1, max)
    params0 <- c(alpha0, gamma0)


    # size of market ----------------------------------------------------------
    S <- data %>% dplyr::select(Sm) %>% log()


    # optimization ------------------------------------------------------------
    N_max <- max
    A <- 1*diag(2*N_max)
    b <- rep(0, 2*N_max)

    br.restricted1 <- stats::constrOptim(theta = params0, f = br1, grad = NULL, ui = A, ci = b)

    alpha_star_restricted1 <- A1%*%br.restricted1$par[1:N_max]
    gamma_star_restricted1 <- A2%*%br.restricted1$par[(N_max+1):(length(br.restricted1$par))]
    S_critical_restricted1 <- exp(gamma_star_restricted1/alpha_star_restricted1) %>%
                              dplyr::tibble()

}
