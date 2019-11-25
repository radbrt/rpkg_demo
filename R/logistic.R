#' Logistic sigmoid function
#' Logistic sigmoid function for normalization.
#' @param x Input value
#' @examples
#' logistic_sigmoid(1.5)

logistic_sigmoid <- function(x) {
  1/(1+exp(-x))
}
