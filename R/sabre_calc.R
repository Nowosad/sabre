#' SABRE calculation
#'
#' It calculate the Spatial Association Between REgionalizations (SABRE).
#'
#' @param y DESC
#' @param x_name DESC
#' @param x DESC
#' @param y_name DESC
#' @param unit A logarithm base ("log", "log2" or "log10")
#' @param B DESC
#'
#' @return A list
#'
#' @details DETAILS
#'
#' @references Rosenberg, Andrew, and Julia Hirschberg. "V-measure:
#' A conditional entropy-based external cluster evaluation measure." Proceedings
#' of the 2007 joint conference on empirical methods in natural language
#' processing and computational natural language learning (EMNLP-CoNLL). 2007.
#'
#' @importFrom entropy entropy.empirical
#' @importFrom sf st_intersection
#' @importFrom rlang enquo
#'
#' @examples
#' # EXAMPLES
#'
#' @export
sabre_calc = function(x, x_name, y, y_name, unit = "log2", B = 1){

  x = st_set_precision(x, 1)
  y = st_set_precision(y, 1)

  suppressWarnings({z = st_intersection(x, y)})

  x = vector_regions(z, !!enquo(x_name))
  y = vector_regions(z, !!enquo(y_name))

  z_df = intersection_prep(z, !!enquo(x_name), !!enquo(y_name))

  SjZ = apply(z_df, 2, entropy.empirical, unit = "log2")
  SjR = apply(z_df, 1, entropy.empirical, unit = "log2")

  SR = entropy.empirical(colSums(z_df), unit = "log2")
  SZ = entropy.empirical(rowSums(z_df), unit = "log2")

  # homogeneity = 1 - sum((colSums(z_df)/sum(colSums(z_df)) * SjZ) / SZ)
  # completeness = 1 - sum((rowSums(z_df)/sum(rowSums(z_df)) * SjR) / SR)

  #map1
  SjZ/SZ
  # map2
  SjR/SR

  # B = 1
  # vmeasure = ((1 + B) * homogeneity * completeness) / (B * homogeneity + completeness)

  v_result = v_measure(x = colSums(z_df), y = rowSums(z_df), z = z_df, unit = unit, B = B)
  sabre_result = list(x, y, v_result)
  return(sabre_result)
}

