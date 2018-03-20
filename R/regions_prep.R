#' Regionalizations preparation
#'
#' The output of this function can be used in [sabre_calc()] and [mapcurves_calc()].
#'
#' @param y DESC
#' @param x DESC
#' @param x_name DESC
#' @param y_name DESC
#'
#' @return A list
#'
#' @details DETAILS
#'
#' @importFrom sf st_intersection st_area
#' @importFrom stats aggregate
#'
#' @examples
#' # EXAMPLES
#'
#' @export
regions_prep = function(x, y, x_name, y_name){
        v1 = vector_select_class(x, x_name) #%>% st_make_valid()
        v2 = vector_select_class(y, y_name) #%>% st_make_valid()

        suppressWarnings({inter_v12 = st_intersection(v1, v2)})
        inter_v12$area = as.numeric(st_area(inter_v12))

        new_v1 = vector_select_class(inter_v12, x_name)
        new_v2 = vector_select_class(inter_v12, y_name)

        list(new_v1, new_v2, inter_v12)
}

vector_select_class = function(vector_obj, attr_name){
  vector_obj = vector_obj[attr_name]
  unique_classes = unique(vector_obj[[attr_name]])
  if (nrow(vector_obj) == length(unique_classes)){
    return(vector_obj)
  } else {
    vector_obj = aggregate(vector_obj, by = list(g = vector_obj[[attr_name]]),
                           FUN = function(x) x[1], do_union = FALSE)
    # vector_obj = st_cast(vector_obj, "MULTIPOLYGON")
    vector_obj = vector_obj[attr_name]
    return(vector_obj)
  }
}
