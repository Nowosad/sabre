context("test-eco-us.R")
data("eco_us")
vm = sabre_calc(eco_us, PROVINCE, eco_us, SECTION)[[3]]
mc = mapcurves_calc(eco_us, PROVINCE, eco_us, SECTION)[[3]]

test_that("sabre works on vector", {
  expect_equal(unlist(vm), c(vmeasure = 0.797, homogeneity = 1, completeness = 0.662), tolerance = 0.001)
})

test_that("mapcurves works on vector", {
  expect_equal(mc$gof, 1, tolerance = 0.001)
})



# vm1 = sabre_calc(eco_us, DOMAIN, eco_us, DIVISION)[[3]]
# vm2 = sabre_calc(eco_us, DOMAIN, eco_us, PROVINCE)[[3]]
# vm3 = sabre_calc(eco_us, DOMAIN, eco_us, SECTION)[[3]]
# vm4 = sabre_calc(eco_us, DIVISION, eco_us, PROVINCE)[[3]]
# vm5 = sabre_calc(eco_us, DIVISION, eco_us, SECTION)[[3]]
# vm6 = sabre_calc(eco_us, PROVINCE, eco_us, SECTION)[[3]]
