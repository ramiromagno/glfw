#' @export
glm_frustum_lh_zo <- function(left, right, bottom, top, near_val, far_val) {

  m <- matrix(data = 0,
              nrow = 4,
              ncol = 4)

  m[1, 1] <- 2 * near_val / (right - left)
  m[2, 2] <- 2 * near_val / (top - bottom)
  m[1, 3] <- -(right + left) / (right - left)
  m[2, 3] <- -(top + bottom) / (top - bottom)
  m[3, 3] <- far_val / (far_val - near_val)
  m[4, 3] <- 1
  m[3, 4] <- -(far_val * near_val) / (far_val - near_val)

  m

}

#' @export
glm_frustum_lh_no <- function(left, right, bottom, top, near_val, far_val) {

  m <- matrix(data = 0,
              nrow = 4,
              ncol = 4)

  m[1, 1] <- 2 * near_val / (right - left)
  m[2, 2] <- 2 * near_val / (top - bottom)
  m[1, 3] <- -(right + left) / (right - left)
  m[2, 3] <- -(top + bottom) / (top - bottom)
  m[3, 3] <- (far_val + near_val) / (far_val - near_val)
  m[4, 3] <- 1
  m[3, 4] <- -(2 * far_val * near_val) / (far_val - near_val)

  m
}

#' @export
glm_frustum_rh_zo <- function(left, right, bottom, top, near_val, far_val) {

  m <- matrix(data = 0,
              nrow = 4,
              ncol = 4)

  m[1, 1] <- 2 * near_val / (right - left)
  m[2, 2] <- 2 * near_val / (top - bottom)
  m[1, 3] <- (right + left) / (right - left)
  m[2, 3] <- (top + bottom) / (top - bottom)
  m[3, 3] <- far_val / (near_val - far_val)
  m[4, 3] <- -1
  m[3, 4] <- -(far_val * near_val) / (far_val - near_val)

  m

}

#' @export
glm_frustum_rh_no <- function(left, right, bottom, top, near_val, far_val) {

  m <- matrix(data = 0,
              nrow = 4,
              ncol = 4)

  m[1, 1] <- 2 * near_val / (right - left)
  m[2, 2] <- 2 * near_val / (top - bottom)
  m[1, 3] <- (right + left) / (right - left)
  m[2, 3] <- (top + bottom) / (top - bottom)
  m[3, 3] <- - (far_val + near_val) / (far_val - near_val)
  m[4, 3] <- -1
  m[3, 4] <- -(2 * far_val * near_val) / (far_val - near_val)

  m
}

#' @export
glm_frustum <- glm_frustum_rh_no
