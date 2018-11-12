context("test-eco-us.R")
data("partition1")
data("partition2")

vm = vmeasure_calc(partition1, partition2)
# mc = mapcurves_calc(partition1, partition2)

test_that("sabre works on raster", {
  expect_equal(c(vm[[3]], vm[[4]], vm[[5]]), c(0.36, 0.32, 0.42), tolerance = 0.01)
  # expect_equal(vm[[1]]$rih, c(0.86, 0.48, 0.48, 0.48), tolerance = 0.01)
  # expect_equal(vm[[2]]$rih, c(0.39, 0.59, 0.86), tolerance = 0.01)
})

# test_that("mapcurves works on raster", {
#   expect_equal(mc$gof, 0.61, tolerance = 0.01)
# })

