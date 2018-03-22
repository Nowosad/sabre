context("test-eco-us.R")
data("regions1")
data("regions2")

vm = sabre_calc(regions1, z, regions2, z)
mc = mapcurves_calc(regions1, z, regions2, z)

test_that("sabre works on vector", {
  expect_equal(unlist(vm), c(vmeasure = 0.737, homogeneity = 0.9, completeness = 0.624), tolerance = 3)
})

test_that("mapcurves works on vector", {
  expect_equal(mc$gof, 1, tolerance = 3)
})

