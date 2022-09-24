#' @export
os <- function() {
  tolower(Sys.info()[["sysname"]])
}
