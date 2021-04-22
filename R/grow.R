
#' Grow a branch
#'
#' @param m input matrix of
#' @param leaf leaf shape, a matrix with 4 columns for x, y, xend, yend
#' @param growth_fraction
#'
#' @return
#' @export
#'
grow <- function(m, leaf, growth_fraction = 1){
  angle <- atan2(m[, 4] - m[, 2] , m[, 3] - m[, 1]) + pi / 2
  shrunken_leaf <- leaf %>% shrink(growth_fraction)
  zz <- lapply(seq_len(nrow(m)), function(i){
    z <- rotate(shrunken_leaf, pi - angle[i], radians = TRUE)
    translate(z, m[i, 3:4])
  })
  do.call(rbind, zz)
}

leaf_names <- function(m){
  m %>% set_colnames(c("x", "y", "xend", "yend"))
}

#' Grow a tree
#'
#' @inheritParams grow
#' @param depth Integer that specifies the depth (height) of the tree, i.e. the number of loops
#' @param growth_fraction
#'
#' @return
#' @export
#'
fractal_tree <- function(leaf, depth, growth_fraction){
  edges <- list()
  edges[[1]] <- leaf %>% cbind(1)
  for (i in seq_len(depth)[-1]) {
    edges[[i]] <-
      edges[[i - 1]] %>%
      grow(leaf, growth_fraction = growth_fraction^i) %>%
      cbind(i)
  }
  z <- do.call(rbind, edges)
  colnames(z) <- c("x", "y", "xend", "yend", "i")
  z <- as.data.frame(z)
  z
}


#' Plot the tree
#'
#' @param x A tree object, resulting from `grow_tree()`
#' @param colors A vector of lenght two with start and end colour
#' @param colours
#'
#' @return
#' @export
#'
#' @importFrom ggplot2 ggplot geom_segment coord_fixed theme_void scale_color_gradient aes
plot_tree <- function(x, colors = c("brown", "darkgreen"), colours = colors){
  x %>%
    ggplot() +
    geom_segment(
      aes(x = x, y = y, xend = xend, yend = yend, col = i)
    ) +
    coord_fixed() +
    theme_void() +
    scale_color_gradient(low = colours[1], high = colours[2], guide = "none")
}

