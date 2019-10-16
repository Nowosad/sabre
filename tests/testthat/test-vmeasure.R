context("test-vmeasure.R")

# Examples from Figure 2 of
# Rosenberg, Andrew, and Julia Hirschberg. "V-measure:
# A conditional entropy-based external cluster evaluation measure." Proceedings
# of the 2007 joint conference on empirical methods in natural language
# processing and computational natural language learning (EMNLP-CoNLL). 2007.

solution_a = list(x = c(1, 1, 1, 2, 3, 3, 3, 3, 1, 2, 2, 2, 2, 1, 3),
                  y = c(rep(1, 5), rep(2, 5), rep(3, 5)))

solution_b = list(x = c(1, 1, 1, 2, 2, 3, 3, 3, 1, 1, 2, 2, 2, 3, 3),
                  y = c(rep(1, 5), rep(2, 5), rep(3, 5)))

solution_c = list(x = c(1, 1, 1, 2, 2, 3, 3, 3, 1, 1, 2, 2, 2, 3, 3, 1, 2, 3, 1, 2, 3),
                  y = c(rep(1, 5), rep(2, 5), rep(3, 5), rep(4, 2), rep(5, 2), rep(6, 2)))

solution_d = list(x = c(1, 1, 1, 2, 2, 3, 3, 3, 1, 1, 2, 2, 2, 3, 3, 1, 2, 3, 1, 2, 3),
                  y = c(rep(1, 5), rep(2, 5), rep(3, 5), 4, 5, 6, 7, 8, 9))

test_that("multiplication works", {
  expect_equal(vmeasure(solution_a$x, solution_a$y)$v_measure, 0.14, tolerance = 0.01)
  expect_equal(vmeasure(solution_b$x, solution_b$y)$v_measure, 0.39, tolerance = 0.01)
  expect_equal(vmeasure(solution_c$x, solution_c$y)$v_measure, 0.30, tolerance = 0.01)
  expect_equal(vmeasure(solution_d$x, solution_d$y)$v_measure, 0.41, tolerance = 0.01)
})
