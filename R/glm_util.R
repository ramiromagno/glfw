#' @export
glm_sign <- function(val) {
  sign(val)
}

#' @export
glm_signf <- glm_sign

#' @export
glm_rad <- function(deg) {
  deg * pi / 180
}

#' @export
glm_deg <- function(rad) {
  rad * 180 / pi
}

#' @export
glm_min <- function(a, b) {
  min(a, b)
}

#' @export
glm_max <- function(a, b) {
  max(a, b)
}

#' @export
glm_clamp <- function(val, min_val, max_val) {
  min(max(val, min_val), max_val)
}

#' @export
glm_lerp <- function(from, to, t) {
  from + (to - from) * t
}

#' @export
glm_eq <- function(a, b) {
  identical(a, b)
}
