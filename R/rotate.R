
#' Rotate object using matrix algebra.
#'
#' @param m Input matrix
#' @param theta Angle of rotation
#' @param radians If TRUE theta is radians, otherwise degrees
#'
#' @return foo
#' @export
#'
#' @family Rotate, translate and shrink
rotate <- function(m, theta = 0, radians = FALSE){
  r2 <- function(theta){
    matrix(c(
      cos(theta), -sin(theta), 0, 0,
      sin(theta), cos(theta), 0, 0,
      0, 0, cos(theta), -sin(theta),
      0, 0, sin(theta), cos(theta)
    ), byrow = TRUE, ncol = 4)
  }

  cn <- colnames(m)
  was_data_frame <- inherits(m, "data.frame")
  if (is.data.frame(m)) {
    m <- as.matrix(m)
  }

  if (!radians) theta = (theta * pi) / 180
  m[, 1:4] <-  m[, 1:4] %*% r2(theta)
  if (was_data_frame) m <- as.data.frame(m)
  colnames(m) <- cn
  m
}

#' Shrink object
#'
#' @inheritParams rotate
#' @param s scaling factor
#'
#' @return foo
#' @export
#'
#' @family Rotate, translate and shrink
shrink <- function(m, s = 0){
  m[, 1:4] <- m[, 1:4] * s
  m
}


#' Translate object in x and y plane
#'
#' @inheritParams rotate
#' @param xy a Vector of length two with x and y component
#'
#' @return foo
#' @export
#'
#' @family Rotate, translate and shrink
translate <- function(m, xy) {
  m[, 1:4] <- m[, 1:4] + matrix(
    rep(c(xy, xy), nrow(m)),
    byrow = TRUE, ncol = 4
  )
  m
}



#' Translate object in x and y plane
#'
#' @inheritParams rotate
#' @param n Number of repetitions
#'
#' @return foo
#' @export
#'
#' @family Rotate, translate and shrink
kaleidoscope <- function(m, n){
  if (missing(n) || is.null(n)) {
    angle <- atan2(m[, 4], m[, 3]) %>% range() %>% diff()
    n <-  round(2 * pi / angle)
  }
  z <- lapply(seq_len(n), function(i){
    rotate(m, 2 * pi * i / n, radians = TRUE)
  })
  do.call(rbind, z)
}
