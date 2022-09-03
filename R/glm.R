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
glm_lookat_rh <- function(eye, center, up) {
  f <- glm_normalize(center - eye)
  s <- glm_normalize(glm_cross(f, up))
  u <- glm_cross(s, f)

  m <- diag(4)

  m[1, 1] <- s[1]
  m[1, 2] <- s[2]
  m[1, 3] <- s[3]

  m[2, 1] <- u[1]
  m[2, 2] <- u[2]
  m[2, 3] <- u[3]

  m[3, 1] <- -f[1]
  m[3, 2] <- -f[2]
  m[3, 3] <- -f[3]

  m[1, 4] <- -glm_dot(s, eye)
  m[2, 4] <- -glm_dot(u, eye)
  m[3, 4] <- glm_dot(f, eye)

  m
}

#' @export
glm_lookat_lh <- function(eye, center, up) {
  f <- glm_normalize(center - eye)
  s <- glm_normalize(glm_cross(up, f))
  u <- glm_cross(f, s)

  m <- diag(4)

  m[1, 1] <- s[1]
  m[1, 2] <- s[2]
  m[1, 3] <- s[3]

  m[2, 1] <- u[1]
  m[2, 2] <- u[2]
  m[2, 3] <- u[3]

  m[3, 1] <- f[1]
  m[3, 2] <- f[2]
  m[3, 3] <- f[3]

  m[1, 4] <- -glm_dot(s, eye)
  m[2, 4] <- -glm_dot(u, eye)
  m[3, 4] <- -glm_dot(f, eye)

  m
}

#' @export
glm_lookat <- glm_lookat_rh
