## ---- test-benchmark-deltaMethod-delta
# Run by hand: bench is not part of the unit tests.
stopifnot(requireNamespace(package = "bench", quietly = TRUE))
lapply(
  X = c(3, 10, 20),
  FUN = function(k) {
    coef <- seq_len(length.out = k) / k
    vcov <- diag(x = 0.1, nrow = k)
    func <- function(x) {
      exp(x = x)
    }
    print(
      x = bench::mark(
        delta = deltaMethod::Delta(
          coef = coef,
          vcov = vcov,
          func = func,
          alpha = 0.05
        ),
        iterations = 10,
        check = FALSE
      )
    )
  }
)
