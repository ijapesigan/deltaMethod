## ---- test-deltaMethod-acov-delta-dot
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    testthat::skip_on_cran()
    message(text)
    testthat::test_that(
      desc = paste(text, "known values"),
      code = {
        jcap <- matrix(
          data = c(1, 2, 3, 4),
          nrow = 2
        )
        acov <- matrix(
          data = c(2, 1, 1, 3),
          nrow = 2
        )
        testthat::expect_equal(
          object = deltaMethod:::.ACovDelta(
            jcap = jcap,
            acov = acov
          ),
          expected = jcap %*% acov %*% t(x = jcap)
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "k = 1"),
      code = {
        testthat::expect_equal(
          object = deltaMethod:::.ACovDelta(
            jcap = matrix(data = 3),
            acov = matrix(data = 2)
          ),
          expected = matrix(data = 18)
        )
      }
    )
  },
  text = "test-deltaMethod-acov-delta-dot"
)
