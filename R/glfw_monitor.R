#' @export
glfw_get_primary_monitor <- function() {
  .Call(glfw_get_primary_monitor_)
}

#' @export
glfw_get_monitors <- function() {
  .Call(glfw_get_monitors_)
}

#' @export
glfw_get_monitor_pos <- function(monitor) {
  .Call(glfw_get_monitor_pos_, monitor)
}

#' @export
glfw_get_monitor_workarea <- function(monitor) {
  .Call(glfw_get_monitor_workarea_, monitor)
}

#' @export
glfw_get_monitor_physical_size <- function(monitor) {
  .Call(glfw_get_monitor_physical_size_, monitor)
}

#' @export
glfw_get_monitor_content_scale <- function(monitor) {
  .Call(glfw_get_monitor_content_scale_, monitor)
}

#' @export
glfw_get_monitor_name <- function(monitor) {
  .Call(glfw_get_monitor_name_, monitor)
}

#' @export
glfw_get_video_mode <- function(monitor) {
  .Call(glfw_get_video_mode_, monitor)
}

#' @export
glfw_get_video_modes <- function(monitor) {
  lst <- .Call(glfw_get_video_modes_, monitor)
  as.data.frame(lst, col.names = c("width", "height", "red_bits", "green_bits", "blue_bits", "refresh_rate"))
}

#' @export
glfw_get_gamma_ramp <- function(monitor) {
  lst <- .Call(glfw_get_gamma_ramp_, monitor)
  as.data.frame(lst, col.names = c("red", "green", "blue"))
}
