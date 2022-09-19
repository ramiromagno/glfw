#' @export
glfw_set_key_callback <- function(window, cb) {
  .Call(glfw_set_key_callback_, window, cb)
}

#' @export
glfw_get_key <- function(window, key) {
  .Call(glfw_get_key_, window, key)
}

#' @export
glfw_get_key_scancode <- function(key) {
  .Call(glfw_get_key_scancode_, key)
}

#' @export
glfw_set_input_mode <- function(window, mode, value) {
  .Call(glfw_set_input_mode_, window, mode, value)
}

#' @export
glfw_get_key_name <- function(key, scancode) {
  .Call(glfw_get_key_name_, key, scancode)
}
