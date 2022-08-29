#' @export
glfw_create_window <- function(width, height, title) {
  .Call(glfw_create_window_, width, height, title)
}

#' @export
glfw_destroy_window <- function(window) {
  .Call(glfw_destroy_window_, window)
}

#' @export
glfw_get_window_size <- function(window) {
  .Call(glfw_get_window_size_, window)
}
