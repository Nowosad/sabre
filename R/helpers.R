#' @importFrom sf st_intersection st_area
intersection_prep = function(z, x_name, y_name){
  x_name = enquo(x_name)
  y_name = enquo(y_name)

  result = z %>%
    mutate(area = as.numeric(st_area(.))) %>%
    st_set_geometry(NULL) %>%
    group_by(!!x_name, !!y_name) %>%
    summarise(area = sum(area)) %>%
    na.omit() %>%
    spread(!!x_name, area, fill = 0) %>%
    .[-1] %>%
    as.matrix()

  return(result)
}

#' @importFrom stats aggregate
vector_regions = function(vector_obj, attr_name){
  attr_name = enquo(attr_name)
  # vector_obj = select(vector_obj, !!attr_name)
  unique_classes = vector_obj %>% pull(!!attr_name) %>% unique()
  if (nrow(vector_obj) == length(unique_classes)){
    return(vector_obj)
  } else {
    vector_obj = vector_obj %>%
      group_by(!!attr_name) %>%
      summarise(do_union = FALSE)
    return(vector_obj)
  }
}

regions_prep = function(vector_obj, attr_name){
  attr_name = enquo(attr_name)
  vector_obj %>%
    mutate(area = as.numeric(st_area(.))) %>%
    st_set_geometry(NULL) %>%
    group_by(!!attr_name) %>%
    summarise(area = sum(area)) %>%
    na.omit()
}
