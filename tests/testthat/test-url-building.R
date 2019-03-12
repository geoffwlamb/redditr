context("test-url-building")

test_that("error handling produces expected output", {
  expect_error(
    construct_pushshift_url(content_type = "bad"),
    regexp = 'Invalid content_type argument. Please use either "comment" or "submission"',
    fixed = TRUE
  )
  expect_error(
    construct_pushshift_url(content_type = c("comment", "submission")),
    regexp = 'Please use a single string (either "comment" or "submission") for type',
    fixed = TRUE
  )
  expect_error(
    construct_pushshift_url(content_type = c("bad", "comment")),
    regexp = 'Please use a single string (either "comment" or "submission") for type',
    fixed = TRUE
  )
})

test_that("urls are constructed appropriately", {
  expect_identical(
    construct_pushshift_url(content_type = "comment"),
    "https://api.pushshift.io/reddit/search/comment/?&="
  )
  expect_identical(
    construct_pushshift_url(content_type = "submission"),
    "https://api.pushshift.io/reddit/search/submission/?&="
  )
  expect_identical(
    construct_pushshift_url(content_type = "submission", q = '"hello world"'),
    'https://api.pushshift.io/reddit/search/submission/?&q="hello%20world"'
  )
  expect_identical(
    construct_pushshift_url(content_type = "comment", newparam = "newval"),
    "https://api.pushshift.io/reddit/search/comment/?&newparam=newval"
  )
  expect_identical(
    construct_pushshift_url(content_type = "comment", param1 = "val1", param2 = "val2"),
    "https://api.pushshift.io/reddit/search/comment/?&param1=val1&param2=val2"
  )
  expect_identical(
    construct_pushshift_url(content_type = "comment", param1 = 1, param2 = 2),
    "https://api.pushshift.io/reddit/search/comment/?&param1=1&param2=2"
  )
  expect_identical(
    construct_pushshift_url(content_type = "comment", param1 = 1, param2 = NULL),
    "https://api.pushshift.io/reddit/search/comment/?&param1=1"
  )
})
