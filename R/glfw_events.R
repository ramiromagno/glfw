#' @export
glfw_poll_events <- function() {
  .Call(glfw_poll_events_)
}
