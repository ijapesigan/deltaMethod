## ---- test-deltaMethod-delta
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
    func <- function(x) {
      y <- exp(x = x)
      names(x = y) <- paste0("exp", "(", names(x = x), ")")
      y[-1]
    }
    out <- deltaMethod::Delta(
      coef = coef,
      vcov = vcov,
      func = func,
      alpha = 0.05
    )
    testthat::test_that(
      desc = paste(text, "errors"),
      code = {
        testthat::expect_error(
          object = deltaMethod::Delta(
            coef = coef,
            vcov = vcov,
            func = func,
            alpha = 0.05,
            z = FALSE
          ),
          regexp = "df"
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "est, vcov, jacobian"),
      code = {
        est <- exp(x = coef)[-1]
        names(x = est) <- c("exp(wt)", "exp(disp)")
        jcap <- diag(x = est, nrow = 2)
        testthat::expect_equal(
          object = out$est,
          expected = est,
          tolerance = tol
        )
        testthat::expect_equal(
          object = unname(obj = out$jacobian),
          expected = cbind(0, jcap),
          tolerance = tol
        )
        testthat::expect_equal(
          object = unname(obj = out$vcov),
          expected = unname(obj = jcap %*% vcov[-1, -1] %*% jcap),
          tolerance = tol
        )
        testthat::expect_equal(
          object = rownames(x = out$vcov),
          expected = names(x = est)
        )
        testthat::expect_identical(
          object = out$fun,
          expected = "Delta"
        )
        testthat::expect_s3_class(
          object = out,
          class = "deltamethod"
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "k = 1, t distribution, additional arguments"),
      code = {
        out1 <- deltaMethod::Delta(
          coef = c(a = 2),
          vcov = matrix(data = 0.25, nrow = 1, ncol = 1),
          func = function(x, p) {
            y <- x^p
            names(x = y) <- "a_p"
            y
          },
          p = 2,
          alpha = 0.05,
          z = FALSE,
          df = 30
        )
        testthat::expect_equal(
          object = unname(obj = out1$est),
          expected = 4,
          tolerance = tol
        )
        testthat::expect_equal(
          object = unname(obj = out1$vcov),
          expected = matrix(data = (2 * 2)^2 * 0.25, nrow = 1, ncol = 1),
          tolerance = tol
        )
        testthat::expect_identical(
          object = colnames(x = out1$vcov),
          expected = "a_p"
        )
        testthat::expect_identical(
          object = out1$args$df,
          expected = 30
        )
      }
    )
    testthat::test_that(
      desc = paste(text, "k = 2 linear function"),
      code = {
        vcov2 <- matrix(
          data = c(1, 0.5, 0.5, 2),
          nrow = 2
        )
        out2 <- deltaMethod::Delta(
          coef = c(a = 1, b = 2),
          vcov = vcov2,
          func = function(x) {
            c(ab = unname(obj = x[1] * x[2]))
          }
        )
        jcap <- matrix(data = c(2, 1), nrow = 1)
        testthat::expect_equal(
          object = unname(obj = out2$vcov),
          expected = jcap %*% vcov2 %*% t(x = jcap),
          tolerance = tol
        )
      }
    )
  },
  tol = 1e-04,
  text = "test-deltaMethod-delta"
)
