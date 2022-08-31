#' @export
gl_create_shader <- function(shader_type) {
  .Call(gl_create_shader_, shader_type)
}

#'@export
gl_shader_source <- function(shader, count, string, length = NULL) {
  string <- paste(string, collapse = "\n")
  .Call(gl_shader_source_, shader, count, string, length)
}

#' @export
gl_compile_shader <- function(shader) {
  .Call(gl_compile_shader_, shader)
}

#' @export
gl_is_shader <- function(shader) {
  .Call(gl_is_shader_, shader)
}

#' @export
gl_delete_shader <- function(shader) {
  .Call(gl_delete_shader_, shader)
}

#' @export
gl_get_shader_iv <- function(shader, pname) {
  .Call(gl_get_shader_iv_, shader, pname)
}

#' @export
gl_get_shader_info_log <- function(shader) {
  .Call(gl_get_shader_info_log_, shader)
}
