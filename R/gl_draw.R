#' @export
gl_draw_arrays <- function(mode, first, count) {
  .Call(gl_draw_arrays_, mode, first, count)
}

#' @export
gl_draw_elements <- function(mode, count, type, indices) {
  .Call(gl_draw_elements_, mode, count, type, indices)
}
