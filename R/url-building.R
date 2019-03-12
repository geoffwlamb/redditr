#' Construct a URL to Access Reddit Content
#' @description This function is designed to convert query parameters supplied
#'     as arguments into a URL leading to JSON content that can be accessed
#'     via other functions. In particular, this function is designed to provide
#'     the input for \link{import_reddit_content_from_url}, which, in turn, is
#'     a function that is used to power redditr's flagship function,
#'     \link{get_reddit_content}. Using this function directly may be useful
#'     if you need to access the raw JSON for your query.
#' @param content_type A string containing the type of content you want to
#'     query. The Pushshift API supports the following options: "comment" and
#'     "submission". This function defaults to "comment".
#' @param ... Additional parameters to pass to api query. See Details below.
#' @return A string containing a URL pointing to JSON Reddit data
#' @export
#' @details Here's the list of parameters that the API can use:
#'      https://github.com/pushshift/api#search-parameters-for-comments.
#'      The api ignores unrecognized parameters, so you may want to verify
#'      your output.
#' @examples
#' # url for most recent comments on Reddit
#' construct_pushshift_url(content_type = "comment")
#' 
#' # url for most recent submissions on Reddit
#' construct_pushshift_url(content_type = "submission")
#' 
#' # url for 500 most recent comments on Reddit
#' construct_pushshift_url(size = 500)
#' 
#' # url for 25 most recent posts from the rstats subreddit
#' construct_pushshift_url(type = "submission", subreddit = "rstats")
#' 
#' # url for 25 most recent posts from the rstats subreddit
#' construct_pushshift_url(
#'   type = "submission",
#'   subreddit = "rstats",
#'   before = date_to_api("2017-03-14"),
#'   after = date_to_api("2017-03-12")
#' )
construct_pushshift_url <- function(content_type = "comment", ...) {
  # validate type
  if (length(content_type) != 1) {
    stop('Please use a single string (either "comment" or "submission") for type')
  }
  if (!(content_type %in% c("comment", "submission"))) {
    stop('Invalid content_type argument. Please use either "comment" or "submission"')
  }

  # build stub
  url_stub <- "https://api.pushshift.io/reddit/search/"

  # add type
  type <- paste(content_type, "/?", sep = "")

  # add any other supplied components
  params <- c(...)
  api_query <- paste("&", names(params), "=", params, sep = "", collapse = "")

  # combine parts and replace spaces with pluses
  url_string <- gsub(" ", "%20", paste0(url_stub, type, api_query))

  return(url_string)
}
