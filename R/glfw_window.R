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

#' @export
glfw_set_window_size <- function(window, width, height) {
  .Call(glfw_set_window_size_, window, width, height)
}

#' @export
glfw_set_framebuffer_size_callback <- function(window, cbfun) {
  .Call(glfw_set_framebuffer_size_callback_, window, cbfun)
}

#' @export
glfw_window_should_close <- function(window) {
  .Call(glfw_window_should_close_, window)
}

#' @export
glfw_set_window_should_close <- function(window, value) {
  value <- as.integer(value)
  .Call(glfw_set_window_should_close_, window, value)
}

#' @export
glfw_poll_events <- function() {
  .Call(glfw_poll_events_)
}

#' @export
glfw_window_hint <- function(hint, value) {
  .Call(glfw_window_hint_, hint, value)
}

#' @export
glfw_set_window_aspect_ratio <- function(window, numer, denom) {
  .Call(glfw_set_window_aspect_ratio_, window, numer, denom)
}

#' @export
glfw_window_hint_string <- function(hint, value) {
  .Call(glfw_window_hint_string_, hint, value)
}

#' @export
glfw_set_window_size_limits <- function(window,
                                        min_width,
                                        min_height,
                                        max_width,
                                        max_height) {
  .Call(glfw_set_window_size_limits_,
        window,
        min_width,
        min_height,
        max_width,
        max_height)
}

#' @export
glfw_get_framebuffer_size <- function(window) {
  .Call(glfw_get_framebuffer_size_, window)
}

#' @export
glfw_get_window_frame_size <- function(window) {
  .Call(glfw_get_window_frame_size_, window)
}

#' @export
glfw_get_window_content_scale <- function(window) {
  .Call(glfw_get_window_content_scale_, window)
}
