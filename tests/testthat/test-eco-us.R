context("test-eco-us.R")
data("eco_us")
vm  = vmeasure_calc(eco_us, eco_us, PROVINCE, SECTION)
vm2 = vmeasure_calc(eco_us, eco_us, DOMAIN, DIVISION)
vm3 = vmeasure_calc(eco_us, eco_us, DOMAIN, SECTION)
vm4 = vmeasure_calc(eco_us, eco_us, DIVISION, PROVINCE)
vm5 = vmeasure_calc(eco_us, eco_us, DIVISION, SECTION)
vm6 = vmeasure_calc(eco_us, eco_us, PROVINCE, SECTION)
mc = mapcurves_calc(eco_us, eco_us, PROVINCE, SECTION)

test_that("sabre works on vector", {
  expect_equal(c(vm[[3]], vm[[4]], vm[[5]]), c(0.797, 1, 0.662), tolerance = 0.001)
  expect_true(vm[[3]] > vm2[[3]])
})

test_that("mapcurves works on vector", {
  expect_equal(mc$gof, 1, tolerance = 0.001)
})

test_that("mapcurves is homogeneity", {
  expect_equal(mc$gof, vm[[4]], tolerance = 0.001)
})
