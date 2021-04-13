# load packages
library(tidyverse)
library(tidytuesdayR)
library(here)
library(lubridate)
library(fs)

# generate all tuesdays in the period

start_date <- ymd("2020-12-29") # start date

end_date <- Sys.Date() # end date

# Create the dataset
dates_dframe <- data.frame(wk_date = seq(start_date,
                                         end_date, by = 7)) %>%
    mutate(year = year(wk_date),
           day_week = wday(wk_date, label = T, abbr = F)) %>% 
    group_by(day_week) %>% 
    mutate(
        viz_week = row_number()
    )

# NOTE: Script needs to be run on the appropriate day (Tuesdays)
# check if system date is tuesday

today_data <- dates_dframe %>% 
    filter(wk_date == Sys.Date())

# date of visualization
vizYear <- today_data$year
vizDate <- today_data$wk_date   # visualization date
vizWeek <- today_data$viz_week  # visualization week number

# Creating directories

# top most directory
levelOne_Dir <- paste0("data/", vizYear)

# create level one directory
dir.create(levelOne_Dir)

# Now, create level 2 directories (These will recur over weeks)
tt_directory <- paste0('data/',vizYear, '/week_', vizWeek, '/')

dir.create(tt_directory)


# Download and save data based on which week ------------------------------

TuesData <- tidytuesdayR::tt_load(vizDate) # Download data based on date

for (dataset in 1:length(TuesData)) {
    
    list_item_name <- names(TuesData)[dataset]
    
    # Export to local folder one by one
    write.csv(TuesData[[dataset]], 
              file = paste0(tt_directory, list_item_name, '.csv'),
              row.names = F)
}


# Clean the workspace (read to read in single datasets)
rm(dates_dframe, today_data, TuesData, dataset,
   end_date, levelOne_Dir, list_item_name, start_date,
   vizDate, vizWeek, vizYear)


# Now, read the tidy tuesday datasets for visualizations

data_files <- list.files(tt_directory)

for (data in 1:length(data_files)){
assign(data_files[data], 
       read_csv(paste0(tt_directory, data_files[data])))
}


# Final cleaning of work-space
rm(data, data_files, tt_directory)
    




