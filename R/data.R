#' Background data for Ramachandran diagram
#'
#' A list with four elements "general", "glycine", "pre.pro" and "proline".
#' Each element is a matrix containing the background data used by
#' \code{\link{ggplot2}{geom_raster}} or \code{\link{ggplot2}{geom_contour_filled}} to show favorable regions of torsion angles.
#'
#' @source \url{https://github.com/S-John-S/Ramachandran-Plot} \url{https://warwick.ac.uk/fac/sci/moac/people/students/peter_cock/r/ramachandran/}
#' @references Lovell, S.C., Davis, I.W., Arendall, W.B., III, de Bakker, P.I.W., Word, J.M., Prisant, M.G., Richardson, J.S. and Richardson, D.C. (2003), Structure validation by C\eqn{\alpha} geometry: \eqn{\phi},\eqn{\psi} and C\eqn{\beta} deviation. Proteins, 50: 437-450. https://doi.org/10.1002/prot.10286
"background_dist"


#' Smoothed background data for Ramachandran diagram
#'
#' A list with four elements "general", "glycine", "pre.pro" and "proline".
#' Each element is a matrix containing the background data used by
#'  \code{\link{ggplot2}{geom_raster}} or \code{\link{ggplot2}{geom_contour_filled}} to show favorable regions of torsion angles.
#' The data set was created by running \code{\link{oce}{matrixSmooth}} with  "passes = 1" on \code{\link{background_dist}}
#'
#'
"background_dist_smooth"
