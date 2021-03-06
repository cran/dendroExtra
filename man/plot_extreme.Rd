% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_extreme.R
\name{plot_extreme}
\alias{plot_extreme}
\title{plot_extreme}
\usage{
plot_extreme(result_daily_response, title = TRUE)
}
\arguments{
\item{result_daily_response}{a list with three objects as produced by
daily_response function}

\item{title}{logical, if set to FALSE, no plot title is displayed}
}
\value{
A ggplot2 object containing the plot display
}
\description{
Graphs a line plot of a row with the highest measure in a matrix, produced by
\code{\link{daily_response}} function.
}
\examples{
\dontrun{
data(daily_temperatures_example)
data(example_proxies_1)
Example1 <- daily_response(response = example_proxies_1,
env_data = daily_temperatures_example, method = "lm", measure = "r.squared",
fixed_width = 90, previous_year = TRUE)
plot_extreme(Example1)

Example2 <- daily_response(response = example_proxies_1,
env_data = daily_temperatures_example, method = "brnn",
measure = "adj.r.squared", lower_limit = 50, upper_limit = 55, neurons = 1)
plot_extreme(Example2)

#' # Example with negative correlations
data(example_proxies_2)
daily_temperatures_example_subset = daily_temperatures_example[-c(53:55), ]
Example3 <- daily_response(response = example_proxies_2,
env_data = daily_temperatures_example_subset, method = "cor",
lower_limit = 35, upper_limit = 40)
plot_extreme(Example3)
}
}
