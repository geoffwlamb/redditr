context("each api parameter affects results")

test_that("reference dataset is consistent", {
  a <- get_content(construct_url(size = 10, before = date_to_api("2017-01-01")))
  Sys.sleep(3)
  b <- get_content(construct_url(size = 10, before = date_to_api("2017-01-01")))
  expect_identical(a,b)
})

test_that("known parameters alter comment queries", {
  #baseline, not checking size, before, after, aggs, frequency, or sort_type here
  ref_url <- construct_url(size = 10, before = date_to_api("2016-01-01"))
  ref <- get_content(ref_url)

  expect_false(
    identical(ref, get_content(paste0(ref_url, "&q=programming")))
  )
  expect_false(
    identical(ref, get_content(paste0(ref_url, "&ids=123,456")))
  )
  expect_false(
    identical(ref, get_content(paste0(ref_url, "&fields=created_utc,subreddit")))
  )
  expect_false(
    identical(ref, get_content(paste0(ref_url, "&sort=asc")))
  )
  expect_false(
    identical(ref, get_content(paste0(ref_url, "&author=hadley")))
  )

})

test_that("known parameters alter submission queries", {
  #baseline, not checking size, before, after, aggs, frequency here
  ref_url <- construct_url(
    size = 10,
    before = date_to_api("2016-01-01"),
    type = "submission"
  )
  ref <- get_content(ref_url)

  expect_false(
    identical(ref, get_content(paste0(ref_url, "&q=programming")))
  )
  # These are known issues on the pushshift api gihub
  # expect_false(
  #   identical(ref, get_content(paste0(ref_url, "&ids=123,456")))
  # )
  # expect_false(
  #   identical(ref, get_content(paste0(ref_url, "&fields=created_utc,subreddit")))
  # )
  expect_false(
    identical(ref, get_content(paste0(ref_url, "&sort=asc")))
  )
  expect_false(
    identical(ref, get_content(paste0(ref_url, "&sort_type=score")))
  )
})
