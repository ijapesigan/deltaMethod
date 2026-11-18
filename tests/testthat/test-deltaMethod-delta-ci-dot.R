## ---- test-deltaMethod-delta-ci-dot
lapply(
  X = 1,
  FUN = function(i,
                 tol,
                 text) {
    testthat::skip_on_cran()
    message(text)
    object <- stats::glm(
      formula = vs ~ wt + disp,
      family = "binomial",
      data = mtcars
    )
    out <- deltaMethod::DeltaGeneric(
      object = object,
      def = list("exp(wt)", "exp(disp)"),
      alpha = 0.05
    )
    testthat::test_that(
      desc = paste(text, "default alpha and given alpha"),
      code = {
        ci <- deltaMethod:::.DeltaCI(
          object = out,
          alpha = NULL
        )
        testthat::expect_identical(
          object = colnames(x = ci),
          expected = c("est", "se", "z", "p", "2.5%", "97.5%")
        )
        testthat::expect_equal(
          object = ci[, "se"],
          expected = sqrt(x = diag(x = out$vcov)),
          tolerance = tol
        )
        ci_01 <- deltaMethod:::.DeltaCI(
          object = out,
          alpha = 0.01
        )
        testthat::expect_identical(
          object = colnames(x = ci_01)[5:6],
          expected = c("0.5%", "99.5%")
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "errors"),
      code = {
        testthat::expect_error(
          object = deltaMethod:::.DeltaCI(
            object = out,
            alpha = 1.5
          )
        )
        testthat::expect_error(
          object = deltaMethod:::.DeltaCI(
            object = out,
            alpha = 0
          )
        )
      }
    )
  },
  tol = 1e-04,
  text = "test-deltaMethod-delta-ci-dot"
)
