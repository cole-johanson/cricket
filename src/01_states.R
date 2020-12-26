# Get all costs for all patients
costs = prescr_evts %>% 
  select(DESYNPUF_ID,service_date = SRVC_DT,total_cost = TOT_RX_CST_AMT) %>%
  union_all(
    ip_claims %>% 
      select(
        DESYNPUF_ID, 
        service_date = CLM_THRU_DT,# applying cost to the end of event
        total_cost = CLM_PMT_AMT
      ) 
  ) %>%
  union_all(
    op_claims %>% 
      select(
        DESYNPUF_ID, 
        service_date = CLM_THRU_DT,# applying cost to the end of event
        total_cost = CLM_PMT_AMT
      ) 
  ) %>%
  mutate(
    service_date = lubridate::as_date(as.character(service_date)),
    year = year(service_date)
  )

# Get all patients... ESRD can change year to year so we will keep granularity at pt/yr
pts = ben_summ_2008 %>% mutate(year=2008) %>%
  union_all(ben_summ_2009 %>% mutate(year=2009)) %>% 
  union_all(ben_summ_2010 %>% mutate(year=2010)) %>%
  select(DESYNPUF_ID,year,BENE_ESRD_IND,SP_STATE_CODE,BENE_DEATH_DT)

esrd_pt_costs = costs %>% 
  inner_join(
    pts %>% filter(BENE_ESRD_IND == 'Y') 
    ,by=c("DESYNPUF_ID","year")
  )

# Some costs are negative; assuming these are adjustments. They are potentially 
# not going to line up by year, but I'm assuming that won't affect the overall 
# analysis significantly
costs_per_state_year = esrd_pt_costs %>% 
  inner_join(state_code_dict,by="SP_STATE_CODE") %>% 
  group_by(year,state_name) %>% 
  summarise(
    total_cost = sum(total_cost),
    n_beneficiaries = n_distinct(DESYNPUF_ID)
  ) %>% 
  ungroup %>% # Why is .groups not working?
  mutate(
    spending_per_esrd = total_cost/n_beneficiaries,
    spending_per_esrd_formatted = scales::dollar(spending_per_esrd)
  )

yearly_results <- function(.data,.year) {
  .data_filtered = .data %>% 
    filter(year == .year) %>%
    arrange(desc(spending_per_esrd)) %>%
    sort_by_order(state_name)
  
  .plot = plot_ly(
    .data_filtered, 
    x = ~state_name, 
    y = ~spending_per_esrd, 
    type = 'bar',
    hoverinfo = 'text',
    text = ~spending_per_esrd_formatted,
    hovertemplate = "<b>%{x}</b><br>%{text}<extra></extra>",
    marker = list(color = "#1A994F")
  ) %>% 
    layout(
      title = paste("Spending on ESRD patients in",.year,"by state"),
      xaxis = list(title = ""),
      yaxis = list(title = "Average payment per ESRD patient ($)")
    )
  
  .min = .data_filtered %>% 
    arrange(spending_per_esrd) %>% 
    filter(row_number()==1)
  
  .max = .data_filtered %>% 
    arrange(desc(spending_per_esrd)) %>% 
    filter(row_number()==1)
  
  return(list(plot=.plot,min=.min,max=.max))
}

results_2008 = yearly_results(costs_per_state_year,2008)
results_2009 = yearly_results(costs_per_state_year,2009)
results_2010 = yearly_results(costs_per_state_year,2010)
