setup_textures <- function() {

  texture1 <- gl_gen_textures(1L)
  gl_bind_texture(GL$TEXTURE_2D, texture1)
  gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_S, GL$REPEAT)
  gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_T, GL$REPEAT)
  gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MIN_FILTER, GL$LINEAR)
  gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MAG_FILTER, GL$LINEAR)

  image_path <- system.file("tutorials/learnopengl/assets/container.jpg", package = "glfw")
  img <- magick::image_flip(magick::image_read(image_path))
  data <- magick::image_data(img)
  img_width <- dim(data)[2]
  img_height <- dim(data)[3]

  gl_tex_image_2d(GL$TEXTURE_2D, 0L, GL$RGB, img_width, img_height, 0L, GL$RGB, GL$UNSIGNED_BYTE, data)
  gl_generate_mipmap(GL$TEXTURE_2D)

  texture2 <- gl_gen_textures(1L)
  gl_bind_texture(GL$TEXTURE_2D, texture2)
  gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_S, GL$REPEAT)
  gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_WRAP_T, GL$REPEAT)
  gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MIN_FILTER, GL$LINEAR_MIPMAP_LINEAR)
  gl_tex_parameter_i(GL$TEXTURE_2D, GL$TEXTURE_MAG_FILTER, GL$LINEAR)

  image_path <- system.file("tutorials/learnopengl/assets/awesomeface.png", package = "glfw")
  img <- magick::image_flip(magick::image_read(image_path))
  data <- magick::image_data(img)
  img_width <- dim(data)[2]
  img_height <- dim(data)[3]

  gl_tex_image_2d(GL$TEXTURE_2D, 0L, GL$RGBA, img_width, img_height, 0L, GL$RGBA, GL$UNSIGNED_BYTE, data)
  gl_generate_mipmap(GL$TEXTURE_2D)

  return(c(texture1 = texture1, texture2 = texture2))
}
