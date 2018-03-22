#' @importFrom sf st_set_geometry st_area
#' @importFrom dplyr mutate group_by summarise
#' @importFrom tidyr spread
#' @importFrom rlang enquo
#' @importFrom stats na.omit
intersection_prep = function(z){
  z = mutate(z, area = as.numeric(st_area(z)))
  z = st_set_geometry(z, NULL)
  z = group_by(z, map1, map2)
  z = na.omit(z)
  # z = summarise(z, area = sum(area), do_union = FALSE)
  z = summarise(z, area = sum(area))
  z = spread(z, map1, area, fill = 0)
  z = as.matrix(z)

  return(z)
}

#' @importFrom rlang enquo
#' @importFrom dplyr select pull group_by summarise
vector_regions = function(vector_obj, attr_name){
  attr_name = enquo(attr_name)

  vector_obj = group_by(vector_obj, !!attr_name)
  vector_obj = summarise(vector_obj)
  vector_obj = st_cast(vector_obj, "MULTIPOLYGON")
  return(vector_obj)
}

#' @importFrom rlang enquo
#' @importFrom sf st_set_geometry st_area
#' @importFrom dplyr mutate pull group_by summarise
#' @importFrom stats na.omit
regions_prep = function(vector_obj, attr_name){
  attr_name = enquo(attr_name)

  vector_obj = mutate(vector_obj, area = as.numeric(st_area(vector_obj)))
  vector_obj = st_set_geometry(vector_obj, NULL)
  vector_obj = group_by(vector_obj, !!attr_name)
  vector_obj = summarise(vector_obj, area = sum(area))
  vector_obj = na.omit(vector_obj)

  return(vector_obj)
}
