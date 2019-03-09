
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
<code>get\_reddit\_content</code>, takes [Pushshift.io API Search
Parameters](https://github.com/pushshift/api#search-parameters-for-comments)
as arguments and returns a data.frame with information related your
query. Here are some ideas for how you can use this function:

``` r
# load redditr
library(redditr)
```

<br>

<hr>

<br>

Hopefully that captures the essence of what this package aims to
accomplish. At some point, I’ll add a bit more error handling to ensure
the validity of constructed urls, but in the meantime, please experiment
with the parameters
<a href = "https://github.com/pushshift/api#search-parameters-for-comments">
here</a> (and feel free to let me know if anything isn’t working well).

Thanks for checking out redditr\!
