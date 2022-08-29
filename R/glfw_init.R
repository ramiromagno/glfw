#
# Initialization, version and error reference.
#

#' @export
glfw_init <- function() {
  .Call(glfw_init_)
}

#' @export
glfw_terminate <- function() {
  .Call("glfw_terminate_")
}

#' @export
glfw_get_version <- function() {
  .Call("glfw_get_version_")
}

#' @export
glfw_get_version_string <- function() {
  .Call("glfw_get_version_string_")
}

#' @export
glfw_window_hint <- function(hint, value) {
  .Call("glfw_window_hint_", hint, value)
}
