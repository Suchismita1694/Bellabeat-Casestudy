# 1.INTRODUCTION
Bellabeat, a high-tech company that manufactures health-focused smart products for Women.
Bellabeat develop wearables and accompanying products that monitor biometric and lifestyle 
data to help women better understand how their bodies work and make healthier choices.

# 2. ASK
#Business Task
 The aim of this project is to analyze smart device usage data in order to gain insight into how consumers use non-Bellabeat smart
devices. with this information we are to provide high-level recommendations for how these trends can inform Bellabeat marketing strategy. 

  1. What are some trends in smart device usage?
  2. How could these trends apply to Bellabeat customers?
  3. How could these trends help influence Bellabeat marketing strategy?
    
## Stakeholders    
Primary stakeholders: Urška Sršen and Sando Mur, executive team members.
Secondary stakeholders: Bellabeat marketing analytics team.

# 3. PREPARE
  Dataset used in this analysis is the FitBit Fitness Tracker Data (CC0: Public Domain). It is made available on kaggle through Mobius.
 
  The dataset has 18 CSV. The data also follow a ROCCC approach:
    
  Reliability: The data is from 30 FitBit users who consented to the submission of personal tracker data and generated by from a distributed survey via Amazon Mechanical Turk.
  Original: The data is from 30 FitBit users who consented to the submission of personal tracker data via Amazon Mechanical Turk.
  Comprehensive: Data minute-level output for physical activity, heart rate, and sleep monitoring. While the data tracks many factors in the user activity and sleep, but the sample size is small and most data is recorded during certain days of the week.
  Current: Data is from April 2016 to May 2016. Data is not current so the users habit may be differ now.
  Cited: Cited but NOT credible. The data came from Amazon Mechanical Turk, so it could be a reliable source or it could not.
  
# 4. PROCESS
  Data processing is done in R programmig and RStudio.
#installing libraries
  install.packages("tidyvese")
  library(tidyverse)
  install.packages("janitor")
  library(janitor)
  library (tidyr)
  library(ggplot2)
  library(dplyr)
  install.packages("ggpubr")
  library(ggpubr)
  
  
#import data
  daily_activity <- read.csv(file.choose("dailyActivity_merged.csv"))
  sleep_info <- read.csv(file.choose("sleepDay_merged.csv"))
  weight_info <- read.csv(file.choose("weightLogInfo_merged.csv"))
  heartbeat_info <- read.csv(file.choose("heartrate_seconds_merged.csv"))
  hourly_steps <- read.csv(file.choose("hourlySteps_merged.csv"))
  hourly_intensity <- read.csv(file.choose("hourlyintensities.csv"))
  
  
  
# Preview our datasets 
  head(daily_activity)
  head(sleep_info)
  head(weight_info)
  head(hourly_steps)
  head(hourly_intensity)
  head(heartbeat_info)
  
  glimpse(daily_activity)
  glimpse(sleep_info)
  glimpse(weight_info)
  glimpse(hourly_steps)
  glimpse(hourly_intensity)
  glimpse(heartbeat_info)
  
# Number of rows are there in each table?  
  nrow(daily_activity)
  nrow(sleep_info)
  nrow(weight_info)
  nrow(hourly_steps)
  nrow(hourly_intensity)
  nrow(heartbeat_info)
  
# cleaning the column names
  daily_activity <- clean_names(daily_activity)
  sleep_info <- clean_names(sleep_info)
  weight_info <- clean_names(weight_info)
  heartbeat_info <- clean_names(heartbeat_info)
  hourly_steps <- clean_names(hourly_steps)
  hourly_intensity <- clean_names(hourly_intensity)  
  
# To find the number of distinct users. 
  
  n_distinct(daily_activity$id)
  n_distinct(sleep_info$id)
  n_distinct(weight_info$id)
  n_distinct(hourly_steps$id)
  n_distinct(hourly_intensity$id)
  n_distinct(heartbeat_info$id)
## Here, we can see there are 33 distinct user in daily_activity, hourly_steps and hourly_intensity table.In sleep_info there are 24 distinct users,8 in weight_info and 14 in heartbeat_info.
  
# check for duplicates
  sum(duplicated(daily_activity))
  sum(duplicated(sleep_info))
  sum(duplicated(weight_info))
  sum(duplicated(hourly_steps))
  sum(duplicated(hourly_intensity))
  sum(duplicated(heartbeat_info))
  
  
# removing duplicates if any.
  sleep_info <- sleep_info %>%
    distinct() %>%
    drop_na()
  sum(duplicated(sleep_info))
  
  hourly_steps <- hourly_steps %>%
    distinct() %>%
    drop_na()
  sum(duplicated(hourly_steps))
  
  heartbeat_info <- heartbeat_info %>%
    distinct() %>%
    drop_na()
  sum(duplicated(heartbeat_info))
  
  

#renaming activity_date to date
  daily_activity <- daily_activity %>%
    rename(date = activity_date)
  head(daily_activity,3)
  
  hourly_steps <- hourly_steps %>%
    rename(date = activity_hour)
  head(hourly_steps,3)
  
  hourly_intensity <- hourly_intensity %>%
    rename(date = activity_hour)
  head(hourly_intensity,3) 
  
  heartbeat_info <- heartbeat_info %>%
    rename (date = time)
  head(heartbeat_info,3)
  

# separtaing the date and time column
  
  hourly_intensity <- hourly_intensity %>%
    separate(date, into = c("date", "time"), sep =' ')
  head(hourly_intensity)
  
  sleep_info <- separate(sleep_info,SleepDay,into = c("Date","time"), sep =" ")
  head(sleep_info)
  
  hourly_steps <- hourly_steps %>%
    separate(date, into = c("date","time"), sep = ' ')
  head(hourly_steps)
  
  weight_info <- separate(weight_info, Date, into = c("Date","Time"), sep = " ")
  head(weight_info)
  
  
  heartbeat_info <- heartbeat_info %>%
    separate(date, into = c("date", "time"), sep = ' ')
  head(heartbeat_info)  
  
  
  # converting data in a specific format and adding a weekday coloumn  
  daily_activity <- daily_activity %>% mutate( Weekday = weekdays(as.Date(activity_date, "%m/%d/%Y")))
  View(daily_activity)
  or
  daily_activity  %>% 
    mutate(activitydate = mdy(activitydate), day_week = weekdays(activitydate))
  
  
  sleep_info <- sleep_info %>% mutate( Weekday = weekdays(as.Date(sleep_Day, "%m/%d/%Y")))
  head(sleep_info)
  
  
  weight_info <- weight_info %>% mutate( Weekday = weekdays(as.Date(date, "%m/%d/%Y")))
  View(weight_info)
  
  
# 5.ANALYZE and VISUALIZATION  
  
  daily_activity %>%
    group_by(id) %>% drop_na() %>%
    summarize(total_calories = sum(calories)) %>%
    arrange(-total_calories)
  
  daily_activity %>%  
    select(total_steps, total_distance, sedentary_minutes,very_active_minutes, lightly_active_minutes, calories) %>%
    summary()
 ### Here, we can see the average calorie burned by 33 users is 2304   

## Average sleep of each id  
 Avg_sleep <- sleep_info %>%
    group_by(id) %>% drop_na() %>%
    summarise(avg_sleep = mean(total_minutes_asleep))
 head(Avg_sleep)
 
## Average total sleep 
 sleep_info %>%
   summarise(av_sleep = mean(total_minutes_asleep))
 ### Average sleep is 419.173 which is 6.9 hrs
 
## Average total steps
  daily_activity %>%
    summarise(avg_total_steps = mean(total_steps))
  ### Average total steps by 33 users is 7638

## weight 
  weight_info %>%
  summary()
 ### Average weight is 72kg
  
## heart rate info
heartbeat_info %>%
  group_by(id) %>%
  summarise(Avg_heartrate = mean(value))

heartbeat_info %>%
  summary()
### Mean heart rate is 77.36, min heart rate is 36.00 and max heart rate is 203.00


# 1. to check the active usage of smart watch by the customers based on the step taken everyday.
## Low Use - 1 to 14 days o
## Moderate Use - 15 to 21 days
## High Use - 22 to 31 days


daily_user <- daily_activity %>%
  filter(total_steps >200 ) %>% 
  group_by(id) %>%
  summarize(activity_date=sum(n())) %>%
  mutate(Usage = case_when(
    activity_date >= 1 & activity_date <= 14 ~ "Low Use",
    activity_date >= 15 & activity_date <= 21 ~ "Moderate Use", 
    activity_date >= 22 & activity_date <= 31 ~ "High Use")) %>% 
  mutate(Usage = factor(Usage, level = c('Low Use','Moderate Use','High Use'))) %>% 
  rename(daysused = activity_date) %>% 
  group_by(Usage)
head(daily_user)

### there are 33 users in total, 24 high usage, 7 moderate and 2 low.

daily_use_percent <- daily_activity %>% 
  left_join(daily_user, by = 'id') %>%
  group_by(Usage) %>% 
  summarise(participants = n_distinct(id)) %>% 
  mutate(perc = participants/sum(participants)) %>% 
  arrange(perc) %>% 
  mutate(perc = scales::percent(perc))
head(daily_use_percent)

## to plot the pie
ggplot(daily_use_percent,aes(fill=Usage ,y = participants, x="")) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0)+
  scale_fill_brewer(palette='Pastel1')+
  theme_void()+
  theme(axis.title.x= element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(), 
        panel.grid = element_blank(), 
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        plot.title = element_text(hjust = 0.5,vjust= -5, size = 20, face = "bold")) +
  geom_text(aes(label = perc, x=1.2),position = position_stack(vjust = 0.5))+
  labs(title="Usage Group Distribution")+
  guides(fill = guide_legend(title = "Usage Type"))
options(repr.plot.width = 1, repr.plot.height = 1)

##total steps and total_calories
ggplot(data = daily_activity,aes(x= total_steps, y = calories))+
  geom_point()+
  geom_smooth()+ 
  labs(title = "Relationship betwween Calories Burned vs Total steps",subtitle = "Correlation between Calories vs steps",
                       x="Total Steps", y="Calories Burned")
## The chart shows - More steps you take more calories you will burn. 

## Total Steps vs. Sedentary Minutes
ggplot(data=daily_activity,aes(x=total_steps,y=sedentary_minutes))+geom_point(color="blue")
### It seems that we have a negative relationship between total steps taken and the minutes someone has remained sedentary

## Weekday and Sedentary
head(daily_activity)
ggplot(data=daily_activity, aes(x= weekday, y= sedentary_minutes )) + geom_histogram(stat = "identity", fill='pink') +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="Sedentary minutes in a week")
### Users spent less sedentary minutes on weekends!

## The relationship between total minutes asleep and total minutes in bed
ggplot(data=sleep_info,aes(x=total_minutes_asleep,y=total_time_in_bed))+
  geom_point()+
  geom_smooth(color='red') + labs(title="Total Minutes Asleep vs. Total Time In Bed")
### It has a positive relationship

## Merging daily_activity and sleep_info
merge_activity_sleep <- merge(daily_activity, sleep_info, by=c('id','date','weekday'))
n_distinct(merge_activity_sleep$Id)

## total mins asleep vs total_steps taken
ggplot(data=merge_activity_sleep,aes(x= total_steps,y= total_minutes_asleep))+
  geom_jitter()+
  geom_smooth()+
  labs(title="Total steps vs. Minutes asleep")

## Total sleep and Total steps in a week

daily_activity_sleep <- merge_activity_sleep %>%
  group_by(weekday) %>%
  summarize (daily_steps = mean(total_steps), daily_sleep = mean(total_minutes_asleep)) %>%
  arrange(daily_steps)
view(daily_activity_sleep)

ggplot(data = daily_activity_sleep, aes(x = weekday, y = daily_steps))+ 
  geom_col(fill = "red")+
  labs(title="Minutes asleep per Weekday")
### Saturday is the most active day.
ggplot (data = daily_activity_sleep, aes(x = weekday, y = daily_sleep))+ 
  geom_col(fill = "green")+
  labs(title="Daily steps per Weekday")
### Fun fact!! Sunday is the laziest day.  

## hourly intensity in a day
intensity <- hourly_intensity %>%
  group_by(time) %>%
  drop_na() %>%
  summarise(mean_total_intensity = mean(total_intensity))

ggplot(data=intensity, aes(x=time, y=mean_total_intensity)) + geom_histogram(stat = "identity", fill='blue') +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="Average Total Intensity vs. Time")
### Eveneing 6pm-8pm is the most active hours in a day.

## hourly step in a day
Steps <= hourly_steps %>%
   group_by(time) %>%
   drop_na() %>%
   summarise(mean_total_steps = mean(step_total))
 
ggplot(data=Steps, aes(x=time, y=mean_total_steps)) + geom_histogram(stat = "identity", fill='orange') +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="Average Total Step vs. Time")

# CONCLUSION 
 From this analysis we know, that more steps will result in more calorie burn. Saturday is the most active day, 
 while Sunday is the laziest. Evenings are the most active time of the day.
 Average sleep is 420mins which is 7 hours.

 The data showed 33 total users, out of which 24 unique IDs used the sleep tracking function, 
 14 unique IDs used heart-rate tracking and 8 unique IDs used their devices to track their weight. 
 The analysis would be more accurate if all 33 users used all functions of the device.
 Insights on women's health and wellness were not represented in this study, which is a
 crucial insight for bellabeat as it is a women-centric company.
 Also, the data set is very small and does not include information such as gender, age, location, 
 weather conditions, menstrual cycle, etc. 
 Bellabeat's marketing team can concentrate on functions, like menstrual cycle
 which focuses on women's reproductive health.
 
 THANK YOU