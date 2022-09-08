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

