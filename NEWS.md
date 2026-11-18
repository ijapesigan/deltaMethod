# deltaMethod 0.0.1

## Template

- The rProject template; private `jeksterslab-psu/deltaMethod`, public `ijapesigan/deltaMethod`.
- `DESCRIPTION`: MIT, `Depends: R (>= 3.5.0)`, `Imports: numDeriv, stats`, `VignetteBuilder: knitr`.
- `.CIWald()` and `.ProbsofAlpha()` are locked copies from the wald clone in `.setup/r-dependencies/wald/`.
- `R/deltaMethod-acov-delta.R` renamed `R/deltaMethod-acov-delta-dot.R` (internal function).
- Complete roxygen for every function; the documented element `coef` of the returned list is `est`.
- Tests for every function and method; the unused draft `.setup/notes/deltaMethod-delta-generic-dot.R`
  (an older `DeltaGeneric(func, coef, vcov)`) stays in `.setup/notes/` and is not part of the package.
