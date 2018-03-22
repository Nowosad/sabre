#' Mapcurves calculation
#'
#' It calculates the Mapcurves's goodness-of-fit (GOF)
#'
#' @param y DESC
#' @param x_name DESC
#' @param x DESC
#' @param y_name DESC
#'
#' @return A list
#'
#' @details DETAILS
#'
#' @references Hargrove, William W., Forrest M. Hoffman, and Paul F. Hessburg.
#' "Mapcurves: a quantitative method for comparing categorical maps."
#' Journal of Geographical Systems 8.2 (2006): 187.
#'
#' @importFrom sf st_intersection
#' @importFrom rlang enquo
#'
#' @examples
#' # EXAMPLES
#'
#' @export
mapcurves_calc = function(x, x_name, y, y_name){

  x = st_set_precision(x, 1)
  y = st_set_precision(y, 1)

  suppressWarnings({z = st_intersection(x, y)})

  z_df = intersection_prep(z, !!enquo(x_name), !!enquo(y_name))

  z = z_df^2 / tcrossprod(rowSums(z_df), colSums(z_df))

  # x$gof = apply(z, 2, function(x) max(x))
  # y$gof = apply(z, 1, function(x) max(x))

  mapcurves_result = mapcurves(z = z)
  result = list(x, y, mapcurves_result)
  return(result)
}
