#' @importFrom sf st_intersection st_area
intersection_prep = function(z, x_name, y_name){
  result = z %>%
    mutate(area = as.numeric(st_area(.))) %>%
    st_set_geometry(NULL) %>%
    group_by(SECTION, ECO_NAME) %>%
    summarise(area = sum(area)) %>%
    na.omit() %>%
    spread(SECTION, area, fill = 0) %>%
    .[-1] %>%
    as.matrix()

  return(result)
}

#' @importFrom stats aggregate
vector_regions = function(vector_obj, attr_name){
  vector_obj = vector_obj[attr_name]
  unique_classes = unique(vector_obj[[attr_name]])
  if (nrow(vector_obj) == length(unique_classes)){
    return(vector_obj)
  } else {
    # to dplyr
    vector_obj = aggregate(vector_obj, by = list(g = vector_obj[[attr_name]]),
                           FUN = function(x) x[1], do_union = FALSE)
    # vector_obj = st_cast(vector_obj, "MULTIPOLYGON")
    vector_obj = vector_obj[attr_name]
    return(vector_obj)
  }
}

regions_prep = function(vector_obj, attr_name){
  vector_obj %>%
    mutate(area = as.numeric(st_area(.))) %>%
    st_set_geometry(NULL) %>%
    group_by(SECTION) %>%
    summarise(area = sum(area)) %>%
    na.omit()
}
