# deltaMethod: Delta Method Standard Errors and Confidence Intervals

## Description

Delta method sampling variance-covariance matrices, standard errors,
test statistics, and confidence intervals for functions of parameters in
R (R Core Team, 2026) using a numerical Jacobian.

## Installation

You can install the development version of `deltaMethod` from
[GitHub](https://github.com/ijapesigan/deltaMethod) with:

\
`if`` ``(``!`[`require`](https://rdrr.io/r/base/library.html)`(`[`"pak"`](https://pak.r-lib.org/)`)``)`` `[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(``"pak"``)`\
`pak``::`[`pkg_install`](https://pak.r-lib.org/reference/pkg_install.html)`(``"ijapesigan/deltaMethod"``)`

## Example

\
[`library`](https://rdrr.io/r/base/library.html)`(``package ``=`` ``"deltaMethod"``)`

A logistic regression of `vs` on `wt` and `disp`.

\
`object`` ``<-`` ``stats``::`[`glm`](https://rdrr.io/r/stats/glm.html)`(`\
`  formula ``=`` ``vs`` ``~`` ``wt`` ``+`` ``disp``,`\
`  family ``=`` ``"binomial"``,`\
`  data ``=`` ``mtcars`\
`)`

[`Delta()`](https://ijapesigan.github.io/deltaMethod/reference/Delta.md)
takes the estimates, their sampling variance-covariance matrix, and an R
function of the estimates. Here, the odds ratios of `wt` and `disp`.

\
`func`` ``<-`` ``function``(``x``)`` ``{`\
`  ``y`` ``<-`` `[`exp`](https://rdrr.io/r/base/Log.html)`(``x ``=`` ``x``)`\
`  `[`names`](https://rdrr.io/r/base/names.html)`(``x ``=`` ``y``)`` ``<-`` `[`paste0`](https://rdrr.io/r/base/paste.html)`(``"exp"``, ``"("``, `[`names`](https://rdrr.io/r/base/names.html)`(``x ``=`` ``x``)``, ``")"``)`\
`  ``y``[``-``1``]`\
`}`\
`out`` ``<-`` `[`Delta`](https://ijapesigan.github.io/deltaMethod/reference/Delta.md)`(`\
`  coef ``=`` ``stats``::`[`coef`](https://rdrr.io/r/stats/coef.html)`(``object ``=`` ``object``)``,`\
`  vcov ``=`` ``stats``::`[`vcov`](https://rdrr.io/r/stats/vcov.html)`(``object ``=`` ``object``)``,`\
`  func ``=`` ``func``,`\
`  alpha ``=`` ``0.05`\
`)`\
`out`\
`#> Call:`\
`#> Delta(coef = stats::coef(object = object), vcov = stats::vcov(object = object), `\
`#>     func = func, alpha = 0.05)`\
`#>              est     se       z      p    2.5%   97.5%`\
`#> exp(wt)   5.0853 7.5805  0.6708 0.5023 -9.7723 19.9429`\
`#> exp(disp) 0.9662 0.0148 65.0838 0.0000  0.9371  0.9952`

[`DeltaGeneric()`](https://ijapesigan.github.io/deltaMethod/reference/DeltaGeneric.md)
takes the fitted model and character strings that define functions of
its coefficients.

\
`out`` ``<-`` `[`DeltaGeneric`](https://ijapesigan.github.io/deltaMethod/reference/DeltaGeneric.md)`(`\
`  object ``=`` ``object``,`\
`  def ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``"exp(wt)"``, ``"exp(disp)"``)``,`\
`  alpha ``=`` ``0.05`\
`)`\
[`summary`](https://rdrr.io/r/base/summary.html)`(``object ``=`` ``out``)`\
`#>              est     se       z      p    2.5%   97.5%`\
`#> exp(wt)   5.0853 7.5805  0.6708 0.5023 -9.7723 19.9429`\
`#> exp(disp) 0.9662 0.0148 65.0838 0.0000  0.9371  0.9952`\
`stats``::`[`confint`](https://rdrr.io/r/stats/confint.html)`(``object ``=`` ``out``, level ``=`` ``0.95``)`\
`#>                2.5 %     97.5 %`\
`#> exp(wt)   -9.7722691 19.9428612`\
`#> exp(disp)  0.9370572  0.9952475`\
`stats``::`[`vcov`](https://rdrr.io/r/stats/vcov.html)`(``object ``=`` ``out``)`\
`#>               exp(wt)     exp(disp)`\
`#> exp(wt)   57.46443026 -0.0977480169`\
`#> exp(disp) -0.09774802  0.0002203662`

## Documentation

See [GitHub Pages](https://ijapesigan.github.io/deltaMethod) for package
documentation.

## References

R Core Team. (2026). *R: A language and environment for statistical
computing*. R Foundation for Statistical Computing.
<https://www.R-project.org/>
