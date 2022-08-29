#' @export
gl_clear <- function(mask) {
  .Call(gl_clear_, mask)
}
