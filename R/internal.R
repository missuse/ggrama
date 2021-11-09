#' Check if color is valid
#'
#' @param x A color as a string
#'
#' @return  A logical TRUE or FALSE depending it the color string is valid.
#' @import grDevices

areColors <- function(x) {
  sapply(x, function(X) {
    tryCatch(is.matrix(grDevices::col2rgb(X)),
             error = function(e) FALSE)
  })
}
