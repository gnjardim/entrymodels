#' Build our auxiliary matrices to estimate entry models
#'
#' @param data A \code{data.frame} object containing your data
#' @param y A string indicating the outcome variable
#' @param max An \code{integer} indicating the maximum number of competitors
#' @return A list of the auxiliary matrices
#'
#' @importFrom dplyr select
#' @importFrom magrittr %>%
aux_matrix <- function(data, y, max) {

    # get observations
    n <- nrow(data)

    # maximum number
    N_max <- max

    # number per market
    N <- rep(0, n)

    # get y variable
    n_ag <- data %>% dplyr::select(y)

    for (i in 1:(N_max-1)){
        N[n_ag == i] <- i
    }

    N[n_ag >= N_max] <- N_max

    # auxiliary matrix

    A1 <- (-1)*matrix(1, nrow = N_max, ncol = N_max, byrow = TRUE)

    for (i in 1:N_max){
        A1[i,1] <- 1
    }

    for (i in 1:N_max){
        for (j in 1:N_max){
            if (i < j){
                A1[i, j] <- 0
            }
        }
    }

    A2 <- matrix(1, nrow = N_max, ncol = N_max, byrow = TRUE)

    for (i in 1:N_max){
        for (j in 1:N_max){
            if (i < j){
                A2[i, j] <- 0
            }
        }
    }

    return(list(A1, A2))
}
