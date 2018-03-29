#' Mapcurves calculation
#'
#' It calculates the Mapcurves's goodness-of-fit (GOF)
#'
#' @param y DESC
#' @param x_name DESC
#' @param x DESC
#' @param y_name DESC
#' @param precision DESC
#'
#' @return A list
#'
#' @details DETAILS
#'
#' @references Hargrove, William W., Forrest M. Hoffman, and Paul F. Hessburg.
#' "Mapcurves: a quantitative method for comparing categorical maps."
#' Journal of Geographical Systems 8.2 (2006): 187.
#'
#' @importFrom sf st_intersection st_set_precision
#' @importFrom rlang enquo :=
#' @importFrom dplyr select
#'
#' @examples
#' # EXAMPLES
#'
#' @export
mapcurves_calc = function(x, x_name, y, y_name, precision = 1){

  stopifnot(inherits(st_geometry(x), "sfc_POLYGON") || inherits(st_geometry(x), "sfc_MULTIPOLYGON"))
  stopifnot(inherits(st_geometry(y), "sfc_POLYGON") || inherits(st_geometry(y), "sfc_MULTIPOLYGON"))
  stopifnot(st_crs(x) == st_crs(y) || !all(is.na(st_crs(x)), is.na(st_crs(y))))

  x_name = enquo(x_name)
  y_name = enquo(y_name)

  x = select(x, map1 := !!x_name)
  y = select(y, map2 := !!y_name)

  x = st_set_precision(x, precision)
  y = st_set_precision(y, precision)

  suppressWarnings({z = st_intersection(x, y)})

  z_df = intersection_prep(z)

  z = z_df^2 / tcrossprod(rowSums(z_df), colSums(z_df))

  # x = vector_regions(z, map1)
  # y = vector_regions(z, map2)
  # x$gof = apply(z, 2, function(x) max(x))
  # y$gof = apply(z, 1, function(x) max(x))

  mapcurves_result = mapcurves(z = z)
  result = list(x, y, mapcurves_result)
  return(result)
}
