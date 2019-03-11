#' Import Data from a Pushshift URL
#' @description This function is a wrapper around \code{jsonlite::fromJSON}
#'     that returns a data.frame instead of a list. This function is primarily
#'     useful for powering \code{get_reddit_content}, but can also be called
#'     directly on a single url obtained via \code{construct_pushshift_url}.
#' @param url A url leading to JSON data, typically produced via
#'     \code{construct_pushshift_url}.
#' @param timeout An integer representing the maximum amount of time to allow
#'     for retrieving content from a single URL. Defaults to 10 seconds.
#' @return A data.frame with data available from the provided url
#' @export
#' @examples
#' # read the 25 recent Reddit comments into R
#' import_reddit_content_from_url(construct_pushshift_url())
#'
#' # construct a url using pushshift api parameters
#' comments_url <- construct_pushshift_url(
#'   content_type = "comment",
#'   q = "Stardew Valley",
#'   subreddit = "games"
#' )
#'
#' # import data from that url
#' comments_df <- import_reddit_content_from_url(comments_url)
import_reddit_content_from_url <- function(url, timeout = 10) {
  tryCatch(
    expr = R.utils::withTimeout(
      expr = {
        jsonlite::fromJSON(url)[[1]] %>%
          # only keep standard data.frame column types in output
          purrr::keep(~ (is.numeric(.x) | is.character(.x) | is.logical(.x)))
      },
      timeout = timeout
    ),
    TimeoutException = function(ex) {
      message("Time limit for a single request was exceeded.")
    }
  )
}
