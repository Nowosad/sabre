#' Mapcurves calculation
#'
#' It calculates the Mapcurves's goodness-of-fit (GOF)
#'
#' @param x An object of class `sf` with a `POLYGON` or `MULTIPOLYGON` geometry type or a spatial raster object of class `RasterLayer`, `SpatRaster`, or `stars`.
#' @param x_name A name of the column with regions/clusters names.
#' @param y An object of class `sf` with a `POLYGON` or `MULTIPOLYGON` geometry type or a spatial raster object of class `RasterLayer`, `SpatRaster`, or `stars`.
#' @param y_name A name of the column with regions/clusters names.
#' @inheritParams sf::st_set_precision
#'
#' @return A list with four elements:
#' * "map1" - the sf object containing the first map used for calculation of GOF
#' * "map2" - the sf object containing the second map used for calculation of GOF
#' * "ref_map" - the map used as a reference ("x" or "y")
#' * "gof" - the Mapcurves's goodness of fit value
#'
#' @references Hargrove, William W., Forrest M. Hoffman, and Paul F. Hessburg.
#' "Mapcurves: a quantitative method for comparing categorical maps."
#' Journal of Geographical Systems 8.2 (2006): 187.
#'
#' @importFrom sf st_intersection st_set_precision st_crs st_geometry st_cast
#' @importFrom rlang enquo :=
#' @importFrom dplyr select mutate_if
#' @importFrom tibble data_frame
#' @importFrom raster stack crosstab
#' @importFrom tidyr spread
#'
#' @examples
#' library(sf)
#' data("regions1")
#' data("regions2")
#'
#' mc = mapcurves_calc(x = regions1, y = regions2, x_name = z, y_name = z)
#' mc
#'
#' plot(mc$map1)
#' plot(mc$map2)
#'
#' library(raster)
#' data("partitions1")
#' data("partitions2")
#' mc2 = mapcurves_calc(x = partitions1, y = partitions2)
#' mc2
#'
#' plot(mc2$map1)
#' plot(mc2$map2)
#'
#' @aliases mapcurves_calc
#' @rdname mapcurves_calc
#'
#' @export
mapcurves_calc = function(x,
                          y,
                          x_name,
                          y_name,
                          precision = NULL){
  UseMethod("mapcurves_calc")
}

#' @name mapcurves_calc
#' @export
mapcurves_calc.sf = function(x, y, x_name, y_name, precision = NULL){

  stopifnot(inherits(st_geometry(x), "sfc_POLYGON") || inherits(st_geometry(x), "sfc_MULTIPOLYGON"))
  stopifnot(inherits(st_geometry(y), "sfc_POLYGON") || inherits(st_geometry(y), "sfc_MULTIPOLYGON"))
  stopifnot(st_crs(x) == st_crs(y) || !all(is.na(st_crs(x)), is.na(st_crs(y))))

  x_name = enquo(x_name)
  y_name = enquo(y_name)

  x = select(x, map1 := !!x_name)
  x = mutate_if(x, is.factor, as.character)
  x = mutate_if(x, is.numeric, as.character)
  suppressWarnings({x = st_cast(x, "POLYGON")})

  y = select(y, map2 := !!y_name)
  y = mutate_if(y, is.factor, as.character)
  y = mutate_if(y, is.numeric, as.character)
  suppressWarnings({y = st_cast(y, "POLYGON")})

  if(!is.null(precision)){
    x = st_set_precision(x, precision)
    y = st_set_precision(y, precision)
  }

  suppressWarnings({z = st_intersection(x, y)})
  z = st_collection_extract(z)

  z_df = intersection_prep(z)

  z = z_df^2 / tcrossprod(rowSums(z_df), colSums(z_df))

  # x = vector_regions(z, map1)
  # y = vector_regions(z, map2)
  # x$gof = apply(z, 2, function(x) max(x))
  # y$gof = apply(z, 1, function(x) max(x))

  mapcurves_result = mapcurves(z = z)
  result = list(map1 = x, map2 = y,
                ref_map = mapcurves_result$ref_map, gof = mapcurves_result$gof)
  class(result) = c("mapcurves_vector")
  return(result)
}

#' @name mapcurves_calc
#' @export
mapcurves_calc.stars = function(x, y, x_name = NULL, y_name = NULL, precision = NULL){
  mapcurves_calc(methods::as(x, "Raster"), methods::as(y, "Raster"),
                x_name = x_name, y_name = y_name, precision = precision)
}

#' @name mapcurves_calc
#' @export
mapcurves_calc.SpatRaster = function(x, y, x_name = NULL, y_name = NULL, precision = NULL){
  mapcurves_calc(methods::as(x, "Raster"), methods::as(y, "Raster"),
                 x_name = x_name, y_name = y_name, precision = precision)
}

#' @name mapcurves_calc
#' @export
mapcurves_calc.RasterLayer = function(x, y, x_name = NULL, y_name = NULL, precision = NULL){

  stopifnot(inherits(x, "RasterLayer"))
  stopifnot(inherits(y, "RasterLayer"))
  z = stack(x, y)

  z_df = t(crosstab(z))
  # z_df = na.omit(z_df)
  # z_df = spread(z_df, "Var1", "Freq")
  # rownames(z_df) = z_df$Var2
  # z_df = z_df[-1]

  z = z_df^2 / tcrossprod(rowSums(z_df), colSums(z_df))

  mapcurves_result = mapcurves(z = z)
  result = list(map1 = x, map2 = y,
                ref_map = mapcurves_result$ref_map, gof = mapcurves_result$gof)
  class(result) = c("mapcurves_vector")
  return(result)
}

#' @export
format.mapcurves_vector = function(x, ...){
  paste("The MapCurves results:\n\n",
        "The goodness of fit:", round(x$gof, 2), "\n",
        "Reference map:", x$ref_map, "\n\n",
        "The spatial objects can be retrieved with:\n",
        "$map1", "- the first map\n",
        "$map2", "- the second map")
}

#' @export
print.mapcurves_vector = function(x, ...){
  cat(format(x, ...), "\n")
}
