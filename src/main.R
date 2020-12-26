library(tidyverse)
library(here)
library(scales)
library(plotly)
library(lubridate)

ben_summ_2008 = read_csv(here::here("data/DE1_0_2008_Beneficiary_Summary_File_Sample_1.csv"))
ip_claims = read_csv(here::here("data/DE1_0_2008_to_2010_Inpatient_Claims_Sample_1.csv"))
op_claims = read_csv(here::here(
  "data/DE1_0_2008_to_2010_Outpatient_Claims_Sample_1.csv"), 
  col_types = cols(
    .default = col_character(),
    CLM_ID = col_double(),
    SEGMENT = col_double(),
    CLM_FROM_DT = col_double(),
    CLM_THRU_DT = col_double(),
    CLM_PMT_AMT = col_double(),
    NCH_PRMRY_PYR_CLM_PD_AMT = col_double(),
    NCH_BENE_BLOOD_DDCTBL_LBLTY_AM = col_double(),
    ICD9_DGNS_CD_10 = col_character(),
    ICD9_PRCDR_CD_1 = col_character(),
    ICD9_PRCDR_CD_2 = col_character(),
    ICD9_PRCDR_CD_3 = col_character(),
    ICD9_PRCDR_CD_4 = col_character(),
    ICD9_PRCDR_CD_5 = col_character(),
    ICD9_PRCDR_CD_6 = col_character(),
    NCH_BENE_PTB_DDCTBL_AMT = col_double(),
    NCH_BENE_PTB_COINSRNC_AMT = col_double(),
    HCPCS_CD_45 = col_character()
  ))
prescr_evts = read_csv(here::here("data/DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_1.csv"))
ben_summ_2009 = read_csv(here::here("data/DE1_0_2009_Beneficiary_Summary_File_Sample_1.csv"))
ben_summ_2010 = read_csv(here::here("data/DE1_0_2010_Beneficiary_Summary_File_Sample_1.csv"))

# ESRD pts = BENE_ESRD_IND == 'Y'
# States = SP_STATE_CODE

source(here::here('src/definitions.R'))
source(here::here('src/functions.R'))
source(here::here('src/01_states.R'))
source(here::here('src/02_eol.R'))
source(here::here('src/03_slides.R'))
