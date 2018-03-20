#' SABRE calculation
#'
#' It calculate the Spatial Association Between REgionalizations (SABRE) based
#' on the output of the [spatial_prep()] function.
#'
#' @param x An output of the [spatial_prep()] function
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
#' @examples
#' # EXAMPLES
#'
#' @export
sabre_calc = function(x, unit = "log2", B = 1){
        x[[1]]$area = as.numeric(st_area(x[[1]]))
        x[[2]]$area = as.numeric(st_area(x[[2]]))

        x_name = names(x[[1]])[2]
        y_name = names(x[[2]])[2]

        xy_values_freq = st_set_geometry(x[[3]], NULL)[c("area", x_name, y_name)] %>%
                tidyr::spread(x_name, "area", fill = 0) %>%
                .[-1] %>%
                as.matrix()

        x[[1]]$entropy = apply(xy_values_freq, 2, entropy, unit = unit) / entropy(colSums(xy_values_freq), unit = unit) # next divide by entropy of a row var
        x[[2]]$entropy = apply(xy_values_freq, 1, entropy, unit = unit) / entropy(rowSums(xy_values_freq), unit = unit) # next divide by entropy of a col var

        v_result = v_measure(x[[1]]$area, x[[2]]$area, xy_values_freq, unit = unit, B = B)
        sabre_result = list(x[[1]], x[[2]], v_result)
        return(sabre_result)
}
