#' @export
gl_get_uniform_location <- function(program, name) {
  .Call(gl_get_uniform_location_, program, name)
}

#' @export
gl_uniform_f <- function(location, value) {
  .Call(gl_uniform_f_, location, value)
}

#' @export
gl_uniform_i <- function(location, value) {
  .Call(gl_uniform_i_, location, value)
}

#' @export
gl_uniform_ui <- function(location, value) {
  .Call(gl_uniform_ui_, location, value)
}
