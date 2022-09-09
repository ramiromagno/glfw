#' @export
glfw_get_version <- function() {
  .Call("glfw_get_version_")
}

#' @export
glfw_get_version_string <- function() {
  .Call("glfw_get_version_string_")
}

#' @keywords internal
GLFW_VERSION_MAJOR <- function() {
  .Call(GLFW_VERSION_MAJOR_)
}

#' @keywords internal
GLFW_VERSION_MINOR <- function() {
  .Call(GLFW_VERSION_MINOR_)
}

#' @keywords internal
GLFW_VERSION_REVISION <- function() {
  .Call(GLFW_VERSION_REVISION_)
}
