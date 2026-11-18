## ---- test-deltaMethod-methods
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
    def <- list("exp(wt)", "exp(disp)")
    out <- deltaMethod::DeltaGeneric(
      object = object,
      def = def,
      alpha = c(0.05, 0.01)
    )
    out_t <- deltaMethod::DeltaGeneric(
      object = object,
      def = def,
      alpha = 0.05,
      z = FALSE,
      df = 29
    )
    testthat::test_that(
      desc = paste(text, "coef and vcov"),
      code = {
        testthat::expect_identical(
          object = stats::coef(object = out),
          expected = out$est
        )
        testthat::expect_identical(
          object = stats::vcov(object = out),
          expected = out$vcov
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "summary"),
      code = {
        ci <- summary(object = out)
        testthat::expect_identical(
          object = colnames(x = ci),
          expected = c(
            "est", "se", "z", "p",
            "0.5%", "2.5%", "97.5%", "99.5%"
          )
        )
        testthat::expect_equal(
          object = ci[, "est"],
          expected = round(x = out$est, digits = 4)
        )
        testthat::expect_equal(
          object = ci[, "z"],
          expected = round(
            x = out$est / sqrt(x = diag(x = out$vcov)),
            digits = 4
          )
        )
        ci_alpha <- summary(object = out, alpha = 0.05, digits = NULL)
        testthat::expect_identical(
          object = colnames(x = ci_alpha),
          expected = c("est", "se", "z", "p", "2.5%", "97.5%")
        )
        ci_t <- summary(object = out_t)
        testthat::expect_identical(
          object = colnames(x = ci_t),
          expected = c("est", "se", "t", "df", "p", "2.5%", "97.5%")
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "print"),
      code = {
        testthat::expect_output(
          object = print(x = out),
          regexp = "Call:"
        )
        testthat::expect_output(
          object = print(x = out_t, alpha = 0.01, digits = 2),
          regexp = "0.5%"
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "confint"),
      code = {
        ci <- stats::confint(object = out, level = 0.95)
        testthat::expect_identical(
          object = colnames(x = ci),
          expected = c("2.5 %", "97.5 %")
        )
        testthat::expect_identical(
          object = nrow(x = ci),
          expected = 2L
        )
        se <- sqrt(x = diag(x = out$vcov))
        testthat::expect_equal(
          object = unname(obj = ci[, 1]),
          expected = unname(obj = out$est - stats::qnorm(p = 0.975) * se),
          tolerance = tol
        )
        ci_t <- stats::confint(object = out_t, parm = 1, level = 0.95)
        half_t <- stats::qt(p = 0.975, df = 29) * sqrt(x = out_t$vcov[1, 1])
        testthat::expect_identical(
          object = dim(x = ci_t),
          expected = c(1L, 2L)
        )
        testthat::expect_equal(
          object = unname(obj = ci_t[1, 2]),
          expected = unname(
            obj = out_t$est[1] + half_t
          ),
          tolerance = tol
        )
      }
    )
  },
  tol = 1e-04,
  text = "test-deltaMethod-methods"
)
