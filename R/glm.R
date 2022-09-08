#' @export
glm_vec3 <- function(x, y, z) {
  c(x, y, z)
}

#' @export
glm_vec4 <- function(x, y, z, w) {
  c(x, y, z, w)
}

#' @export
glm_length <- function(x) {
  sqrt(sum(x ^ 2))
}

#' @export
glm_normalize <- function(x) {
  x / sqrt(sum(x ^ 2))
}

#' @export
glm_cross <- function(x, y) {
  c(x[2] * y[3] - x[3] * y[2],
    x[3] * y[1] - x[1] * y[3],
    x[1] * y[2] - x[2] * y[1])
}

#' @export
glm_dot <- function(x, y) {
  sum(x * y)
}

#' @export
glm_translate <- function(m, v) {
  m[, 4] <- m[, 1] * v[1] + m[, 2] * v[2] + m[, 3] * v[3] + m[, 4]
  m
}

#' @export
glm_scale <- function(m, v) {

  m[, 1] <- m[, 1] * v[1]
  m[, 2] <- m[, 2] * v[2]
  m[, 3] <- m[, 3] * v[3]

  m
}

#' @export
glm_rotate <- function(m, angle, axis) {

  a <- angle
  c <- cos(a)
  s <- sin(a)

  axis <- glm_normalize(axis)
  temp <- (1 - c) * axis

  rotate <- matrix(0, nrow = 4, ncol = 4)

  rotate[1, 1] <- c + temp[1] * axis[1]
  rotate[2, 1] <- temp[1] * axis[2] + s * axis[3]
  rotate[3, 1] <- temp[1] * axis[3] - s * axis[2]

  rotate[1, 2] <- temp[2] * axis[1] -s * axis[3]
  rotate[2, 2] <- c + temp[2] * axis[2]
  rotate[3, 2] <- temp[2] * axis[3] + s * axis[1]

  rotate[1, 3] <- temp[3] * axis[1] + s * axis[2]
  rotate[2, 3] <- temp[3] * axis[2] - s * axis[1]
  rotate[3, 3] <- c + temp[3] * axis[3]

  m_ <- matrix(0, nrow = 4, ncol = 4)
  m_[, 1] <- m[, 1] * rotate[1, 1] + m[, 2] * rotate[2, 1] + m[, 3] * rotate[3, 1]
  m_[, 2] <- m[, 1] * rotate[1, 2] + m[, 2] * rotate[2, 2] + m[, 3] * rotate[3, 2]
  m_[, 3] <- m[, 1] * rotate[1, 3] + m[, 2] * rotate[2, 3] + m[, 3] * rotate[3, 3]
  m_[, 4] <- m[, 4]

  m_
}
