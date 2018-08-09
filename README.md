# redditr
redditr is an R package intended to help obtain content from Reddit by interfacing with the <a href = "https://github.com/pushshift/api"> pushshift.io Reddit API</a>.

The immediate scope of this package is to build functionality for getting Reddit data into R. Longer term, I'm also hoping to add functionality for prepping data for analysis/visualization. Let's see how this goes...

## Installation
Install via devtools:
``` r
devtools::install_github("geoffwlamb/redditr")
```
## Examples
Here are the basic approaches to using redditr:
``` r
# load redditr
library(redditr)

# construct a url pointing to data
url <- construct_url(type = "submission", subreddit = "rstats")

# import the data from the url
posts <- get_content(url)

# automate the process for larger data
many_posts <- combine_content(n_max = 1000, type = "submission", subreddit = "rstats")
```

Make sure to check out ( ). At some point, I'll add a bit more error handling to ensure the validity of constructed urls, but in the meantime, please experiment with the parameters <a href = "https://github.com/pushshift/api#search-parameters-for-comments"> here</a> (and feel free to let me know if anythign isn't working well).

Thanks for checking out redditr!


[![Travis build status](https://travis-ci.org/geoffwlamb/redditr.svg?branch=master)](https://travis-ci.org/geoffwlamb/redditr)

[![Coverage status](https://codecov.io/gh/geoffwlamb/redditr/branch/master/graph/badge.svg)](https://codecov.io/github/geoffwlamb/redditr?branch=master)
