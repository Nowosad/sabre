#' Mapcurves
#'
#' Mapcurves: a quantitative method for comparing categorical maps.
#'
#' @param x A numeric vector, representing a categorical values.
#' @param y A numeric vector, representing a categorical values.
#' @param z A numeric matrix. The goodness of fit (GOF) value fir each pair of
#' classes in `x` and `y`. By default this argument is set to `NULL`,
#' and the value of `z` is calculated based on `x` and `y`.
#'
#' @return A list with two elements:
#' * "ref_map" - the map to be used as reference ("x" or "y")
#' * "gof" - the Mapcurves's goodness of fit value
#'
#' @references Hargrove, William W., Forrest M. Hoffman, and Paul F. Hessburg.
#' "Mapcurves: a quantitative method for comparing categorical maps."
#' Journal of Geographical Systems 8.2 (2006): 187.
#'
#' @importFrom utils head tail
#'
#' @examples
#' set.seed(2018-03-21)
#' A = floor(matrix(runif(100, 0, 9), 10))
#' B = floor(matrix(runif(100, 0, 9), 10))
#' mapcurves(A, B)
#'
#' @export
mapcurves = function(x, y, z = NULL){
        if (is.null(z)){
                # crosstable of categories
                xy_table = table(x, y)
                z = xy_table^2 / tcrossprod(rowSums(xy_table), colSums(xy_table))
        }

        # row and col sums
        z_xsum = c(0, sort(rowSums(z)), 1)
        z_ysum = c(0, sort(colSums(z)), 1)

        # values shares
        share_x = c(1, seq(1, 0, length.out = nrow(z)), 0)
        share_y = c(1, seq(1, 0, length.out = ncol(z)), 0)

        # data.frame plot
        df_x = data.frame(x = z_xsum, y = share_x, type = "x")
        df_y = data.frame(x = z_ysum, y = share_y, type = "y")

        # # plot
        # df = rbind(df_x, df_y)
        # library(ggplot2)
        # print(ggplot(df, aes(x, y, color = type)) + geom_point() + geom_line())

        # area under curve
        gof_x = area_under_curve(df_x$x, df_x$y)
        gof_y = area_under_curve(df_y$x, df_y$y)

        # output
        if (gof_x >= gof_y){
                gof = gof_x
                map = "x"
        } else {
                gof = gof_y
                map = "x"
        }

        # result
        result = list(ref_map = map, gof = gof)
        class(result) = c("mapcurves")
        return(result)
}
area_under_curve = function(x, y){
        sum(diff(x) * (head(y, -1) + tail(y, -1))) / 2
}

#' @export
format.mapcurves = function(x, ...){
  paste("Results:\n\n",
        "The goodness of fit:", round(x$gof, 2), "\n",
        "Reference map:", x$ref_map)
}

#' @export
print.mapcurves = function(x, ...){
  cat(format(x, ...), "\n")
}
