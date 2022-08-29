#' @export
glfw_get_key <- function(window, key) {
  .Call(glfw_get_key_, window, key)
}
