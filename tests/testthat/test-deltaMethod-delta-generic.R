## ---- test-deltaMethod-delta-generic
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
    coef <- stats::coef(object = object)
    vcov <- stats::vcov(object = object)
    def <- list(
      "exp(wt)",
      "exp(disp)"
    )
    out <- deltaMethod::DeltaGeneric(
      object = object,
      def = def,
      alpha = 0.05
    )
    testthat::test_that(
      desc = paste(text, "errors"),
      code = {
        testthat::expect_error(
          object = deltaMethod::DeltaGeneric(
            object = object,
            def = def,
            alpha = 0.05,
            z = FALSE
          ),
          regexp = "df"
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "est and se"),
      code = {
        est <- exp(x = coef)[-1]
        se <- c(
          sqrt(x = est[1]^2 * vcov[2, 2]),
          sqrt(x = est[2]^2 * vcov[3, 3])
        )
        testthat::expect_equal(
          object = unname(obj = out$est),
          expected = unname(obj = est),
          tolerance = tol
        )
        testthat::expect_equal(
          object = unname(obj = sqrt(x = diag(x = out$vcov))),
          expected = unname(obj = se),
          tolerance = tol
        )
        testthat::expect_identical(
          object = names(x = out$est),
          expected = c("exp(wt)", "exp(disp)")
        )
        testthat::expect_identical(
          object = colnames(x = out$vcov),
          expected = c("exp(wt)", "exp(disp)")
        )
        testthat::expect_identical(
          object = out$fun,
          expected = "DeltaGeneric"
        )
        testthat::expect_s3_class(
          object = out,
          class = "deltamethod"
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "k = 1 and a function of two coefficients"),
      code = {
        out1 <- deltaMethod::DeltaGeneric(
          object = object,
          def = list("exp(wt)"),
          alpha = 0.05,
          z = FALSE,
          df = 29
        )
        testthat::expect_equal(
          object = unname(obj = out1$est),
          expected = unname(obj = exp(x = coef["wt"])),
          tolerance = tol
        )
        testthat::expect_equal(
          object = unname(obj = out1$vcov),
          expected = matrix(
            data = exp(x = coef["wt"])^2 * vcov["wt", "wt"],
            nrow = 1,
            ncol = 1
          ),
          tolerance = tol
        )
        out2 <- deltaMethod::DeltaGeneric(
          object = object,
          def = list("wt * disp"),
          alpha = 0.05
        )
        jcap <- matrix(
          data = c(coef["disp"], coef["wt"]),
          nrow = 1
        )
        testthat::expect_equal(
          object = unname(obj = out2$vcov),
          expected = unname(
            obj =
              jcap %*% vcov[c("wt", "disp"), c("wt", "disp")] %*% t(x = jcap)
          ),
          tolerance = tol
        )
      }
    )
  },
  tol = 1e-04,
  text = "test-deltaMethod-delta-generic"
)
