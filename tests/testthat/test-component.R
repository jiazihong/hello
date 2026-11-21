testthat::test_that("RemoveSeasonal returns group means and anomalies", {
  result <- RemoveSeasonal(
    y = c(10, 14, 20, 24),
    t_mmdd = c(101, 101, 102, 102)
  )

  testthat::expect_equal(result$mu, c(12, 22))
  testthat::expect_equal(result$anomaly, c(-2, 2, -2, 2))
})

testthat::test_that("LS_OneBreak fits a single known break", {
  y <- c(2, 4, 6, 18, 20, 22)
  fit <- LS_OneBreak(Y = y, X = 1:6, Ic = 3)

  testthat::expect_equal(fit$fitted, y)
  testthat::expect_lt(fit$SSE, 1e-10)
})

testthat::test_that("LS_MultiBreaks fits three segments", {
  y <- c(2, 4, 6, 18, 20, 22, 18, 20, 22)
  fit <- LS_MultiBreaks(Y = y, X = 1:9, Ips = c(3, 6, 9))

  testthat::expect_equal(fit$fitted, y)
  testthat::expect_lt(fit$SSE, 1e-10)
})

testthat::test_that("lm_solve returns coefficients and residual sum of squares", {
  design <- cbind(1, 1:4)
  y <- c(4, 4, 6, 10)
  fit <- lm_solve(design, y)

  testthat::expect_equal(as.numeric(fit$coef), c(1, 2))
  testthat::expect_equal(fit$SSE, 4)
  testthat::expect_equal(lm_solve(design, y, only.SSE = TRUE), list(SSE = 4))
})
