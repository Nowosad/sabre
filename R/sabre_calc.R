#' SABRE calculation
#'
#' It calculate the Spatial Association Between REgionalizations (SABRE) using
#' the output of the [regions_prep()] function.
#'
#' @param y DESC
#' @param x DESC
#' @param x_name DESC
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
#'
#' @examples
#' # EXAMPLES
#'
#' @export
sabre_calc = function(x, y, x_name, y_name, unit = "log2", B = 1){

  z_df = intersection_prep(x = x, y = y, x_name = x_name, y_name = y_name)

  x_df = x %>%
    mutate(area = as.numeric(st_area(.))) %>%
    st_set_geometry(NULL) %>%
    group_by(SECTION) %>%
    summarise(area = sum(area)) %>%
    na.omit()

  y_df = y %>%
    mutate(area = as.numeric(st_area(.))) %>%
    st_set_geometry(NULL) %>%
    group_by(ECO_NAME) %>%
    summarise(area = sum(area)) %>%
    na.omit()

  # x_df$entropy = apply(z_df, 2, entropy.empirical, unit = unit) /
  #   entropy.empirical(colSums(z_df), unit = unit) # next divide by entropy of a row var
  # y_df$entropy = apply(z_df, 1, entropy.empirical, unit = unit) /
  #   entropy.empirical(rowSums(z_df), unit = unit) # next divide by entropy of a col var

  v_result = v_measure(x = x_df$area, y = y_df$area, z = z_df, unit = unit, B = B)
  sabre_result = list(x, y, v_result)
  return(sabre_result)
}
