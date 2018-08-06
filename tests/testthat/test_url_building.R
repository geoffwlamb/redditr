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



