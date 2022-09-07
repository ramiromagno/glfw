#' @export
glm_ortho_lh_zo <- function(left, right, bottom, top, z_near, z_far) {

  m <- diag(4)

  m[1, 1] <- 2 / (right - left)
  m[2, 2] <- 2 / (top - bottom)
  m[3, 3] <- 1 / (z_far - z_near)
  m[1, 4] <- - (right + left) / (right - left)
  m[2, 4] <- - (top + bottom) / (top - bottom)
  m[3, 4] <- - z_near / (z_far - z_near)

  m
}

#' @export
glm_ortho_lh_no <- function(left, right, bottom, top, z_near, z_far) {

  m <- diag(4)

  m[1, 1] <- 2 / (right - left)
  m[2, 2] <- 2 / (top - bottom)
  m[3, 3] <- 2 / (z_far - z_near)
  m[1, 4] <- - (right + left) / (right - left)
  m[2, 4] <- - (top + bottom) / (top - bottom)
  m[3, 4] <- - (z_far + z_near) / (z_far - z_near)

  m
}

#' @export
glm_ortho_rh_zo <- function(left, right, bottom, top, z_near, z_far) {

  m <- diag(4)

  m[1, 1] <- 2 / (right - left)
  m[2, 2] <- 2 / (top - bottom)
  m[3, 3] <- - 1 / (z_far - z_near)
  m[1, 4] <- - (right + left) / (right - left)
  m[2, 4] <- - (top + bottom) / (top - bottom)
  m[3, 4] <- - z_near / (z_far - z_near)

  m
}

#' @export
glm_ortho_rh_no <- function(left, right, bottom, top, z_near, z_far) {

  m <- diag(4)

  m[1, 1] <- 2 / (right - left)
  m[2, 2] <- 2 / (top - bottom)
  m[3, 3] <- - 2 / (z_far - z_near)
  m[1, 4] <- - (right + left) / (right - left)
  m[2, 4] <- - (top + bottom) / (top - bottom)
  m[3, 4] <- - (z_far + z_near) / (z_far - z_near)

  m
}

#' @export
glm_ortho <- glm_ortho_rh_no
