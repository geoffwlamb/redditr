
<!-- README.md is generated from README.Rmd. Please edit that file -->

# redditr

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/geoffwlamb/redditr.svg?branch=master)](https://travis-ci.org/geoffwlamb/redditr)
[![Coverage
status](https://codecov.io/gh/geoffwlamb/redditr/branch/master/graph/badge.svg)](https://codecov.io/github/geoffwlamb/redditr?branch=master)
<!-- badges: end -->

## Overview

redditr is an R package intended to help obtain content from Reddit by
interfacing with the <a href = "https://github.com/pushshift/api">
pushshift.io Reddit API</a>.

The immediate scope of this package is to provide functionality for
importing Reddit comment and post data into R. Some additional
functionality is provided for handling time-based information. Aside
from that, redditr will not try to do any general text or data cleaning.
Other, far more established packages are better options for handling
text data once it’s been imported into R.

Let’s see how this goes…

## Installation

Install via devtools:

``` r
devtools::install_github("geoffwlamb/redditr")
```

## Examples

The redditr package’s flagship function,
<code>get\_reddit\_content</code>, takes [pushshift.io API Search
Parameters](https://github.com/pushshift/api#search-parameters-for-comments)
as arguments and returns a data.frame with information related your
query. Below are some ideas for how you can use this function.

### Basic Usage

If you call <code>get\_reddit\_content</code> without specifying any of
the parameters the pushshift api is looking for, you’ll end up getting
the 500 most recent comments available from the api. If you want
information relating to posts instead, you can change the
<code>content\_type</code> argument to “submission”.

``` r
# load redditr
library(redditr)

# get 500 most recent reddit comments avilable from api
recent_comments <- get_reddit_content()

# get 500 most recent posts
recent_posts <- get_reddit_content(content_type = "submission")
```

### Adjusting Limits to Returned Results and Query Time

The pushshift api limits returns a maximum of 500 results in a single
query. You can use <code>get\_reddit\_content</code> to automate the
process of sending multiple queries and collecting them into a single
data frame. Also, if you are having issues with queries taking too long
to return information, you can adjust the amount of time the function
will wait for data before giving up. The function defaults to 10
seconds.

``` r
# get more than 500 comments
many_recent_comments <- get_reddit_content(
  content_type = "comment", 
  result_limit = 1000
)

# wait 20 seconds per query
patient_query <- get_reddit_content(
  content_type = "comment",
  timeout = 20
)
```

### Using Pushshift API Parameters

Using parameters available as part of the Pushshift api helps tailor the
results returned from <code>get\_reddit\_content</code> to whatever your
needs may be. The available parameters can be passed to the function as
named arguments, like so:

``` r
# get posts from a specific subreddit
rstats_posts <- get_reddit_content(
  content_type = "submission",
  subreddit = "rstats"
)

# get comments from a specific user
hadley_comments <- get_reddit_content(
  content_type = "comment",
  author = "hadley"
)

# get comments relating to data science 
comments_before_christmas <- get_reddit_content(
  content_type = "comment",
  q = "data science"
)
```

### Specifying Dates in API Queries

Finally, two parameters in the Pushshift api can be used to filter
results based on time: <code>before</code> and <code>after</code>. These
two parameters are expecting dates to be provided in a very particular
format: [Unix Time](https://en.wikipedia.org/wiki/Unix_time). A function
for converting typical date formats to Unix time is available as part of
redditr: <code>date\_to\_api</code>.

``` r
# get comments before a specific date
comments_before_christmas <- get_reddit_content(
  content_type = "comment",
  before = date_to_api("2018-12-25 00:00:00", tz = "EST")
)

# get comments after a specific date 
comments_after_christmas <- get_reddit_content(
  content_type = "comment",
  after = date_to_api("2018-12-25 23:59:59", tz = "EST")
)
```

<br>

<hr>

<br>

Hopefully that captures the essence of what this package aims to
accomplish. Please feel free to let me know if anything isn’t working
well and thanks for checking out redditr\!
