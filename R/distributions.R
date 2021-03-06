#' Setup Distributions.jl
#'
#' This function initializes the Distributions package that many of the bigsimr
#' functions work with.
#'
#' @return Return the imported wrapper of Distributions.jl Julia package
#' @examples
#' ## distributions_setup() is time-consuming and requires Julia+Distributions.jl
#' \dontrun{
#'   library(bigsimr)
#'   bs   <- bigsimr::bigsimr_setup()
#'   dist <- bigsimr::distributions_setup()
#'
#'   JuliaCall::julia_eval('using Random; Random.seed!(1);')
#'   # Generate random target correlation matrix
#'   target_corr <- bs$cor_randPD(3)
#'   # Set the margins of variables
#'   margins <- c(dist$Binomial(20, 0.2), dist$Beta(2, 3), dist$LogNormal(3, 1))
#'   # Adjust target correlation matrix using Pearson matching
#'   adjusted_corr <- bs$pearson_match(target_corr, margins)
#'   # Generate random vectors
#'   x <- bs$rvec(10000, adjusted_corr, margins)
#' }
#' @export
distributions_setup <- function() {
  JuliaCall::julia_install_package_if_needed("Distributions")
  JuliaCall::julia_library("Distributions")
  functions <- JuliaCall::julia_eval(
    "filter(isascii, replace.(string.(propertynames(Distributions)),\"!\"=>\"_bang\"))"
  )
  functions <- c(functions, "rand")
  dist <- JuliaCall::julia_pkg_import("Distributions", functions)
  dist
}
