
# send emails to participants who have been ACCEPTED but do NOT have scholarships

## to automate emails.

suppressPackageStartupMessages(library(gmailr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(purrr))
library(readr)

# load csv 
email.apps <- read_csv("emailList.csv")

this_hw <- "App-Accept-Scholarship"
email_sender <- 'NEON Data Institute <neondataskills@gmail.com>' # your Gmail address
optional_bcc <- 'L Wasser <lwasser@neoninc.org>, NEON ds <neondataskills@neoninc.org>'     # for me, TA address
body <- "

Hello %s,
Thank you for applying to the 2016 NEON #WorkWithData Institute! We are pleased to formally invite you to attend the institute which will take place June 20 - 25 June 2016 at NEON Headquarters in Boulder, Colorado.

CONGRATULATIONS on Your Scholarship!

Congratulations - you have been selected to receive a scholarship that will cover the full tuition cost ($900) of the workshop. Thus you will not be required to submit a payment. Please note that you will be responsible for your travel and meal costs & transportation to and from the CU dorms and NEON headquarters! 

Important: Please Confirm Your Institute Slot
This year we had almost 50 applications and  there is a waiting list to attend the event. To secure your spot and confirm your housing preferences for the summer institute, please:

1. Review the institute agenda to ensure that the content of the institute will meet your needs as a participant. Please note that the institute is geared towards those who are newer to remote sensing data so we will spend some time reviewing basic concepts on the first day associated with hyperspectral and lidar data.

2. Fill out a very brief survey below as soon as possible, but also no later than Wednesday April 6, 2016 confirming your attendance OR declining attendance to the event.


http://goo.gl/forms/OJy5weUqkp

AGENDA - WorkWithData Institute 2016 -  Boulder, CO

Monday: Intro to NEON & NEON Remote Sensing
8am - 6:30pm
Introduction to hyperspectral remote sensing data
Introduction to Lidar Remote sensing
Work with remote sensing data - activity


Tuesday: How Remote Sensing Data Are Used in Ecology
8am - 8PM
Morning - How remote sensing data are used in ecology
Afternoon - Reproducible science best practices
Evening science talk


Wednesday: From Raw Remote Sensing Data to Useful Maps
8am - 6:30pm
Morning - how RS products are processed (talk)
Creating basic RS products in Open Tools (NDVI, etc)
Afternoon - comparing ground to airborne - understanding uncertainty


Thursday: Introduction to Data Fusion Approaches
8am - 6:30pm
Integrating remote sensing data products
NEON tour
Begin Group projects


Friday: Small Group Project Work Day
8-6:30 PM
Work on Small Group Projects


Saturday: Project Presentations / Wrap-Up
9am-2pm
Present group projects
Final Wrap Up & Evaluation
End of Institute


NEXT STEPS: Once we have received your confirmation, we will send you payment instructions. Please get in touch with any questions by responding to this email or by emailing: neondataskills@neoninc.org
We look forward to seeing you in June!

Leah, Megan and the NDS team

"

edat <- email.apps %>%
  mutate(
    To = sprintf('%s <%s>', firstName, email),
    Bcc = optional_bcc,
    From = email_sender,
    Subject = sprintf('You Are Accepted! Welcome to the NEON #WorkWithData Institute Application'),
    body = sprintf(body, firstName)) %>%
  select(To, Bcc, From, Subject, body)
edat

write_csv(edat, "appl-accept-scholarship.csv")

# this is required to authenticate if you don't cache auth

gmail_auth("data-institute-email.json", scope = 'compose')

## purrr code below
#emails <- edat %>%
#  map_n(mime)
#str(emails, max.level = 2, list.len = 2)

## plyr code to do similar: Option A
emails <- plyr::dlply(edat, ~ To, function(x) mime(
   To = x$To,
#   Bcc = x$Bcc,
   From = x$From,
   Subject = x$Subject,
   body = x$body))

################### SEND EMAILS ###################

## plyr approach
sent_mail <- plyr::llply(emails, send_message, .progress = 'text')
saveRDS(sent_mail,
        paste(gsub("\\s+", "_", this_hw), "sent-emails.rds", sep = "_"))

# Check status codes to see if any didn't send
# if all codes are 200 then they have all sent successfully.

sent_mail %>%
  map_int("status_code") %>% 
  unique()
