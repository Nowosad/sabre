#' V-measure
#'
#' A conditional entropy-based external cluster evaluation measure.
#'
#' @param x A numeric vector of counts
#' @param y A numeric vector of counts
#' @param z A numeric matrix of counts
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
#' @importFrom infotheo entropy condentropy
#'
#' @examples
#' # EXAMPLES
#'
#' @export
v_measure = function(x, y, z = NULL, B = 1){
        entropy_x = entropy(x)
        entropy_y = entropy(y)
        if (is.null(z)){
                ce_xy = condentropy(x, y)
        } else {
                ce_xy = condentropy(z)
        }
        if(entropy_x == 0){
                homogeneity = 1
        } else {
                homogeneity = 1 - (ce_xy / entropy_x)
        }
        if(entropy_y == 0){
                completeness = 1
        } else {
                completeness = 1 - (ce_xy / entropy_y)
        }
        if(homogeneity + completeness == 0){
                v = 0
        } else {
                v = ((1 + B) * homogeneity * completeness) / (B * homogeneity + completeness)
        }
        result = list(vmeasure = v, homogeneity = homogeneity, completeness = completeness)
        return(result)
}
