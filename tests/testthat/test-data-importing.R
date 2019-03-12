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
    construct_pushshift_url(before = test_date, author = "kn0thing")
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

  expect_is(ref_comment, "data.frame")

  expect_false(identical(q, ref_comment))
  expect_true(nrow(q) > 0)
  expect_true(all(grepl("programming", tolower(q$body))))

  expect_false(identical(ids, ref_comment))
  expect_true(nrow(ids) == 2)
  expect_true(all(ids$id %in% c("123", "456")))

  expect_false(identical(size, ref_comment))
  expect_true(nrow(size) == 10)

  expect_false(identical(fields, ref_comment))
  expect_true(nrow(fields) > 0)
  expect_identical(colnames(fields), c("created_utc", "subreddit"))

  expect_false(identical(sort, ref_comment))
  expect_true(nrow(sort) > 0)
  expect_identical(sort$created_utc, sort(sort$created_utc))

  expect_false(identical(author, ref_comment))
  expect_true(nrow(author) > 0)
  expect_true(all(author$author == "kn0thing"))

  expect_false(identical(subreddit, ref_comment))
  expect_true(nrow(subreddit) > 0)
  expect_true(all(subreddit$subreddit == "rstats"))

  expect_false(identical(after, ref_comment))
  expect_true(nrow(after) > 0)
  expect_identical(after, after %>% dplyr::arrange(dplyr::desc(created_utc)))

  expect_identical(not_a_param, ref_comment)
})


# establish reference submission datasets
test_date <- date_to_api("2017-01-01", tz = "UTC")
ref_submission <- import_reddit_content_from_url(
  construct_pushshift_url(content_type = "submission", before = test_date)
)
Sys.sleep(3)
ref_submission_wait <- import_reddit_content_from_url(
  construct_pushshift_url(before = test_date, content_type = "submission")
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
      author = "kn0thing"
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

  expect_is(ref_submission, "data.frame")

  expect_false(identical(q, ref_submission))
  expect_true(nrow(q) > 0)
  expect_true(all(grepl("programming", tolower(q$body))))

  expect_false(identical(ids, ref_submission))
  expect_true(nrow(ids) == 2)
  expect_true(all(ids$id %in% c("5lcgj7", "5lcgj6")))

  expect_false(identical(size, ref_submission))
  expect_true(nrow(size) == 10)

  expect_false(identical(fields, ref_submission))
  expect_true(nrow(fields) > 0)
  expect_identical(colnames(fields), c("created_utc", "subreddit"))

  expect_false(identical(sort, ref_submission))
  expect_true(nrow(sort) > 0)
  expect_identical(sort$created_utc, sort(sort$created_utc))

  expect_false(identical(sort_type, ref_submission))
  expect_true(nrow(sort_type) > 0)
  expect_identical(sort_type, sort_type %>% dplyr::arrange(dplyr::desc(score)))

  expect_false(identical(author, ref_submission))
  expect_true(nrow(author) > 0)
  expect_true(all(author$author == "kn0thing"))

  expect_false(identical(subreddit, ref_submission))
  expect_true(nrow(subreddit) > 0)
  expect_true(all(subreddit$subreddit == "rstats"))

  expect_false(identical(after, ref_submission))
  expect_true(nrow(after) > 0)
  expect_identical(after, after %>% dplyr::arrange(dplyr::desc(created_utc)))

  expect_identical(not_a_param, ref_submission)
})

test_that("multi phrase return expected results", {
  exact_phrase <- construct_pushshift_url(q = '"data science"') %>%
    import_reddit_content_from_url()
  and_condition <- construct_pushshift_url(q = "data+science") %>%
    import_reddit_content_from_url()
  or_condition <- construct_pushshift_url(q = "data|science") %>%
    import_reddit_content_from_url()
  not_condition1 <- construct_pushshift_url(q = "(data)-science") %>%
    import_reddit_content_from_url()
  not_condition2 <- construct_pushshift_url(q = "(data)-(science)") %>%
    import_reddit_content_from_url()

  expect_true(all(grepl("data science", tolower(exact_phrase$body))))
  expect_true(all(grepl("data", tolower(and_condition$body))))
  expect_true(all(grepl("science", tolower(and_condition$body))))
  expect_true(all(grepl("data|science", tolower(or_condition$body))))
  expect_true(all(grepl("data", tolower(not_condition1$body))))
  expect_true(!any(grepl("science", tolower(not_condition1$body))))
  expect_true(all(grepl("data", tolower(not_condition2$body))))
  expect_true(!any(grepl("science", tolower(not_condition2$body))))
})
