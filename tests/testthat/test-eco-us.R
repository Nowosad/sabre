context("test-eco-us.R")
data("eco_us")
vm  = vmeasure_calc(eco_us, PROVINCE, eco_us, SECTION)
vm2 = vmeasure_calc(eco_us, DOMAIN, eco_us, DIVISION)
# vm2 = vmeasure_calc(eco_us, DOMAIN, eco_us, PROVINCE)
# vm3 = vmeasure_calc(eco_us, DOMAIN, eco_us, SECTION)
# vm4 = vmeasure_calc(eco_us, DIVISION, eco_us, PROVINCE)
# vm5 = vmeasure_calc(eco_us, DIVISION, eco_us, SECTION)
# vm6 = vmeasure_calc(eco_us, PROVINCE, eco_us, SECTION)
mc = mapcurves_calc(eco_us, PROVINCE, eco_us, SECTION)

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
