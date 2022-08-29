#' @export
glfw_make_context_current <- function(window) {
  .Call(glfw_make_context_current_, window)
}
