#' @export
glm_perspective_rh_zo <- function(fovy, aspect, z_near, z_far) {
  stopifnot(abs(aspect - .Machine$double.eps) > 0)

  tan_half_fovy <- tan(fovy / 2)

  m <- matrix(data = 0,
              nrow = 4,
              ncol = 4)

  m[1, 1] <- 1 / (aspect * tan_half_fovy)
  m[2, 2] <- 1 / tan_half_fovy
  m[3, 3] <- z_far / (z_near - z_far)
  m[4, 3] <- -1
  m[3, 4] <- -(z_far * z_near) / (z_far - z_near)

  m
}

#' @export
glm_perspective_rh_no <- function(fovy, aspect, z_near, z_far) {
  stopifnot(abs(aspect - .Machine$double.eps) > 0)

  tan_half_fovy <- tan(fovy / 2)

  m <- matrix(data = 0,
              nrow = 4,
              ncol = 4)

  m[1, 1] <- 1 / (aspect * tan_half_fovy)
  m[2, 2] <- 1 / tan_half_fovy
  m[3, 3] <- -(z_far + z_near) / (z_far - z_near)
  m[4, 3] <- -1
  m[3, 4] <- -(2 * z_far * z_near) / (z_far - z_near)

  m
}

#' @export
glm_perspective_lh_zo <- function(fovy, aspect, z_near, z_far) {
  stopifnot(abs(aspect - .Machine$double.eps) > 0)

  tan_half_fovy <- tan(fovy / 2)

  m <- matrix(data = 0,
              nrow = 4,
              ncol = 4)

  m[1, 1] <- 1 / (aspect * tan_half_fovy)
  m[2, 2] <- 1 / tan_half_fovy
  m[3, 3] <- z_far / (z_far - z_near)
  m[4, 3] <- 1
  m[3, 4] <- -(z_far * z_near) / (z_far - z_near)

  m
}

#' @export
glm_perspective_lh_no <- function(fovy, aspect, z_near, z_far) {
  stopifnot(abs(aspect - .Machine$double.eps) > 0)

  tan_half_fovy <- tan(fovy / 2)

  m <- matrix(data = 0,
              nrow = 4,
              ncol = 4)

  m[1, 1] <- 1 / (aspect * tan_half_fovy)
  m[2, 2] <- 1 / tan_half_fovy
  m[3, 3] <- (z_far + z_near) / (z_far - z_near)
  m[4, 3] <- 1
  m[3, 4] <- -(2 * z_far * z_near) / (z_far - z_near)

  m
}

#' @export
glm_perspective <- glm_perspective_rh_no
