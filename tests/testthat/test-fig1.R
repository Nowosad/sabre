context("test-eco-us.R")
data("regions1")
data("regions2")

vm = sabre_calc(regions1, z, regions2, z)[[3]]
mc = mapcurves_calc(regions1, z, regions2, z)[[3]]

test_that("sabre works on vector", {
  expect_equal(unlist(vm), c(vmeasure = 0.36, homogeneity = 0.32, completeness = 0.42), tolerance = 0.01)
})

test_that("mapcurves works on vector", {
  expect_equal(mc$gof, 0.61, tolerance = 0.01)
})

