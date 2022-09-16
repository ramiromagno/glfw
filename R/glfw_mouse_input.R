#' @export
glfw_set_cursor_pos_callback <- function(window, cb) {
  .Call(glfw_set_cursor_pos_callback_, window, cb)
}

#' @export
glfw_get_cursor_pos <- function(window) {
  .Call(glfw_get_cursor_pos_, window)
}

#' @export
glfw_set_cursor_pos <- function(window, xpos, ypos) {
  .Call(glfw_set_cursor_pos_, window, xpos, ypos)
}
