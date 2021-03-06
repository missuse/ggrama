#' Ramachandran diagram
#'
#' Plots a Ramachandran diagram from a pdb file using ggplot2 graphics
#'
#' @param pdb input pdb file location.
#' @param type One of c("general", "glycine", "pre.pro", "proline"). String representing the type of Ramachandran diagram.
#' @param values Numeric vector indicating the values of \code{\link{ggplot2}{scale_fill_gradientn}}.
#' @param colors A character vector of valid color names indicating the colors for \code{\link{ggplot2}{scale_fill_gradientn}}.
#' @param title A string indicating the title of the plot.
#' @param shape Shape for \code{\link{ggplot2}{geom_point}}.
#' @param size Size for \code{\link{ggplot2}{geom_point}}.
#' @param fill fill for \code{\link{ggplot2}{geom_point}} if supported.
#' @param contour logical, should  \code{\link{ggplot2}{geom_contour_filled}} be used instead of \code{\link{ggplot2}{geom_tile}}
#' @param contour.color  numeric, the color of the contour if contour = TRUE.
#' @param smooth logical, should the background grid be smoothed.
#' @param ... currently not used
#'
#' @return A ggplot2 plot object
#'
#' @examples
#'
#' #download a PDB file
#' download.file("https://files.rcsb.org/download/2ADQ.pdb1.gz",
#'               dest = "2ADQ.pdb1.gz")
#'
#' # plot the general Ramachandran diagram
#' ggrama("2ADQ.pdb1.gz")
#'
#' # plot the proline Ramachandran diagram
#' ggrama("2ADQ.pdb1.gz", type = "proline")
#'
#' @import ggplot2
#' @export ggrama


ggrama <- function(pdb,
                   type = c("general", "glycine", "pre.pro", "proline"),
                   values = switch(type,
                                   general = c(0, 0.001, 0.02, 0.1, 1),
                                   glycine = c(0, 0.002, 0.02, 0.1, 1),
                                   proline = c(0, 0.002, 0.02, 0.1, 1),
                                   pre.pro = c(0, 0.002, 0.02, 0.1, 1)),
                   colors = switch(type,
                                   general = c('#FFFFFF','#B3E8FF','#82daff', '#19bbff'),
                                   glycine = c('#FFFFFF','#FFE8C5','#ffddab', '#FFCC7F'),
                                   proline = c('#FFFFFF','#D0FFC5','#a2fa8e', '#49de26'),
                                   pre.pro = c('#FFFFFF','#B3E8FF','#82daff', '#19bbff')),
                   title =  switch(type,
                                   general = "General",
                                   glycine = "Glycine (Symmetric)",
                                   proline = "Proline",
                                   pre.pro = "Pre-Proline"),
                   shape = 21,
                   size = 2,
                   fill = '#FFFFFF',
                   contour = FALSE,
                   contour.color = NA,
                   smooth = FALSE,
                   ...){
  type <- match.arg(type)

  if(length(values) != (length(colors)+1)){
    stop("length of values should be the same length(colors) + 1")
  }
  if(!is.numeric(values)){
    stop("values should be a numeric vector")
  }
  if(min(values) < 0){
    stop("values should be betwean 0 and 1")
  }
  if(max(values) > 1){
    stop("values should be betwean 0 and 1")
  }
  if(is.unsorted(values)){
    stop("values vector should be sorted")
  }

  if (!all(areColors(colors))){
    stop("colors should be valid color names")
  }

  if(length(contour) > 1){
    stop("contour should be length 1")
  }

  if(!is.logical(contour)){
    stop("contour should be TRUE or FALSE")
  }

  if(length(contour.color) > 1){
    stop("contour.color should be length 1")
  }

  if (!areColors(contour.color)){
    stop("contour.color should be valid color names")
  }

  if(length(smooth) > 1){
    stop("smooth should be length 1")
  }

  if(!is.logical(smooth)){
    stop("smooth should be TRUE or FALSE")
  }

  # torsion angle manipulation
  pdb <- bio3d::read.pdb(pdb)
  tor <- bio3d::torsion.pdb(pdb)
  tor <- as.data.frame(tor$tbl)
  tor <- data.frame(tor,
                    aa = rownames(tor))
  tor <- tor[,c("aa", "phi", "psi")]
  tor <- data.frame(tor,
                    aa.lead = c(tor[-1,"aa"], NA_character_))

  tor <- data.frame(tor,
                    general = with(tor,
                                   ifelse(!grepl("PRO|GLY", aa),"General", NA)),
                    glycine = with(tor,
                                   ifelse(grepl("GLY", aa), "Glycine", NA)),
                    proline = with(tor,
                                   ifelse(grepl("PRO", aa), "Proline", NA)),
                    pre.pro = with(tor,
                                   ifelse(grepl("PRO", aa.lead), "Pre-Pro", NA)))
  #remove glycine from pre.pro
  tor$pre.pro <- ifelse(is.na(tor$glycine), tor$pre.pro, NA)

  scatter_data <- tor[,c(type, "phi", "psi")]
  scatter_data <- scatter_data[which(!is.na(scatter_data[,type])),]
  scatter_data <- scatter_data[!is.na(scatter_data$phi) & !is.na(scatter_data$psi),]

  if(smooth){
    dat <- ggrama::background_dist_smooth[[type]]
    mat <- unstack(dat, value ~ phi)
    mat <- resize_mat_linear(mat, 3*180, 3*180)
    dat <- as.data.frame(as.table(mat))
    colnames(dat) <- c("phi", "psi", "value")
    dat[,"phi"] <- rep(seq(-179, 179,
                           length.out = 3*180),
                       each = 3*180)
    dat[,"psi"] <- rep(seq(-179, 179,
                           length.out = 3*180),
                       3*180)
  } else {
    dat <- ggrama::background_dist[[type]]
    dat <- as.data.frame(dat)
  }


  if(!contour){
  rama_plot <- ggplot2::ggplot(dat) +
    ggplot2::geom_raster(ggplot2::aes_string(x = "phi",
                                           y = "psi",
                                           fill = "value"),
                       show.legend = FALSE,
                       interpolate = TRUE) +
    ggplot2::scale_fill_gradientn(colours =  colors,
                                  values = values,
                                  limits = c(0, 1),
                                  breaks = c(0, 0.5, 1))

  } else {
    rama_plot <- ggplot2::ggplot(dat) +
      geom_contour_filled(aes_string(x = "phi",
                                     y = "psi",
                                     z =  "value"),
                          breaks = values,
                          color = contour.color,
                          show.legend = FALSE) +
      scale_fill_manual(values = colors)
  }

  rama_plot <- rama_plot +
    ggplot2::ylab(expression(psi)) +
    ggplot2::xlab(expression(phi)) +
    ggplot2::theme_bw() +
    ggplot2::scale_x_continuous(expand = c(0.0015, 0),
                                breaks = c(-180, -90, 0, 90, 180),
                                limits = c(-180, 180)) +
    ggplot2::scale_y_continuous(expand = c(0.0015, 0),
                                breaks = c(-180, -90, 0, 90, 180),
                                limits = c(-180, 180)) +
    ggplot2::ggtitle(label = title) +
    ggplot2::theme(plot.margin = ggplot2::unit(c(0.3,0.3,0.3,0.3),"cm"),
                   panel.grid = ggplot2::element_blank(),
                   aspect.ratio = 1)


  rama_plot +
    ggplot2::geom_point(data = scatter_data,
                        ggplot2::aes_string(x = "phi",
                                            y = "psi"),
                        shape = shape,
                        size = size,
                        fill = fill)
}
