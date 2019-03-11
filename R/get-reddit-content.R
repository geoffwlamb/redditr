#' Scrape Content from Multiple URLs and combine into a single data frame
#' @description This is the flagship function of redditr. It is designed to
#'     handle the process of constructing a query, generating URLs that
#'     point to content, and importing that content into R. If lower-level
#'     control over that workflow is needed, please see
#'     \link{construct_pushshift_url} and \link{import_reddit_content_from_url}.
#' @param content_type A string containing the type of content you want to
#'     query. The pushshift api supports the following options: "comment" and
#'     "submission". This function defaults to "comment" and gets
#'     passed to \code{construct_pushshift_url}.
#' @param result_limit An integer representing the maximum number of results to
#'     return. Defaults to 500, which is the maximum number of results that can be
#'     returned in a single pushshift api query URL. Please keep in mind your
#'     available system resources and any potential burden on other servers when
#'     determining the number of rows you need.
#' @param timeout An integer representing the maximum amount of time to allow
#'     for retrieving content from a single URL. Defaults to 10 seconds. When
#'     \code{result_limit} is over 500, the timeout resets for every 500 results
#'     that have been returned successfully.
#' @param ... Additional arguments to pass to \code{construct_pushshift_url} that
#'     are used to build the api query.
#' @return A data.frame with content imported from your query
#' @export
#' @examples
#' # get 500 most recent reddit comments avilable from api
#' recent_comments <- get_reddit_content()
#'
#' # get 500 most recent posts
#' recent_posts <- get_reddit_content(content_type = "submission")
#'
#' # get more than 500 comments
#' many_recent_comments <- get_reddit_content(
#'  content_type = "comment",
#'  result_limit = 1000
#' )
#'
#' # wait longer than default 10 seconds per query
#' patient_query <- get_reddit_content(
#' content_type = "comment",
#' timeout = 20
#' )
#' # get posts from a specific subreddit
#' rstats_posts <- get_reddit_content(
#'   content_type = "submission",
#'   subreddit = "rstats"
#' )
#'
#' # get comments from a specific user
#' hadley_comments <- get_reddit_content(
#'   content_type = "comment",
#'   author = "hadley"
#' )
#'
#' # get comments relating to data science
#' comments_before_christmas <- get_reddit_content(
#'   content_type = "comment",
#'   q = "data science"
#' )
#'
#' # get comments before a specific date
#' comments_before_christmas <- get_reddit_content(
#'   content_type = "comment",
#'   before = date_to_api("2018-12-25 00:00:00", tz = "EST")
#' )
#'
#' # get comments after a specific date
#' comments_after_christmas <- get_reddit_content(
#'   content_type = "comment",
#'   after = date_to_api("2018-12-25 23:59:59", tz = "EST")
#' )
#'
get_reddit_content <- function(
                               content_type = "comment",
                               result_limit = 500,
                               timeout = 10,
                               ...) {
  # handle supplied args
  dots <- list(...)
  names(dots) <- tolower(names(dots))

  # warn if size was specified
  if ("size" %in% names(dots)) {
    warning(
      paste0(
        "The size parameter cannot be used with this function.",
        " Using the specified result_limit instead ",
        "(", result_limit, ")."
      )
    )
    dots[["size"]] <- NULL
  }

  # establish maximum time window
  init_before <- date_to_api(Sys.time())
  init_after <- date_to_api("1970-01-01")

  # adjust time window if before or after were supplied
  if ("before" %in% tolower(names(dots))) {
    init_before <- dots[["before"]]
    dots[["before"]] <- NULL
  }
  if ("after" %in% tolower(names(dots))) {
    init_after <- dots[["after"]]
    dots[["after"]] <- NULL
  }

  # initialize working vars
  size <- min(result_limit, 500)
  tmp_left <- result_limit
  tmp_url <- do.call(
    what = construct_pushshift_url,
    args = c(
      list(
        content_type = content_type,
        size = min(tmp_left, 500),
        before = init_before
      ),
      dots
    )
  )
  tmp_df <- data.frame()
  pb_ticks <- ceiling(result_limit / 500)
  pb <- dplyr::progress_estimated(pb_ticks)

  while (tmp_left > 0) {
    # attempt to access new data
    tryCatch(
      expr = {
        tmp_data <- import_reddit_content_from_url(tmp_url, timeout = timeout)
      },
      error = function(cond) {
        warning(
          paste(
            "An error occurred while fetching content.",
            "Returning the current accumulation of content and stopping the process.",
            "Error message:",
            cond
          )
        )
        return({
          tmp_df %>%
            dplyr::filter(as.numeric(created_utc) > as.numeric(init_after)) %>%
            purrr::modify_if(grepl("utc", colnames(.)), api_to_date, tz = "UTC")
        })
      }
    )

    # coerce edited column to character
    if ("edited" %in% colnames(tmp_data)) {
      tmp_data$edited <- as.character(tmp_data$edited)
    }
    # convert retrieved on column to date
    if ("retrieved_on" %in% colnames(tmp_data)) {
      tmp_data$retrieved_on <- api_to_date(tmp_data$retrieved_on, "UTC")
    }

    # add rows retrieved from most recent query to accumulated results
    tmp_df <- dplyr::bind_rows(tmp_df, tmp_data)

    # update progress to output df
    pb$tick()$print()

    # break if nothing returned or final url
    if (is.null(tmp_data)) {
      break
    }
    if (nrow(tmp_data) < size) {
      message("\nReached the end of query results before result limit was met.")
      break
    }

    # update tmp variables
    tmp_left <- result_limit - nrow(tmp_df)
    tmp_url <- do.call(
      what = construct_pushshift_url,
      args = c(
        list(before = min(tmp_df$created_utc), size = min(size, tmp_left)),
        dots
      )
    )
  }

  # filter out records outside of time window and convert times for utc cols
  out <- tmp_df %>%
    dplyr::filter(as.numeric(created_utc) > as.numeric(init_after)) %>%
    purrr::modify_if(grepl("utc", colnames(.)), api_to_date, tz = "UTC")

  # return results
  return(out)
}
