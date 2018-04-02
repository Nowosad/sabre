context("test-eco-us.R")
data("regions1")
data("regions2")

vm = sabre_calc(regions1, z, regions2, z)
mc = mapcurves_calc(regions1, z, regions2, z)

test_that("sabre works on vector", {
  expect_equal(c(vm[[3]], vm[[4]], vm[[5]]), c(0.36, 0.32, 0.42), tolerance = 0.01)
  expect_equal(vm[[1]][[1]]$rih, c(0.86, 0.48, 0.48, 0.48), tolerance = 0.01)
  expect_equal(vm[[2]][[1]]$rih, c(0.39, 0.59, 0.86), tolerance = 0.01)
})

test_that("mapcurves works on vector", {
  expect_equal(mc[[3]]$gof, 0.61, tolerance = 0.01)
})

