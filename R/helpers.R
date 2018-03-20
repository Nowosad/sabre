#' @importFrom tidyr spread
#' @importFrom sf st_set_geometry
area_spread = function(x, name1, name2){
  x_df = st_set_geometry(x, NULL)[c("area", name1, name2)]
  x_df = spread(x_df, name1, "area", fill = 0)
  as.matrix(x_df[-1])
}
