context("test-eco-us.R")
data("regions1")
data("regions2")

vm = sabre_calc(regions1, z, regions2, z)
mc = mapcurves_calc(regions1, z, regions2, z)

test_that("sabre works on vector", {
  expect_equal(unlist(vm[[3]]), c(vmeasure = 0.36, homogeneity = 0.32, completeness = 0.42), tolerance = 0.01)
  expect_equal(vm[[1]]$sabre, c(0.86, 0.48, 0.48, 0.48), tolerance = 0.01)
  expect_equal(vm[[2]]$sabre, c(0.39, 0.59, 0.86), tolerance = 0.01)
})

test_that("mapcurves works on vector", {
  expect_equal(mc[[3]]$gof, 0.61, tolerance = 0.01)
})

