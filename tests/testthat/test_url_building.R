context("construct_url functionaliy")

test_that("construct_url is available", {
  expect_true(exists("construct_url"))
})

test_that("type argument is enforced", {
  expect_error(construct_url(type = "bad"))
  expect_error(construct_url(type = c("comment", "submission")))
  expect_identical(
    construct_url(type = "comment"),
    "https://api.pushshift.io/reddit/search/comment/?&="
  )
  expect_identical(
    construct_url(type = "submission"),
    "https://api.pushshift.io/reddit/search/submission/?&="
  )
})

context("date_to_api functionality")

test_that("date_to_api is availble", {
  expect_true(exists("date_to_api"))
})

test_that("timezone affects output", {
  expect_lt(
    as.integer(date_to_api("2010-01-01", "UTC")),
    as.integer(date_to_api("2010-01-01", "EST"))
  )
  expect_gt(
    as.integer(date_to_api("2010-01-01", "UTC")),
    as.integer(date_to_api("2010-01-01", "Australia/Sydney"))
  )
})

test_that("time is granular beyond days", {
  expect_gt(
    as.integer(date_to_api("2010-01-01 01:02:03")),
    as.integer(date_to_api("2010-01-01"))
  )
})


