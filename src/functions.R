sort_by_order <- function(.data, .field) {
  q_field = dplyr::enquo(.field)
  
  # Just take the order it's in
  lvls = .data %>% ungroup %>%
    select(!!q_field) %>% 
    unique %>%
    pull(!!q_field)
  
  .data = .data %>% 
    mutate(!!q_field := factor(!!q_field,levels=lvls))
  
  return(.data)
}

day_difference <- function(time1,time2) {
  return(as.double(difftime(time2,time1,units="days")))
}
