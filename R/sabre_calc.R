#' SABRE calculation
#'
#' It calculate the Spatial Association Between REgionalizations (SABRE) using
#' the output of the [regions_prep()] function.
#'
#' @param x An output of the [regions_prep()] function
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
sabre_calc = function(x, unit = "log2", B = 1){
        x[[1]]$area = as.numeric(st_area(x[[1]]))
        x[[2]]$area = as.numeric(st_area(x[[2]]))

        x_name = names(x[[1]])[1]
        y_name = names(x[[2]])[1]

        xy_values_freq = area_spread(x[[3]], name1 = x_name, name2 = y_name)

        x[[1]]$entropy = apply(xy_values_freq, 2, entropy.empirical, unit = unit) /
          entropy.empirical(colSums(xy_values_freq), unit = unit) # next divide by entropy of a row var
        x[[2]]$entropy = apply(xy_values_freq, 1, entropy.empirical, unit = unit) /
          entropy.empirical(rowSums(xy_values_freq), unit = unit) # next divide by entropy of a col var

        v_result = v_measure(x[[1]]$area, x[[2]]$area, xy_values_freq, unit = unit, B = B)
        sabre_result = list(x[[1]], x[[2]], v_result)
        return(sabre_result)
}
