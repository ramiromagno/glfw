#' @export
glfw_set_key_callback <- function(window, cb) {
  .Call(glfw_set_key_callback_, window, cb)
}
