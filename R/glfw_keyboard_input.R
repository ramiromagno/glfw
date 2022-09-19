#' @export
glfw_set_key_callback <- function(window, cb) {
  .Call(glfw_set_key_callback_, window, cb)
}

#' @export
glfw_get_key <- function(window, key) {
  .Call(glfw_get_key_, window, key)
}
