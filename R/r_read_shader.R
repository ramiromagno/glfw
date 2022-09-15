# lousy heurestic to determine if `x` is textual source code of a shader
is_shader_src <- function(x) length(x) > 1 || grepl("\n", x)[[1]]

#' @export
read_shader <- function(shader_src) {

  if (is_shader_src(shader_src))
    return(shader_src)

  # Else, assume a file path
  file <- shader_src
  src <- readLines(con = file)
  paste(src, collapse = "\n")

}
