% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{background_dist_smooth}
\alias{background_dist_smooth}
\title{Smoothed background data for Ramachandran diagram}
\format{
An object of class \code{list} of length 4.
}
\usage{
background_dist_smooth
}
\description{
A list with four elements "general", "glycine", "pre.pro" and "proline".
Each element is a matrix containing the background data used by
\code{\link{ggplot2}{geom_raster}} or \code{\link{ggplot2}{geom_contour_filled}} to show favorable regions of torsion angles.
The data set was created by running \code{\link{oce}{matrixSmooth}} with  "passes = 1" on \code{\link{background_dist}}
}
\keyword{datasets}
