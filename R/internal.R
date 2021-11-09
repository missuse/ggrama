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

#'  1D linear matrix resize
#'
#' @param img input matrix
#' @param new_width output matrix width
#' @param new_height output matrix height
#'
#' @return  resized matrix of dimensions new_height * new_width
#' @import stats

resize_mat_linear <- function(img, new_width, new_height) {
  new_img <- apply(img, 2, function(y) stats::approx(y, n = new_height)$y)
  new_img <- t(apply(new_img, 1, function(y) stats::approx(y, n = new_width)$y))
  new_img[new_img < 0] <- 0
  return(new_img)
}
