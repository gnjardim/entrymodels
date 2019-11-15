#' Two-Variable Entry Model
#' @description Estimate entry model with two variables for the market size.
#'
#' @param data A \code{data.frame} object containing your data
#' @param Sm1 A string indicating the main market size variable, present in \code{data}
#' @param Sm2 A string indicating the second market size variable, present in \code{data}
#' @param y A string indicating the outcome variable, present in \code{data}
#' @param N_max An \code{integer} indicating the maximum number of competitors. Defaults to 5.
#' @return A tibble of critical market sizes, as explained in Bresnahan and Reiss (1991)
#'
#' @import stats
#' @importFrom magrittr %>%
#' @importFrom dplyr as_tibble
#' @importFrom dplyr select
#' @importFrom dplyr tibble
#'
#' @examples
#' tb <- data.frame(Sm1 = 1:5, Sm2 = 1:5, y = 1:5)
#'
#' # estimate default model
#' em_n5 <- em_2var(tb, "Sm1", "Sm2", "y")
#'
#' # estimate model with 3 competitors only
#' em_n3 <- em_2var(tb, "Sm", "Sm2", "y", N_max = 3)
#'
#' \dontrun{
#' tb <- load_example_data()
#' em <- em_2var(tb, "Populacao", "RendaPerCapita", "n_agencias")
#' }
#'
#' @references
#' Bresnahan, T. F., & Reiss, P. C. (1991). Entry and competition in concentrated markets. Journal of political economy, 99(5), 977-1009.
#'
#' @author Guilherme N. Jardim, Department of Economics, Pontifical Catholic University of Rio de Janeiro
#'
#' @export

em_2var <- function(data, Sm1, Sm2, y, N_max = 5) {

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
    k <- 2
    alpha0  <- rep(0.1, N_max)
    gamma0  <- rep(1, N_max)
    params0 <- c(alpha0, gamma0)


    # size of market ----------------------------------------------------------
    S1 <- data %>%
          dplyr::select(Sm1) %>%
          log() %>%
          as.matrix()

    S2 <- data %>%
          dplyr::select(Sm2) %>%
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
                                         S = S1, N = N,
                                         l_params = l_params
                                         )


    # initial conditions for second optim -------------------------------------
    alpha0  <- br.restricted1$par[1:N_max]
    gamma0  <- br.restricted1$par[(N_max+1):(length(br.restricted1$par))]
    beta0   <- rep(0.0001, k - 1)
    params0 <- c(alpha0, gamma0, beta0)


    # main optimization -------------------------------------------------------
    A <- diag(2*N_max + 1)
    A[2*N_max + 1, 2*N_max + 1] <- 0

    b <- rep(0, 2*N_max + 1)
    b[2*N_max + 1] <- -0.00001

    br.restricted2 <- stats::constrOptim(theta = params0, f = br2,
                                         grad = NULL, ui = A, ci = b,
                                         n = n, N_max = N_max,
                                         A1 = A1, A2 = A2,
                                         S1 = S1, S2 = S2,
                                         N = N
                                         )

    alpha_star_restricted2 <- A1%*%br.restricted2$par[1:N_max]
    gamma_star_restricted2 <- A2%*%br.restricted2$par[(N_max+1):(2*N_max)]

    S_critical_restricted2 <- dplyr::tibble(n_competitors   = 1:N_max,
                                            critical_values = exp(gamma_star_restricted2/alpha_star_restricted2 -
                                                                  br.restricted2$par[2*N_max + 1]*mean(S2))
                                            )


}
