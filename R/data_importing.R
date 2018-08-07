
#' Import data from URL
#'
#' @description This function is a wrapper around jsonlite::fromJSON that returns
#'     a data.frame instead of a list.
#' @param url A url leading to JSON data, typically produced from construct_url
#' @return A data.frame with scraped data from the provided url
#' @export
#' @examples
#' # Read 25 recent Reddit comments into R
#' get_content(construct_url())
#' # Simplify the returned dataset
#' get_content(construct_url(), drop_list_cols = TRUE, drop_empty_cols = TRUE)
get_content <- function(url){
  # removing nested data for now so that combine_content works as expected
  jsonlite::fromJSON(url)[[1]] %>%
    purrr::modify_if(is.list, function(x){NULL})
}


#' Scrape content from multiple URLs and combine into a single data frame
#' @description This function dynamically constructs URLs and imports the
#'     data contained within them. It is designed to automate the process of importing
#'     larger amounts of data.
#' @param n_max Max number of rows to return. Please keep in mind your available
#'     system resources and any potential burden on other servers when determing
#'     the number of rows you need.
#' @param ... Additional arguments to pass to construct_url to build api query.
#' @return A data.frame with content imported from your query
#' @export
combine_content <- function(n_max, ...){

  if("size" %in% tolower(names(c(...)))) {
    stop("Size cannot be passed to the api for this function. Please use n_max instead")
  }

  #initialize variables
  size <- min(n_max, 500)
  tmp_left <- n_max
  tmp_url <- construct_url(
    size = min(tmp_left, 500),
    ...
  )
  tmp_df <- data.frame()

  while (tmp_left > 0) {
    # add new data
    tmp_data <- get_content(tmp_url)
    tmp_df <- dplyr::bind_rows(tmp_df, tmp_data)

    # update tmp variables
    tmp_left <- n_max - nrow(tmp_df)
    tmp_url <- construct_url(
      before = min(tmp_df$created_utc),
      size = min(size, tmp_left),
      ...
    )
    # break if final url
    if (nrow(tmp_data) < size) {
      break
    }
  }

  return(tmp_df)
}
