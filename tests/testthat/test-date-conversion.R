context("test-date-conversion")

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

test_that("time is granular down to seconds", {
  expect_gt(
    as.integer(date_to_api("2010-01-02")),
    as.integer(date_to_api("2010-01-01"))
  )
  expect_gt(
    as.integer(date_to_api("2010-01-01 01:00:00")),
    as.integer(date_to_api("2010-01-01"))
  )
  expect_gt(
    as.integer(date_to_api("2010-01-01 01:01:00")),
    as.integer(date_to_api("2010-01-01 01:00:00"))
  )
  expect_gt(
    as.integer(date_to_api("2010-01-01 01:00:01")),
    as.integer(date_to_api("2010-01-01 01:00:00"))
  )
})

test_that("api_to_date and date_to_api are inverses", {
  a <- as.POSIXct("2017-01-01 10:10:10")
  b <- date_to_api(a)
  c <- api_to_date(b)

  expect_identical(a, c)
})
