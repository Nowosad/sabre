#' SABRE calculation
#'
#' It calculates the Spatial Association Between REgionalizations (SABRE).
#'
#' @param x An object of class `sf` with a `POLYGON` or `MULTIPOLYGON` geometry type
#' @param x_name A name of the column with regions/clusters names.
#' @param y An object of class `sf` with a `POLYGON` or `MULTIPOLYGON` geometry type
#' @param y_name A name of the column with regions/clusters names.
#' @inheritParams v_measure
#' @inheritParams sf::st_set_precision
#'
#' @return A tibble
#'
#' @details DETAILS
#'
#' @references Stepinski, Tomasz, and Jakub Nowosad. "Assessing a degree of
#' spatial association between regionalizations or categorical maps using the
#' information-theoretical V-measure."
#' @references Rosenberg, Andrew, and Julia Hirschberg. "V-measure:
#' A conditional entropy-based external cluster evaluation measure." Proceedings
#' of the 2007 joint conference on empirical methods in natural language
#' processing and computational natural language learning (EMNLP-CoNLL). 2007.
#'
#' @importFrom entropy entropy.empirical
#' @importFrom sf st_intersection st_set_precision st_crs st_geometry st_cast st_collection_extract
#' @importFrom rlang enquo :=
#' @importFrom dplyr select left_join mutate_if
#' @importFrom tibble data_frame
#'
#' @examples
#' library(sf)
#' data("regions1")
#' data("regions2")
#' vm = sabre_calc(regions1, z, regions2, z)
#' vm
#'
#' plot(vm$map1[[1]]["rih"])
#' plot(vm$map2[[1]]["rih"])
#'
#' @export
sabre_calc = function(x, x_name, y, y_name, B = 1, precision = NULL){

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
  # poly_ids = st_is(z, c("POLYGON", "MULTIPOLYGON", "GEOMETRYCOLLECTION"))
  # z = filter(z, poly_ids)
  # z = st_cast(z, "MULTIPOLYGON")
  z = st_collection_extract(z)

  z_df = intersection_prep(z)

  SjZ = apply(z_df, 2, entropy.empirical, unit = "log2")
  SjR = apply(z_df, 1, entropy.empirical, unit = "log2")

  SR = entropy.empirical(colSums(z_df), unit = "log2")
  SZ = entropy.empirical(rowSums(z_df), unit = "log2")

  # homogeneity = 1 - sum((colSums(z_df)/sum(colSums(z_df)) * SjZ) / SZ)
  # completeness = 1 - sum((rowSums(z_df)/sum(rowSums(z_df)) * SjR) / SR)

  x_df = data.frame(map1 = colnames(z_df), rih = SjZ/SZ,
                    row.names = NULL, stringsAsFactors = FALSE) # map1
  y_df = data.frame(map2 = rownames(z_df), rih = SjR/SR,
                    row.names = NULL, stringsAsFactors = FALSE) # map2

  x = vector_regions(z, map1)
  x = left_join(x, x_df, by = "map1")
  y = vector_regions(z, map2)
  y = left_join(y, y_df, by = "map2")

  # B = 1
  # vmeasure = ((1 + B) * homogeneity * completeness) / (B * homogeneity + completeness)

  v_result = v_measure(x = colSums(z_df), y = rowSums(z_df), z = z_df, B = B)
  # sabre_result = list(x, y, v_result)
  sabre_result = data_frame(map1 = list(x), map2 = list(y), v_measure = v_result[[1]],
                            homogeneity = v_result[[2]], completeness = v_result[[3]])
  return(sabre_result)
}

