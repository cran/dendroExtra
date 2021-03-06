% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/years_to_rownames.R
\name{years_to_rownames}
\alias{years_to_rownames}
\title{years_to_rownames}
\usage{
years_to_rownames(data, column_year)
}
\arguments{
\item{data}{a data frame to be manipulated}

\item{column_year}{string specifying a column with years}
}
\value{
a data frame with years as row names
}
\description{
Function returns a data frame with row names as years
}
\examples{
\dontrun{
new_df = years_to_rownames(data = daily_sequences, column_year = "years")
}
}
