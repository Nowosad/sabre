context("test-eco-us.R")
data("regions1")
data("regions2")

vm = vmeasure_calc(x = regions1, y = regions2, x_name = z, y_name = z)
mc = mapcurves_calc(x = regions1, y = regions2, x_name = z, y_name = z)

test_that("sabre works on vector", {
  expect_equal(c(vm[[3]], vm[[4]], vm[[5]]), c(0.36, 0.32, 0.42), tolerance = 0.01)
  expect_equal(vm[[1]]$rih, c(0.86, 0.48, 0.48, 0.48), tolerance = 0.01)
  expect_equal(vm[[2]]$rih, c(0.39, 0.59, 0.86), tolerance = 0.01)
})

test_that("mapcurves works on vector", {
  expect_equal(mc$gof, 0.61, tolerance = 0.01)
})

