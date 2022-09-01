#' @export
glfw_get_key <- function(window, key) {
  .Call(glfw_get_key_, window, key)
}

#' @export
glfw_get_time <- function() {
  .Call(glfw_get_time_)
}

#' @export
glfw_set_time <- function(time) {
  .Call(glfw_set_time_, time)
}
