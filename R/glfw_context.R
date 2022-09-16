#' @export
glfw_make_context_current <- function(window) {
  .Call(glfw_make_context_current_, window)
}

#' @export
glfw_swap_buffers <- function(window) {
  .Call(glfw_swap_buffers_, window)
}

#' @export
glfw_get_current_context <- function() {
  .Call(glfw_get_current_context_)
}

