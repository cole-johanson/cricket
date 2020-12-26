# What is the average amount spent per ESRD patient on claims that were initiated 
# in the final 180 days of life? (Combining inpatient, outpatient and RX drugs)

dead_esrd_pts = pts %>% 
  group_by(DESYNPUF_ID) %>%
  arrange(desc(!is.na(BENE_DEATH_DT)),desc(year)) %>%
  filter(
    row_number() == 1 &
    BENE_ESRD_IND == "Y" &
    !is.na(BENE_DEATH_DT)
  ) %>% 
  ungroup

# Note: including all pts with a death date
cost_per_dead_pt = dead_esrd_pts %>%
  left_join(costs,by="DESYNPUF_ID") %>%
  mutate(
    BENE_DEATH_DT = lubridate::as_date(as.character(BENE_DEATH_DT)),
    days_til_death = day_difference(service_date,BENE_DEATH_DT),
    occurred_in_final_days = days_til_death <= 180
  ) %>% 
  group_by(DESYNPUF_ID,BENE_DEATH_DT) %>% 
  summarise(
    cost_last_days = sum(if_else(occurred_in_final_days,coalesce(total_cost,0),0),na.rm=T),
    cost_total = sum(coalesce(total_cost,0),na.rm=T),
  ) %>% 
  ungroup %>%
  mutate(year_of_death = year(BENE_DEATH_DT))

histogram_cost_last_days = plot_ly(
  cost_per_dead_pt,
  x = ~cost_last_days, 
  type = "histogram",
  marker = list(color = "#1A994F")
) %>% 
  layout(
    title = "Spending in last 180 days of life",
    xaxis = list(title = "", tickformat = "$")
  )

