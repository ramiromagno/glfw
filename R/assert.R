is_scalar_int <- function(x) {
  is.integer(x) && length(x) == 1L && !anyNA(x)
}

is_scalar_dbl <- function(x) {
  is.double(x) && length(x) == 1L && !anyNA(x) && is.finite(x)
}

is_scalar_chr <- function(x) {
  is.character(x) && length(x) == 1L && !anyNA(x)
}

is_non_negative_scalar_int <- function(x) {
  is_scalar_int(x) && x >= 0L
}

is_non_negative_scalar_dbl <- function(x) {
  is_scalar_dbl(x) && x >= 0
}

is_positive_scalar_int <- function(x) {
  is_scalar_int(x) && x > 0L
}

is_positive_scalar_dbl <- function(x) {
  is_scalar_dbl(x) && x > 0
}
