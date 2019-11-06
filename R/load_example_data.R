#' Load example dataset
#'
#' @return Example dataset as tibble
#' @importFrom readr read_csv
#'
#' @author Guilherme N. Jardim, Department of Economics, Pontifical Catholic University of Rio de Janeiro
#'
#' @export

load_example_data <- function() {

    data <- readr::read_csv(system.file("extdata", "censo.csv",
                                        package = "entrymodels"))

}
