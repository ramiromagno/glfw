#' @export
gl_gen_vertex_arrays <- function(n) {
  .Call(gl_gen_vertex_arrays_, n)
}

#' @export
gl_gen_buffers <- function(n) {
  .Call(gl_gen_buffers_, n)
}

#' @export
gl_bind_vertex_array <- function(array) {
  .Call(gl_bind_vertex_array_, array)
}

#' @export
gl_bind_buffer <- function(target, buffer) {
  .Call(gl_bind_buffer_, target, buffer)
}

#' @export
gl_buffer_data <- function(target, data, usage) {
  .Call(gl_buffer_data_, target, data, usage)
}

#' @export
gl_vertex_attrib_pointer <- function(index,
                                     size,
                                     type,
                                     normalized,
                                     stride,
                                     offset) {
  .Call(gl_vertex_attrib_pointer_,
        index,
        size,
        type,
        normalized,
        stride,
        offset)
}

#' @export
gl_enable_vertex_attrib_array <- function(index) {
  .Call(gl_enable_vertex_attrib_array_, index)
}
