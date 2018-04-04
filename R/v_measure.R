#' V-measure
#'
#' A conditional entropy-based external cluster evaluation measure.
#'
#' @param x A numeric vector, representing a categorical values.
#' @param y A numeric vector, representing a categorical values.
#' @param z A numeric matrix. A contingency table of the counts at each
#' combination of categorical levels. By default this argument is set to `NULL`,
#' and the value of `z` is calculated based on `x` and `y`.
#' @param B A numeric value. If `B` > 1 then completeness is weighted more strongly than
#' homogeneity, and if `B` < 1 then homogeneity is weighted more strongly than
#' completeness. By default this value is 1.
#'
#' @return A list with three elements:
#' * "v_measure"
#' * "homogeneity"
#' * "completeness"
#'
#' @references Rosenberg, Andrew, and Julia Hirschberg. "V-measure:
#' A conditional entropy-based external cluster evaluation measure." Proceedings
#' of the 2007 joint conference on empirical methods in natural language
#' processing and computational natural language learning (EMNLP-CoNLL). 2007.
#'
#' @importFrom entropy entropy.empirical mi.empirical
#'
#' @examples
#' x = c(1, 1, 1, 2, 2, 3, 3, 3, 1, 1, 2, 2, 2, 3, 3)
#' y = c(rep(1, 5), rep(2, 5), rep(3, 5))
#' v_measure(x, y)
#'
#' @export
v_measure = function(x, y, z = NULL, B = 1){
  entropy_x = entropy.empirical(x / length(x), unit = "log2")
  entropy_y = entropy.empirical(y / length(y), unit = "log2")
  if (is.null(z)){
    mi_xy = mi.empirical(table(x, y), unit = "log2")
  } else {
    mi_xy = mi.empirical(z, unit = "log2")
  }
  if(entropy_x == 0){
    homogeneity = 1
  } else {
    homogeneity = mi_xy / entropy_x
  }
  if(entropy_y == 0){
    completeness = 1
  } else {
    completeness = mi_xy / entropy_y
  }
  if(homogeneity + completeness == 0){
    v = 0
  } else {
    v = ((1 + B) * homogeneity * completeness) / (B * homogeneity + completeness)
  }
  result = list(v_measure = v, homogeneity = homogeneity, completeness = completeness)
  class(result) = c("v_measure")
  return(result)
}

#' @export
format.v_measure = function(x, ...){
  paste("Results:\n\n",
        "V-measure:", round(x$v_measure, 2), "\n",
        "Homogeneity:", round(x$homogeneity, 2), "\n",
        "Completeness:", round(x$completeness, 2))
}

#' @export
print.v_measure = function(x, ...){
  cat(format(x, ...), "\n")
}

