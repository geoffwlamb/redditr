
# date_to_api -------------------------------------------------------------
context("date_to_api functionality")

test_that("date_to_api is availble", {
  expect_true(
    exists("date_to_api", where="package:redditr", mode="function")
  )
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


# api_to_date -------------------------------------------------------------
context("api_to_date_functionality")

test_that("api_to_date is availble", {
  expect_true(
    exists("api_to_date", where="package:redditr", mode="function")
  )
})

test_that("api_to_date and date_to_api are inverses", {
  a <- as.POSIXct("2017-01-01 10:10:10")
  b <- date_to_api(a)
  c <- api_to_date(b)

  expect_identical(a, c)
})

