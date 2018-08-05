context("construct_url functionaliy")

test_that("construct_url is available", {
  expect_true(exists("construct_url"))
})

test_that("type argument is enforced", {
  expect_error(construct_url(type = "bad"))
  expect_error(construct_url(type = c("comment", "submission")))
})

test_that("URL is returned witout passing arguments", {
  expect_type(construct_url(), "character")
})
