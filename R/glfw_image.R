#' @export
glfw_create_image <- function(image_data) {
  .Call(glfw_create_image_, image_data)
}

#' @export
glfw_destroy_image <- function(image_data) {
  .Call(glfw_destroy_image_, image_data)
}
