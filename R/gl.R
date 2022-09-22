#' @export
gl_clear <- function(mask) {
  .Call(gl_clear_, mask)
}

#' @export
gl_clear_color <- function(red, green, blue, alpha) {

  # All arguments should be numbers between 0.0 and 1.0.
  stopifnot(is.double(red),
            is.double(green),
            is.double(blue),
            is.double(alpha))

  stopifnot(red   >= 0, red   <= 1,
            green >= 0, green <= 1,
            blue  >= 0, blue  <= 1,
            alpha >= 0, alpha <= 1)

  .Call(gl_clear_color_, red, green, blue, alpha)
}

#' @export
gl_viewport <- function(x, y, width, height) {
  .Call(gl_viewport_, x, y, width, height)
}

#' @export
gl_polygon_mode <- function(face, mode) {
  .Call(gl_polygon_mode_, face, mode)
}

#' @export
gl_enable <- function(cap) {
  .Call(gl_enable_, cap)
}

#' @export
gl_disable <- function(cap) {
  .Call(gl_disable_, cap)
}

#' @export
gl_get_string <- function(name) {
  .Call(gl_get_string_, name)
}
