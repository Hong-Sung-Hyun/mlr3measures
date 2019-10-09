#' @title Bias
#'
#' @description
#' Regression measure defined as \deqn{
#'   \frac{1}{n} \sum_{i=1}^n \left( t_i - r_i \right).
#' }{
#'   mean(t - r).
#' }
#' Good predictions score close to 0.
#'
#' @templateVar mid bias
#' @template regr_template
#'
#' @inheritParams regr_params
#' @export
bias = function(truth, response, ...) {
  mean(truth - response)
}

#' @include measures.R
add_measure(bias, "regr", -Inf, Inf, NA)