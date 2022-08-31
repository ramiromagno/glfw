#' @export
gl_gen_textures <- function(n) {
  .Call(gl_gen_textures_, n)
}

#' @export
gl_bind_texture <- function(target, texture) {
  .Call(gl_bind_texture_, target, texture)
}

#' @export
gl_tex_parameter_i <- function(target, pname, param) {
  .Call(gl_tex_parameter_i_, target, pname, param)
}

#' @export
gl_tex_image_2d <- function(target,
                            level,
                            internalformat,
                            width,
                            height,
                            border,
                            format,
                            type,
                            data) {

  .Call(
    gl_tex_image_2d_,
    target,
    level,
    internalformat,
    width,
    height,
    border,
    format,
    type,
    data
  )
}
