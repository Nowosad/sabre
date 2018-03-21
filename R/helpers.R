#' @importFrom sf st_intersection st_area
intersection_prep = function(x, y, x_name, y_name){

  suppressWarnings({inter_v12 = st_intersection(x, y)})
  inter_v12$area = as.numeric(st_area(inter_v12))

  result = inter_v12 %>%
    st_set_geometry(NULL) %>%
    group_by(SECTION, ECO_NAME) %>%
    summarise(area = sum(area)) %>%
    na.omit() %>%
    spread(SECTION, area, fill = 0) %>%
    .[-1] %>%
    as.matrix()

  return(result)
}

