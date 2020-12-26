slide_1_figure = plot_ly(
  y = ~costs_per_state_year %>% filter(year == 2008) %>% pull(spending_per_esrd), 
  type = "box", 
  boxpoints = "all", 
  jitter = 0.3,
  pointpos = -1.8,
  name = '2008',
  marker = list(color = "#1A994F"),
  line = list(color = "#1A994F"),
  fillcolor = list(color = "#1A994F")
) %>% layout(
  yaxis = list(title = "Average ESRD spending per state-year ($)"),
  xaxis = list(title = " ")
) %>% add_trace(
  y = ~costs_per_state_year %>% filter(year == 2009) %>% pull(spending_per_esrd),
  name = '2009'
) %>% add_trace(
  y = ~costs_per_state_year %>% filter(year == 2010) %>% pull(spending_per_esrd),
  name = '2010'
)

slide_2_figure = plot_ly(
  y = ~cost_per_dead_pt %>% filter(year_of_death == 2008) %>% pull(cost_last_days), 
  type = "box", 
  boxpoints = "all", 
  jitter = 0.3,
  pointpos = -1.8,
  name = '2008',
  marker = list(color = "#1A994F"),
  line = list(color = "#1A994F"),
  fillcolor = list(color = "#1A994F")
) %>% layout(
  yaxis = list(title = "Spending per patient ($)"),
  xaxis = list(title = " ")
) %>% add_trace(
  y = ~cost_per_dead_pt %>% filter(year_of_death == 2009) %>% pull(cost_last_days),
  name = '2009'
) %>% add_trace(
  y = ~cost_per_dead_pt %>% filter(year_of_death == 2010) %>% pull(cost_last_days),
  name = '2010'
)
