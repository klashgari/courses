---
title: "lubridate.package.notes.md"
output: html_document
---

# lubridate lib

lubridate contains many useful functions. We'll only be covering the basics here. Type help(package =
lubridate) to bring up an overview of the package, including the package DESCRIPTION, a list of
available functions, and a link to the official package vignette.

```sh
library(lubridate)

help( package = lubridate)

```

Unfortunately, due to different date and time representations, this lesson is only guaranteed to work
with an "en_US.UTF-8" locale. To view your locale, type 
```sh

> Sys.getlocale("LC_TIME")
[1] "en_US.UTF-8"

```

## today()

The today() function returns today's date. Give it a try, storing the result in a new variable called this_day.

There are three components to this date. In order, they are year, month, and day. We can extract any of these components using the year(), month(), or day() function, respectively. Try any of those on
this_day now.
We can also get the day of the week from this_day using the wday() function. It will be represented as a number, such that 1 = Sunday, 2 = Monday, 3 = Tuesday, etc.
```sh
> today()
[1] "2014-09-08"

> month(this_day)
[1] 9

> wday(this_day)
[1] 2

> wday(this_day, label=TRUE)
[1] Mon
Levels: Sun < Mon < Tues < Wed < Thurs < Fri < Sat

```

## now()
In addition to handling dates, lubridate is great for working with date and time combinations, referred to as date-times. The now() function returns the date-time representing this exact moment in time. Just like with dates, we can extract the year, month, day, or day of week. However, we can also use hour(), minute(), and second() to extract specific time information. To see how these functions work, try ymd("1989-05-17"). You must surround the date with quotes. Store the result in a variable called my_date.

```sh
> now()
[1] "2014-09-08 20:28:22 PDT"

> this_moment <- now()

> this_moment
[1] "2014-09-08 20:30:04 PDT"

> hour(this_moment)
[1] 20

> my_date <- ymd("1989-05-17")
> my_date
[1] "1989-05-17 UTC"

> class(my_date)
[1] "POSIXct" "POSIXt" 

> ymd("1989 May 17")
[1] "1989-05-17 UTC"

> mdy("March 12, 1975")
[1] "1975-03-12 UTC"
```

lubridate will often know the right thing to do. Parse
25081985, which is supposed to represent the 25th day of August 1985. Note that we are actually parsing a numeric value here

```sh
> dmy(25081985)
[1] "1985-08-25 UTC"

> ymd("1920/1/2")
[1] "1920-01-02 UTC"

> ymd_hms(dt1)
[1] "2014-08-23 17:23:02 UTC"

```
What if we have a time, but no date? Use the appropriate lubridate function to parse "03:22:14"
(hh:mm:ss).

```sh
> hms("03:22:14")
[1] "3H 22M 14S"

```

## vector of dates
lubridate is also capable of handling vectors of dates, which is particularly helpful when you need to parse an entire column of data.

```sh
> dt2
[1] "2014-05-14" "2014-09-22" "2014-07-11"

> ymd(dt2)
[1] "2014-05-14 UTC" "2014-09-22 UTC" "2014-07-11 UTC"


```

## updating dates

The update() function allows us to update one or more components of a date-time. For example, let's say the current time is 08:34:55 (hh:mm:ss). Update this_moment to the new time using the following
command:   update(this_moment, hours = 8, minutes = 34, seconds = 55).


```sh
> this_moment
[1] "2014-09-08 20:30:04 PDT"

> update(this_moment, hours = 8, minutes = 34, seconds = 55)
[1] "2014-09-08 08:34:55 PDT"

```

## time zone definitions
For a complete list of valid time zones for use with lubridate, check out the following Wikipedia page:  http://en.wikipedia.org/wiki/List_of_tz_database_time_zones

```sh
> nyc
[1] "2014-09-09 00:02:05 EDT"

> depart <- nyc + days(2)

> depart
[1] "2014-09-11 00:02:05 EDT"

> depart <- update( depart , hours = 17, minutes = 34)

> depart
[1] "2014-09-11 17:34:05 EDT"

> arrive <- depart + hours(15) + minutes(50)

```
### with_tz()

Use with_tz() to convert arrive to the "Asia/Hong_Kong" time zone.

```sh
arrive <- with_tz(arrive,"Asia/Hong_Kong" )

> arrive
[1] "2014-09-12 21:24:05 HKT"

last_time <- mdy("June 17, 2008", tz = "Singapore")

> last_time
[1] "2008-06-17 SGT"


> how_long <- new_interval(last_time, arrive)
> as.period(how_long)
[1] "6y 2m 26d 21H 24M 5.56447529792786S"

```

To address these complexities, the authors of lubridate introduce four classes of time related objects: instants, intervals, durations, and periods. These topics are beyond the scope of this lesson, but you can find a complete discussion in the 2011 Journal of Statistical Software paper titled 'Dates and Times Made Easy with lubridate'.

```sh
> stopwatch()
[1] "1H 9M 27.0736997127533S"

```
