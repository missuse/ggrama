#' Ramachandran diagrams
#'
#' Plots four types of Ramachandran diagrams in a grid from a pdb file using ggplot2 graphics
#'
#' @param pdb input pdb file location.
#' @param ... arguments passed to  \code{\link{ggrama}{ggrama}}
#'
#' @return a grid of four ggplot2 figures combined using  \code{\link{cowplot::plot_grid}}
#'
#' @examples
#'
#' #download a PDB file
#' download.file("https://files.rcsb.org/download/2ADQ.pdb1.gz",
#'               dest = "2ADQ.pdb1.gz")
#'
#' #plot
#' ggrama_all("2ADQ.pdb1.gz")
#'
#' @export ggrama_all

ggrama_all <- function(pdb, ...){
  type <- c("general", "glycine", "pre.pro", "proline")
  lapply(type,
         ggrama, pdb = pdb, ...) -> gl
  cowplot::plot_grid(plotlist =  gl, ncol = 2)
}
