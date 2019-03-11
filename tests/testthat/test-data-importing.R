context("test-data-importing")

# establish reference comment datasets
test_date <- date_to_api("2017-01-01", tz = "UTC")
ref_comment <- import_reddit_content_from_url(
  construct_pushshift_url(before = test_date)
)
Sys.sleep(3)
ref_comment_wait <- import_reddit_content_from_url(
  construct_pushshift_url(before = test_date)
)
test_that("reference comment data is static", {
  expect_identical(ref_comment, ref_comment_wait)
})

test_that("all columns in comment reference data are typical classes", {
  classes <- ref_comment %>% purrr::map_chr(class)
  expect_true(all(classes %in% c("logical", "integer", "numeric", "character")))
})

test_that("known api parameters affect results for comments, unknown do not", {
  # not testing frequency or aggs
  q <- import_reddit_content_from_url(
    construct_pushshift_url(before = test_date, q = "programming")
  )
  ids <- import_reddit_content_from_url(
    construct_pushshift_url(before = test_date, ids = "123,456")
  )
  size <- import_reddit_content_from_url(
    construct_pushshift_url(before = test_date, size = 10)
  )
  fields <- import_reddit_content_from_url(
    construct_pushshift_url(
      before = test_date,
      fields = "created_utc,subreddit"
    )
  )
  sort <- import_reddit_content_from_url(
    construct_pushshift_url(before = test_date, sort = "asc")
  )
  author <- import_reddit_content_from_url(
    construct_pushshift_url(before = test_date, author = "hadley")
  )
  subreddit <- import_reddit_content_from_url(
    construct_pushshift_url(before = test_date, subreddit = "rstats")
  )
  after <- import_reddit_content_from_url(
    construct_pushshift_url(
      before = test_date,
      after = date_to_api("2016-12-31 23:59:58", tz = "UTC")
    )
  )
  not_a_param <- import_reddit_content_from_url(
    construct_pushshift_url(before = test_date, not_a_param = "test")
  )

  expect_false(identical(q, ref_comment))
  expect_true(nrow(q) > 0)

  expect_false(identical(ids, ref_comment))
  expect_true(nrow(ids) == 2)

  expect_false(identical(size, ref_comment))
  expect_true(nrow(size) == 10)

  expect_false(identical(fields, ref_comment))
  expect_true(nrow(fields) > 0)
  expect_true(ncol(fields) == 2)

  expect_false(identical(sort, ref_comment))
  expect_true(nrow(sort) > 0)

  expect_false(identical(author, ref_comment))
  expect_true(nrow(author) > 0)

  expect_false(identical(subreddit, ref_comment))
  expect_true(nrow(subreddit) > 0)

  expect_false(identical(after, ref_comment))
  expect_true(nrow(after) > 0)

  expect_identical(not_a_param, ref_comment)
})


# establish reference submission datasets
test_date <- date_to_api("2017-01-01", tz = "UTC")
ref_submission <- import_reddit_content_from_url(
  construct_pushshift_url(content_type = "submission", before = test_date)
)
Sys.sleep(3)
ref_submission_wait <- import_reddit_content_from_url(
  construct_pushshift_url(content_type = "submission", before = test_date)
)
test_that("reference submission data is static", {
  expect_identical(ref_submission, ref_submission_wait)
})

test_that("all columns in submission reference data are typical classes", {
  classes <- ref_submission %>% purrr::map_chr(class)
  expect_true(all(classes %in% c("logical", "integer", "numeric", "character")))
})

test_that("known api parameters affect results, unknown do not", {
  # not testing frequency or aggs
  q <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      q = "programming"
    )
  )
  ids <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      ids = "5lcgj7,5lcgj6"
    )
  )
  size <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      size = 10
    )
  )
  fields <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      fields = "created_utc,subreddit"
    )
  )
  sort <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      sort = "asc"
    )
  )
  sort_type <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      sort_type = "score"
    )
  )
  author <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      author = "hadley"
    )
  )
  subreddit <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      subreddit = "rstats"
    )
  )
  after <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      after = date_to_api("2016-12-31 23:59:58", tz = "UTC")
    )
  )
  not_a_param <- import_reddit_content_from_url(
    construct_pushshift_url(
      content_type = "submission",
      before = test_date,
      not_a_param = "test"
    )
  )

  expect_false(identical(q, ref_submission))
  expect_true(nrow(q) > 0)

  expect_false(identical(ids, ref_submission))
  expect_true(nrow(ids) == 2)

  expect_false(identical(size, ref_submission))
  expect_true(nrow(size) == 10)

  expect_false(identical(fields, ref_submission))
  expect_true(nrow(fields) > 0)
  expect_true(ncol(fields) == 2)

  expect_false(identical(sort, ref_submission))
  expect_true(nrow(sort) > 0)

  expect_false(identical(sort_type, ref_submission))
  expect_true(nrow(sort_type) > 0)

  expect_false(identical(author, ref_submission))
  expect_true(nrow(author) > 0)

  expect_false(identical(subreddit, ref_submission))
  expect_true(nrow(subreddit) > 0)

  expect_false(identical(after, ref_submission))
  expect_true(nrow(after) > 0)

  expect_identical(not_a_param, ref_submission)
})

test_that("timeout triggers", {
  expect_message(
    object = import_reddit_content_from_url(
      construct_pushshift_url(q = "the"),
      timeout = 1
    ),
    regexp = "Time limit for a single request was exceeded.",
    fixed = TRUE
  )
})
