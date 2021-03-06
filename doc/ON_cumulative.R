## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(data2019nCoV)
library(ggplot2)
library(tidyr)
library(dplyr)
library(scales)

daily_change <- function(series) {
  change <- c(series, NA) - c(NA, series)
  change <- change[-1]
  change <- change[-length(change)]
  return(change)
}

ON_cumulative$LastUpdated[length(ON_cumulative$LastUpdated)]

ON_mohreports$date[length(ON_mohreports$date)]

ON_status$date[length(ON_status$date)]

## ---- fig.width=6, fig.height=8-----------------------------------------------

plot(ON_status$date, ON_status$cases,
     main = "Cumulative Confirmed COVID-19 Cases in Ontario",
     xlab = "Date",
     ylab = "Cases",
     type = "b")

plot(ON_status$date, ON_status$cases,
     main = "Cumulative COVID-19 Cases in Ontario (Semilog.)",
     xlab = "Date",
     ylab = "Confirmed Cases",
     type = "b",
     log = "y")

plot(ON_status$date, ON_status$positive,
     main = "Active COVID-19 Cases in Ontario",
     xlab = "Date",
     ylab = "Confirmed Cases",
     type = "b")

plot(ON_status$date[-1], daily_change(ON_status$cases),
     main = "Change in COVID-19 Cases in Ontario",
     xlab = "Date",
     ylab = "Change in Confirmed Cases",
     type = "b")

plot(ON_status$date[-1], daily_change(ON_status$tested_patients),
     main = "Change in COVID-19 Patients Tested",
     xlab = "Date",
     ylab = "Change in Patients Tests",
     type = "b")

## ---- fig.width=6, fig.height=8-----------------------------------------------
colours <- c("red",   "blue",  "black", "magenta", "green")

matplot(ON_mohreports$date, cbind( 
                ( (ON_mohreports$deaths / ON_mohreports$cases) * 100 ),
                ( (ON_mohreports$severity_hospitalized / ON_mohreports$cases) * 100 ),
                ( (ON_mohreports$severity_icu / ON_mohreports$cases) * 100 ),
                ( (ON_mohreports$deaths_ltc_residents / ON_mohreports$cases_ltc_residents) * 100 ),
                ( (ON_mohreports$deaths_hospital_pts / ON_mohreports$cases_hospital_pts) * 100 )
               ),
                           
     main = "Ontario Severity and Outcomes",
     xlab = "Date (2020)",
     ylab = "Outcome (Percent)",
     type = "l",
     col = colours,
     lty = c("solid", "solid", "solid", "solid", "solid"),
     ylim = c(0,25),
     ylog = TRUE,
     xaxt="n")
dates<-format(ON_mohreports$date,"%b %d")
axis(1, at=ON_mohreports$date, labels=dates)
legend(x="top", 
       legend = c("CFR (Overall)", 
                  "Hospitalized (Cumulative)", 
                  "ICU (Cumulative)", 
                  "CFR (LTC Residents)",
                  "CFR (Hospital Outbreak Patients)"), 
       col = colours,
       lty = c("solid", "solid", "solid", "solid"), pch=18)

## ---- fig.width=6, fig.height=8-----------------------------------------------

ON_forplot <- rename(ON_mohreports,
    Ontario = cases, Toronto = cases_phu_toronto, Peel = cases_phu_peel, 
    York = cases_phu_york, Ottawa = cases_phu_ottawa, Durham = cases_phu_durham, 
    Waterloo = cases_phu_waterloo, Hamilton = cases_phu_hamilton, 
    Windsor... = cases_phu_windsoressex, Middlesex... = cases_phu_middlesexlondon, 
    Halton = cases_phu_halton, Niagara = cases_phu_niagara, 
    Simcoe... = cases_phu_simcoemuskoka, Haliburton... = cases_phu_haliburtonkawarthapineridge,
    Lambton = cases_phu_lambton, Wellington... = cases_phu_wellingtondufferinguelph, 
    Kingston... = cases_phu_kingstonfrontenaclennoxaddington, 
    Haldimand... = cases_phu_haldimandnorfolk, Peterborough = cases_phu_peterborough, 
    Leeds... = cases_phu_leedsgrenvillelanark, Brant = cases_phu_brant, 
    Eastern = cases_phu_easternontario, Porcupine = cases_phu_porcupine, 
    Sudbury = cases_phu_sudbury, Hastings... = cases_phu_hastingsprinceedward, 
    Grey... = cases_phu_greybruce, Southwestern = cases_phu_southwestern, 
    Chatham... = cases_phu_chathamkent, ThunderBay = cases_phu_thunderbay, 
    Renfrew = cases_phu_renfrew, Algoma = cases_phu_algoma, 
    HuronPerth = cases_phu_huronperth, NorthBay... = cases_phu_northbayparrysound, 
    Northwestern = cases_phu_northwestern, Timiskaming = cases_phu_timiskaming)


gather(ON_forplot, key, value, 
       Ontario, Toronto, Peel, York, Ottawa, Durham, Waterloo, Hamilton,
       Windsor..., Middlesex..., Halton, Niagara, Simcoe..., Haliburton...,
    Lambton, Wellington..., Kingston..., Haldimand..., Peterborough, 
    Leeds..., Brant, Eastern, Porcupine, Sudbury, Hastings..., 
    Grey..., Southwestern, Chatham..., ThunderBay, Renfrew, Algoma, 
    HuronPerth, NorthBay..., Northwestern, Timiskaming
       ) %>%
  ggplot(aes(x=date, y=value, col=key)) +
  geom_path() +
  scale_y_continuous(trans = 'log10', labels = comma) +
  theme(legend.position="bottom") +
  labs(title = "Ontario COVID-19 Cases by Public Health Unit",
       x = "Date", 
       y = "Confirmed Cases") +
  guides(shape = guide_legend(override.aes = list(size = 0.5))) +
  guides(color = guide_legend(override.aes = list(size = 0.5))) +
  theme(legend.text = element_text(size = 7)) +
  theme(legend.title = element_blank())

gather(ON_mohreports, key, value, 
       cases,deaths,
       severity_hospitalized,severity_icu,
       cases_ltc_residents, cases_ltc_staff,
       cases_hospital_pts, deaths_hospital_pts,
       deaths_ltc_residents, cases_hcp
       ) %>%
  ggplot(aes(x=date, y=value, col=key)) +
  geom_line() +
  guides(shape = guide_legend(override.aes = list(size = 0.5))) +
  scale_y_continuous(trans = 'log10', labels = comma) +
  theme(legend.position="right") +
  labs(title = "Ontario COVID-19 Cases (Semilog.)",
       x = "Date", 
       y = "Confirmed Cases") +
  theme(legend.title = element_blank())

## ---- fig.width=6, fig.height=8-----------------------------------------------

par(mfrow=c(3,2))

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$cases),
     type = "b",
     xlab = "Date",
     ylab = "New Cases")

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$deaths),
     type = "b",
     xlab = "Date",
     ylab = "New Deaths")

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$severity_hospitalized),
     type = "b",
     xlab = "Date",
     ylab = "New Hospitalized Cases")

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$severity_icu),
     type = "b",
     xlab = "Date",
     ylab = "New ICU Cases")

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$cases_ltc),
     type = "b",
     xlab = "Date",
     ylab = "Change LTC Cases")

plot(ON_mohreports$date[-1], daily_change((ON_mohreports$cases - ON_mohreports$cases_ltc - ON_mohreports$cases_hospital_pts)),
     type = "b",
     xlab = "Date",
     ylab = "Change Non-Outbreak Cases")



