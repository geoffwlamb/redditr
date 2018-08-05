#' Construct a URL to access Reddit Content
#'
#' @param type Type of content you're looking for. Permissible values are "comment" and "submission"
#' @param author String representing the handle of a specific Reddit account
#' @param subreddit String representing a subreddit to extract data from
#' @param size How many records to return, max is 500
#' @param before Integer represting time in . Defaults to current time. Functionality for using this parameter more comprehensively in development.
#' @param manual String that lets you interface directly with the API. Overrides any other parameters and appends passed argument to URL.
#'
#' @return A string representing a URL providing Reddit content
#' @export
#'
#' @examples
#' #Grab 500 most recent comments on Reddit
#' construct_url()
construct_url <- function(
  type = "comment",
  author = "",
  subreddit = "",
  size = 500,
  before = as.numeric(Sys.time()),
  manual = NULL
){

  #validate type
  if (length(type) != 1) {
    stop(
      'Please use a single string (either "comment" or "submission") for type'
    )
  }
  if (!(type %in% c("comment", "submission"))) {
    stop(
      'Invalid type argument. Please use either "comment" or "submission"'
    )
  }

  #build stub
  url_stub <- "https://api.pushshift.io/reddit/search/"

  #add type
  type <- paste(type, "/?", sep = "")

  #override other parameters if manual argument is supplied
  if (!is.null(manual)) {
    return(paste(url_stub, type, manual, sep = ""))
  }

  #add any other supplied components
  before <- paste("before=", round(before), sep = "")
  size <- paste("&size=", size, sep = "")
  if(author != ""){
    author <- paste("&author=", author, sep = "")
  }
  if(subreddit != ""){
    subreddit <- paste("&subreddit=",subreddit, sep = "")
  }

  #return URL
  return(paste(url_stub, type, before, size, author, subreddit, sep = ""))

}
