

# this code sends an email to a group or recipients!
setwd("~/Documents/GitHub/NEON-Lesson-Building-Data-Skills/_posts/processing-code/sendMail-R")

install.packages("gmailr")
# load library
suppressPackageStartupMessages(library(gmailr))

# custom json file
gmail_auth("data-institute-email.json", scope = 'compose')

# scope=https://www.googleapis.com/auth/gmail.compose
# response_type=code
# redirect_uri=http://localhost:1410
# state=H8JTSXEbMZ
# client_id=data-institute-email.json

# install.packages("devtools")
library(devtools)
install_github("jimhester/gmailr")

# From Jim Hester
test_email <- mime(
  To = "lwasser@neoninc.org",
  From = "neondataskills@gmail.com",
  Subject = "this is just a gmailr test")
test_email <- html_body(test_email, "Can <b>you</b> hear me now?")

create_draft(test_email)
send_message(test_email)
ret_val <- send_message(test_email)

## you want to see 200 here
ret_val$status_code



## edit below with email addresses from your life
test_email <- mime(
  To = "leahwasser@gmail.com",
  From = "neondataskills@gmail.com",
  Subject = "this is just a gmailr test",
  body = "Can you hear me now?")

# this returns a BLANK email
test_email <- mime(
  To = "leahwasser@gmail.com",
  From = "neondataskills@gmail.com",
  Subject = "this is just a gmailr test",
  html_body = "Can <b>you hear</b> me now?", type = "text/html")

# this also sends a blank email
test_email <- mime(
  To = "leahwasser@gmail.com",
  From = "neondataskills@gmail.com",
  Subject = "this is just a gmailr test",
  html_body = "<html><body>Can <b>you hear</b> me now?</body></html>")

# install.packages("devtools")
library(devtools)
install_github("jimhester/gmailr")

# From Jim Hester
test_email <- mime(
  To = "lwasser@neoninc.org",
  From = "neondataskills@gmail.com",
  Subject = "this is just a gmailr test")
test_email <- html_body(test_email, "Can <b>you</b> hear me now?")

create_draft(test_email)
send_message(test_email)
ret_val <- send_message(test_email)

## you want to see 200 here
ret_val$status_code

## and you want the email to arrive succesfully!


## to automate emails... let's test this.

suppressPackageStartupMessages(library(gmailr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(purrr))
library(readr)

# load csv 
email.apps <- read_csv("emailList.csv")

this_hw <- "Application Review - Email1"
email_sender <- 'NEON Data Institute <neondataskills@gmail.com>' # your Gmail address
optional_bcc <- 'L Wasser <lwasser@neoninc.org>, Leah Wasser <leahwasser@gmail.com>'     # for me, TA address
body <- "Hi, %s.

Thank you for applying to the 2016 NEON #WorkWithData Institute. We are currently reviewing applications and have a few followup questions.


The cost for the course will be %s dollars. Please get in touch with any followup questions!

The link is here %s.

Thank you,
The NEON Data Skills Team 
"

edat <- email.apps %>%
  mutate(
    To = sprintf('%s <%s>', firstName, email),
    Bcc = optional_bcc,
    From = email_sender,
    Subject = sprintf('Your Data Institute Application for %s', this_hw),
    body = sprintf(body, firstName, cost, paymentLink)) %>%
  select(To, Bcc, From, Subject, body)
edat

write_csv(edat, "application-review-apr1.csv")

# this is required to authenticate if you don't cache auth

gmail_auth("gmailr-tutorial.json", scope = 'compose')

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




require(sendmailR)
from <- "neondataskills@gmail.com"
message = "<HTML><body><b>Hello</b></body></HTML>"
to = c("leahwasser@gmail.com")
subject = "Test Email Alert"

sendmail(from, to, 
         subject, 
         msg = msg,
         control=list(smtpServer="ASPMX.L.GOOGLE.COM"),
         headers=list("Content-Type"="text/html; charset=UTF-8; format=flowed"))
