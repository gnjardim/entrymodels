em_basic <- function(data, Sm, y, max = 5) {

    ### to tibble
    data <- as_tibble(data)


    # build auxiliary ---------------------------------------------------------
    aux <- aux_matrix(data, y, max)
    A1  <- aux[[1]]
    A2  <- aux[[2]]


    # initial conditions ------------------------------------------------------
    alpha0  <- 0.1*rep(1, max)
    gamma0  <- rep(1, max)
    params0 <- c(alpha0, gamma0)


    # size of market ----------------------------------------------------------
    S <- data %>% select(Sm) %>% log()


    # optimization ------------------------------------------------------------
    A <- 1*diag(2*N_max)
    b <- rep(0, 2*N_max)

    br.restricted1 <- constrOptim(theta = params0, f = br1, grad = NULL, ui = A, ci = b)

    alpha_star_restricted1 <- A1%*%br.restricted1$par[1:N_max]
    gamma_star_restricted1 <- A2%*%br.restricted1$par[(N_max+1):(length(br.restricted1$par))]
    S_critical_restricted1 <- exp(gamma_star_restricted1/alpha_star_restricted1)

}
