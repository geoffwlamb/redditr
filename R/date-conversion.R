#' Convert String or Date to API Input
#' @description This function converts dates from a human-consumable format
#'     (e.g. 2008-12-15) to their equivalent time in seconds since the Unit
#'     Epoch (1970-01-01 00:00:00 UTC), which is how Pushshift's API expects
#'     dates.
#' @param date A date (which can be a string representing a validly formatted
#'     date or one of the Date types) to compare to the Unit epoch, granular
#'     down to seconds.
#' @param tz The timezone of the date to compare, defaults to system's timezone
#'     for direct use.
#' @return A string representing a time (in seconds) that the api can use to
#'     return results.
#' @export
#' @examples
#' # convert today
#' date_to_api(Sys.Date())
#'
#' # convert a specific date
#' date_to_api("2018-03-21")
#'
#' # pass as argument to construct_pushshift_url
#' construct_pushshift_url(before = date_to_api("2017-01-01"))
date_to_api <- function(date, tz = "") {
  origin <- as.POSIXct("1970-01-01", tz = "UTC")
  comp_date <- as.POSIXct(date, tz = tz)

  raw_text <- format(
    as.numeric(difftime(comp_date, origin, units = "secs")),
    scientific = FALSE
  )

  return(sub("^\\s+", "", raw_text))
}

#' Convert API Time Back to a Timestamp
#' @description This is a convenience function that wraps \code{as.POSIXct} to
#'     convert a time represented in seconds after the unit epoch to
#'     a more human interpretable timestamp.
#' @param api_date A date or vector of dates to be converted
#' @param tz The timezone you want the resulting output to be in, defaults
#'     to system's timezone when calling this function directly.
#' @return A POSIXct of the input
#' @export
#' @examples
#' # capture the current time
#' right_now <- Sys.time()
#'
#' # convert it to api format (seconds after unit epoch)
#' right_now_as_api <- date_to_api(right_now)
#'
#' # and back to current time
#' api_to_date(right_now_as_api)
api_to_date <- function(api_date, tz = "") {
  as.POSIXct(as.numeric(api_date), origin = "1970-01-01", tz = tz)
}
