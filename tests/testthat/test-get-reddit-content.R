context("test-get-reddit-content")

test_that("before and after parameters can be used", {
  before_test <- get_reddit_content(
    result_limit = 25,
    before = date_to_api("2016-12-25 00:00:00", tz = "UTC")
  )
  after_test <- get_reddit_content(
    result_limit = 25,
    after = date_to_api("2016-12-25 00:00:00", tz = "UTC")
  )
  before_after_test <- get_reddit_content(
    result_limit = 25,
    subreddit = "rstats",
    before = date_to_api("2016-12-25 00:00:00", tz = "UTC"),
    after = date_to_api("2015-12-25 00:00:00", tz = "UTC")
  )

  expect_true(
    max(before_test$created_utc) < as.POSIXct("2016-12-25 00:00:00", tz = "UTC")
  )
  expect_true(
    min(after_test$created_utc) > as.POSIXct("2016-12-25 00:00:00", tz = "UTC")
  )
  expect_true(
    max(before_after_test$created_utc) < as.POSIXct("2016-12-25 00:00:00", tz = "UTC")
  )
  expect_true(
    min(before_after_test$created_utc) > as.POSIXct("2015-12-25 00:00:00", tz = "UTC")
  )
})

# reference df
ref <- get_reddit_content(
  before = date_to_api("2016-12-25 00:00:00", tz = "UTC")
)

test_that("size parameter is ignored with warning", {
  expect_warning(
    object = get_reddit_content(size = 1),
    regexp = "The size parameter cannot be used with this function. Using the specified result_limit instead (500).",
    fixed = TRUE
  )
  size_test <- suppressWarnings(
    get_reddit_content(
      before = date_to_api("2016-12-25 00:00:00", tz = "UTC"),
      size = 123
    )
  )
  expect_identical(ref, size_test)
})

test_that("requests over 500 results work", {
  large_test <- get_reddit_content(result_limit = 501)
  expect_true(nrow(large_test) == 501)
})

test_that("timeout returns data.frame with timeout message", {
  expect_message(
    object = get_reddit_content(q = "the", timeout = 1),
    regexp = "Time limit for a single request was exceeded.",
    fixed = TRUE
  )
  timeout_test <- suppressMessages(
    get_reddit_content(q = "the", timeout = 1)
  )
  expect_is(timeout_test, "data.frame")
})
