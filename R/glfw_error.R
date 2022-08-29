#' @export
glfw_get_error <- function() {
  .Call("glfw_get_error_")
}

#' @export
glfw_set_error_callback <-
  function(callback = function(error, description)
    cat(paste0("Error code: ", error, "\nDescription: ", description, "\n"))) {
  .Call("glfw_set_error_callback_", callback)
}
