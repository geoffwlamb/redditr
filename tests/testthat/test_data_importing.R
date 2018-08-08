
# functionality ----
context("get_content functionaliy")

test_that("get_content is available", {
  expect_true(exists("get_content"))
})

test_that("get_content returns data.frame", {
  expect_identical(class(get_content(construct_url())), "data.frame")
})

test_that("get_content succeeds for both comments and submissions", {
  expect_error(expect_error(get_content(construct_url(type = "comment"))))
  expect_error(expect_error(get_content(construct_url(type = "submission"))))
})

test_that("get_content contains no list columns", {
  expect_false(
    any(purrr::map_lgl(get_content(construct_url(type = "comment")), is.list))
  )
  expect_false(
    any(purrr::map_lgl(get_content(construct_url(type = "submission")), is.list))
  )
})


context("combine_content functionaliy")

test_that("combine_content is available", {
  expect_true(exists("combine_content"))
})

test_that("combine_content returns data.frame", {
  expect_identical(class(combine_content(501)), "data.frame")
})

test_that("combine_content doesn't use size as a parameter", {
  #check warnings
  expect_warning(combine_content(10, size = 40))
  expect_warning(combine_content(40, size = 10))
  expect_warning(combine_content(10, SIZE = 10))
  expect_warning(combine_content(10, SiZe = 10))

  #check results
  a <- combine_content(10, size = 40)
  b <- combine_content(40, size = 10)
  c <- combine_content(10, SIZE = 10)
  d <- combine_content(10, SiZe = 10)
  expect_equal(nrow(a), 10)
  expect_equal(nrow(b), 40)
  expect_equal(nrow(c), 10)
  expect_equal(nrow(d), 10)
})

test_that("combine_content runs with only single argument", {
  expect_error(expect_error((combine_content(1))))
})

test_that("combine_content succeeds for both comments and submissions", {
  expect_error(expect_error(combine_content(10, type = "comment")))
  expect_error(expect_error(combine_content(10, type = "submission")))
})

# bug fixes ----
context("combine content bug fixes")

test_that("combine_content can use before with n_max > 500", {
  a <- combine_content(501, before = date_to_api("2017-01-01"))
  b <- combine_content(10, before = date_to_api("2017-01-01"))

  expect_equal(nrow(a), 501)
  expect_equal(max(a$created_utc), max(b$created_utc))
})


