#' Construct a URL to access Reddit Content
#'
#' @param type Type of content you're looking for. Permissible values are "comment" and "submission"
#' @param ... Additional parameters to pass to api query. See details below.
#'
#' @return A string containing a URL pointing to JSON Reddit data
#' @export
#'
#' @details Here's the list of parameters that the api can use: https://github.com/pushshift/api#search-parameters-for-comments. The api ignores unrecognized parameters, so you may want to verify your output.
#'
#' @examples
#' # URL for most recent comments on Reddit
#' construct_url()
#'
#' # Grab 500 instead of default 25
#' construct_url(size = 500)
#'
#' # Grab posts from specific subreddit
#' construct_url(type = "submission", subreddit = "rstats")
#'
#' # Grab posts on a certain date
#' construct_url(
#'  type = "submission,
#'  subreddit = "rstats",
#'  before = date_to_api("2017-03-14"),
#'  after = date_to_api("2017-03-12")
#' )
#'
construct_url <- function(type = "comment", ...) {

  # validate type
  if (length(type) != 1) {
    stop('Please use a single string (either "comment" or "submission") for type')
  }
  if (!(type %in% c("comment", "submission"))) {
    stop('Invalid type argument. Please use either "comment" or "submission"')
  }

  # build stub
  url_stub <- "https://api.pushshift.io/reddit/search/"

  # add type
  type <- paste(type, "/?", sep = "")

  # add any other supplied components
  params <- c(...)
  api_query <- paste("&", names(params), "=", params, sep = "", collapse = "")

  # return URL
  return(paste(url_stub, type, api_query, sep = ""))
}


#' Convert String or Date to API Input
#'
#' @param date A date to compare to the Unit epoch, granular down to seconds
#' @param tz The timezone of the date to compare, defaults to system's timezone
#'
#' @return A string representing a time (in seconds) that the api can use to return results
#' @export
#' @description Converts a supplied date to microseconds, which can get passed to date arguments (e.g. before, after) in construct_url
#' @examples
#' # Convert today
#' date_to_api(Sys.Date())
#'
#' # Pass as argument to construct_url
#' construct_url(before = date_to_api("2017-01-01"))
#'
date_to_api <- function(date, tz = "") {
  origin <- as.POSIXct("1970-01-01", tz = "UTC")
  comp_date <- as.POSIXct(date, tz = tz)

  raw_text <- format(
    as.numeric(difftime(comp_date, origin, units = "secs")),
    scientific = FALSE
  )

  sub("^\\s+", "", raw_text)
}

#' Convert API Time Back to a Timestamp
#' @description This is a convenience function that wraps as.POSIXct to
#'     convert a time represented in seconds after the unit epoch to
#'     a more human interpretable timestamp.
#' @param api_date A date or vector of dates to be converted
#' @param tz The timezone you want the resulting output to be in, defaults
#'     to system's timezone
#' @return A POSIXct of the input
#' @export
#' @examples
#' # Convert current time to API
#' right_now <- Sys.time()
#'
#' # Convert it back to
#' right_now_as_api <- date_to_api(right_now)
#'
#' # And back to current time
#' api_to_date(right_now_as_api)
#'
api_to_date <- function(api_date, tz = "") {
  as.POSIXct(as.numeric(api_date), origin = "1970-01-01", tz = tz)
}
