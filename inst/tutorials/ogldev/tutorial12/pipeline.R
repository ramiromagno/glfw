orientation <- function(
    m_scale = c(1, 1, 1),
    m_rotation = c(0, 0, 0),
    m_pos = c(0, 0, 0)) {

  list(
    m_scale = m_scale,
    m_rotation = m_rotation,
    m_pos = m_pos
  )
}

pipeline <- function(
    m_scale = c(1, 1, 1),
    m_world_pos = c(0, 0, 0),
    m_rotate_info = c(0, 0, 0)
    ) {

  list(
    m_scale = m_scale,
    m_world_pos = m_world_pos,
    m_rotate_info = m_rotate_info
  )
}

scale <- function(pipeline, scale_x, scale_y, scale_z) {

  pipeline$m_scale <- c(scale_x, scale_y, scale_z)

  pipeline
}

world_pos <- function(pipeline, x, y, z) {
  pipeline$m_world_pos <- c(x, y, z)

  pipeline
}

rotate <- function(pipeline, rotate_x, rotate_y, rotate_z) {
  pipeline
}
