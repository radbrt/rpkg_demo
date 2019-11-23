#' Hyperbolic tangent function
#' Hypertan function for normalization.
#' @param x Input value
#' @examples
#' hypertan(1.5)
#'
hypertan <- function(x) {
  (exp(x)-exp(-x))/(exp(x)+exp(-x))
}
