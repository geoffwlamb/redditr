% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/url-building.R
\name{construct_pushshift_url}
\alias{construct_pushshift_url}
\title{Construct a URL to Access Reddit Content}
\usage{
construct_pushshift_url(content_type = "comment", ...)
}
\arguments{
\item{content_type}{A string containing the type of content you want to
query. The Pushshift API supports the following options: "comment" and
"submission". This function defaults to "comment".}

\item{...}{Additional parameters to pass to api query. See Details below.}
}
\value{
A string containing a URL pointing to JSON Reddit data
}
\description{
This function is designed to convert query parameters supplied
as arguments into a URL leading to JSON content that can be accessed
via other functions. In particular, this function is designed to provide
the input for \link{import_reddit_content_from_url}, which, in turn, is
a function that is used to power redditr's flagship function,
\link{get_reddit_content}. Using this function directly may be useful
if you need to access the raw JSON for your query.
}
\details{
Here's the list of parameters that the API can use:
https://github.com/pushshift/api#search-parameters-for-comments.
The api ignores unrecognized parameters, so you may want to verify
your output.
}
\examples{
# url for most recent comments on Reddit
construct_pushshift_url(content_type = "comment")

# url for most recent submissions on Reddit
construct_pushshift_url(content_type = "submission")

# url for 500 most recent comments on Reddit
construct_pushshift_url(size = 500)

# url for 25 most recent posts from the rstats subreddit
construct_pushshift_url(type = "submission", subreddit = "rstats")

# url for 25 most recent posts from the rstats subreddit
construct_pushshift_url(
  type = "submission",
  subreddit = "rstats",
  before = date_to_api("2017-03-14"),
  after = date_to_api("2017-03-12")
)
}
