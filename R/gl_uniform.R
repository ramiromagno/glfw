#' @export
gl_get_uniform_location <- function(program, name) {
  .Call(gl_get_uniform_location_, program, name)
}

#' @export
gl_uniform_fv <- function(location, value) {
  .Call(gl_uniform_fv_, location, value)
}

#' @export
gl_uniform_f <- function(location, v) {
  .Call(gl_uniform_f_, location, v)
}

#' @export
gl_uniform_iv <- function(location, value) {
  .Call(gl_uniform_iv_, location, value)
}

#' @export
gl_uniform_uiv <- function(location, value) {
  .Call(gl_uniform_uiv_, location, value)
}

#' @export
gl_uniform_matrix4_fv <- function(location, transpose, value) {
  .Call(gl_uniform_matrix4_fv_, location, transpose, value)
}
