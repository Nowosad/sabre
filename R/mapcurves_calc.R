#' Mapcurves calculation
#'
#' It calculate the Mapcurves's goodness-of-fit (GOF) using
#' the output of the [regions_prep()] function.
#'
#' @param x An output of the [regions_prep()] function
#'
#' @return A list
#'
#' @details DETAILS
#'
#' @references Hargrove, William W., Forrest M. Hoffman, and Paul F. Hessburg.
#' "Mapcurves: a quantitative method for comparing categorical maps."
#' Journal of Geographical Systems 8.2 (2006): 187.
#'
#' @examples
#' # EXAMPLES
#'
#' @export
mapcurves_calc = function(x){
        x[[1]]$area = as.numeric(st_area(x[[1]]))
        x[[2]]$area = as.numeric(st_area(x[[2]]))

        # crosstable of categories
        x_name = names(x[[1]])[1]
        y_name = names(x[[2]])[1]

        xy_values_freq = area_spread(x[[3]], x_name, y_name)

        z = xy_values_freq^2 / tcrossprod(rowSums(xy_values_freq), colSums(xy_values_freq))

        x[[1]]$gof = apply(z, 2, function(x) max(x))
        x[[2]]$gof = apply(z, 1, function(x) max(x))

        mapcurves_result = mapcurves(z = z)
        result = list(x[[1]], x[[2]], mapcurves_result)
        return(result)
}
