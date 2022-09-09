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

