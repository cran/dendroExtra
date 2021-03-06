library(dendroExtra)
library(testthat)
library(dplyr)

data(daily_temperatures_example)
data(example_proxies_1)
MVA_parameter <- select(example_proxies_1, MVA)
oxygen_isotope <- select(example_proxies_1, O)
carbon_isotope <- select(example_proxies_1, C)


# If test is repeated, equal result should be obtained
test1 <- daily_response(response = carbon_isotope,
                        env_data = daily_temperatures_example, method = "lm",
                        lower = 240, upper = 250)

test2 <- daily_response(response = carbon_isotope,
                        env_data = daily_temperatures_example, method = "lm",
                        lower = 240, upper = 250)

expect_equal(test1, test2)


# daily_response function should return a list with matrix and two characters
test3 <- daily_response(response = example_proxies_1,
  env_data = daily_temperatures_example, method = "brnn",
  measure = "adj.r.squared", lower = 250, upper = 253, previous_year = TRUE)
expect_is(test3, "list")
expect_is(test3[[1]], "matrix")
expect_is(test3[[2]], "character")
expect_is(test3[[2]], "character")


# stop functions were included to prevent wrong results
expect_error(daily_response(response = carbon_isotope,
                            env_data = daily_temperatures_example,
                            lower = 200, upper = 270, fixed_width = -368))

expect_error(daily_response(response = example_proxies_1,
  env_data = daily_temperatures_example, method = "cor", lower = 250,
  upper = 270, previous_year = FALSE))

expect_error(daily_response(response = example_proxies_1,
  env_data = daily_temperatures_example, method = "cor", lower = 280,
  upper = 270, previous_year = FALSE))


# r.squared is squared correlation. Results should be equal
test4 <- daily_response(response = MVA_parameter,
                        env_data = daily_temperatures_example, method = "cor",
                        lower = 150, upper = 170, previous_year = FALSE)

test5 <- daily_response(response = MVA_parameter,
                        env_data = daily_temperatures_example, method = "lm",
                        lower = 150, upper = 170, previous_year = FALSE)
expect_equal(max(test4[[1]], na.rm = TRUE) ^ 2, max(test5[[1]], na.rm = TRUE))


# Check for smooth_matrix
test6 <- matrix(seq(1.01, 2, by = 0.01), ncol = 10, byrow = TRUE)
test7 <- test6
test7[5, 5] <- -1
test7 <- smooth_matrix(test7, factor_drop = 0.7)
expect_equal(test6, test7)

# A test for critical R
# when the same data is used and alpha is reduced, there should be a higher
# threshold for statistical significance
t1 <- critical_r(100, alpha = 0.05)
t2 <- critical_r(100, alpha = 0.01)
expect_equal(t2 > t1, TRUE)

# when the same alpha is used and number of observations is reduced, higher
# threshold for statistical significance is expected
t1 <- critical_r(100, alpha = 0.05)
t2 <- critical_r(80, alpha = 0.05)
expect_equal(t2 > t1, TRUE)

# If row.names of env_data and response do not match, warning should be given
example_proxies_1_temporal <- example_proxies_1
row.names(example_proxies_1_temporal)[1] <- "1520" # random year is assigned
# to row.name of the firest row
expect_warning(daily_response(response = example_proxies_1_temporal,
                            env_data = daily_temperatures_example,
                            method = "lm", lower = 260, upper = 270,
                            previous_year = FALSE))


# The order of data is unimportant, if row_names_subset is set to TRUE and
# row.names are years. In this case, data is merged based on matching
# row .ames.
# will be ordered data
data(example_proxies_1)
carbon_isotope <- dplyr::select(example_proxies_1, C)
# Test 8: Usual way of analysing data
test8 <- daily_response(response = carbon_isotope,
                           env_data = daily_temperatures_example, method = "lm",
                        measure = "r.squared", lower_limit = 30,
                        upper_limit = 40)
# Test 9: carbon_isotope data.frame is ordered by values of C
carbon_isotope_ordered <- carbon_isotope[order(carbon_isotope$C), ,
                                         drop = FALSE]
test9 <- daily_response(response = carbon_isotope_ordered,
                           env_data = daily_temperatures_example, method = "lm",
                        measure = "r.squared", lower_limit = 30,
                        upper_limit = 40, row_names_subset = TRUE)
expect_equal(test8[[1]], test9[[1]])


# There should be 4 elements in a list returned by daily_response()
expect_equal(length(test8), 4)
