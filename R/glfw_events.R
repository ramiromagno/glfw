#' @export
glfw_poll_events <- function() {
  .Call(glfw_poll_events_)
}

#' @export
glfw_wait_events <- function() {
  .Call(glfw_wait_events_)
}

#' @export
glfw_wait_events_timeout <- function(timeout) {
  .Call(glfw_wait_events_timeout_, timeout)
}

#' @export
glfw_post_empty_event <- function() {
  .Call(glfw_post_empty_event_)
}
