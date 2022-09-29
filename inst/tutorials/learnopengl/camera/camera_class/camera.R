FORWARD <- 0
BACKWARD <- 1
LEFT <- 2
RIGHT <- 3

update_camera_vectors <- function(camera) {
  front <- c(
    x = cos(glm_rad(camera$Yaw)) * cos(glm_rad(camera$Pitch)),
    y = sin(glm_rad(camera$Pitch)),
    z = sin(glm_rad(camera$Yaw)) * cos(glm_rad(camera$Pitch))
  )

  camera$Front <- glm_normalize(front)
  camera$Right <- glm_normalize(glm_cross(camera$Front, camera$WorldUp))
  camera$Up <- glm_normalize(glm_cross(camera$Right, camera$Front))

  return(camera)
}

camera <- function(
    position = c(0, 0, 0),
    up = c(0, 1, 0),
    yaw = -90,
    pitch = 0,
    speed = 2.5,
    sensitivity = 0.1,
    zoom = 45
    ) {

  camera <- list(
    Position = position,
    Front = c(0, 0, -1),
    Up = NA_real_,
    Right = NA_real_,
    WorldUp = up,
    Yaw = yaw,
    Pitch = pitch,
    MovementSpeed = speed,
    MouseSensitivity = sensitivity,
    Zoom = zoom
  )

  return(update_camera_vectors(camera))

}

get_view_matrix <- function(camera) {
  glm_lookat(camera$Position, camera$Position + camera$Front, camera$Up)
}

process_keyboard <- function(camera, direction, delta_time) {
  velocity <- camera$MovementSpeed * delta_time
  if (direction == FORWARD)
    camera$Position = camera$Position + camera$Front * velocity

  if (direction == BACKWARD)
    camera$Position = camera$Position - camera$Front * velocity

  if (direction == LEFT)
    camera$Position = camera$Position - camera$Right * velocity

  if (direction == RIGHT)
    camera$Position = camera$Position + camera$Right * velocity

  return(camera)
}

process_mouse_movement <- function(camera, xoffset, yoffset, constraint_pitch = TRUE) {
  xoffset <- xoffset * camera$MouseSensitivity
  yoffset <- yoffset * camera$MouseSensitivity

  camera$Yaw <- camera$Yaw + xoffset
  camera$Pitch <- camera$Pitch + yoffset

  if (constraint_pitch)
  {
    if (camera$Pitch > 89) camera$Pitch <- 89
    if (camera$Pitch < -89) camera$Pitch <- -89
  }

  return(update_camera_vectors(camera))
}

process_mouse_scroll <- function(camera, yoffset) {

  camera$Zoom <- camera$Zoom - yoffset
  if (camera$Zoom < 1) camera$Zoom <- 1
  if (camera$Zoom > 45) camera$Zoom <- 45

  return(camera)
}
