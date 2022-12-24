vertices <- function() {

  tbl <- expand.grid(c(-0.5, 0.5), c(-0.5, 0.5), c(-0.5, 0.5))

  m1 <- as.matrix(tbl[c(1, 2, 4, 4, 3, 1), ])
  m2 <- as.matrix(tbl[c(5, 6, 8, 8, 7, 5), ])
  m3 <- as.matrix(tbl[c(7, 3, 1, 1, 5, 7), ])
  m4 <- as.matrix(tbl[c(8, 4, 2, 2, 6, 8), ])
  m5 <- as.matrix(tbl[c(1, 2, 6, 6, 5, 1), ])
  m6 <- as.matrix(tbl[c(3, 4, 8, 8, 7, 3), ])

  n1 <- matrix(rep(c(0, 0, -1), 6), nrow = 6L, byrow = TRUE)
  n2 <- matrix(rep(c(0, 0, 1), 6), nrow = 6L, byrow = TRUE)
  n3 <- matrix(rep(c(-1, 0, 0), 6), nrow = 6L, byrow = TRUE)
  n4 <- matrix(rep(c(1, 0, 0), 6), nrow = 6L, byrow = TRUE)
  n5 <- matrix(rep(c(0, -1, 0), 6), nrow = 6L, byrow = TRUE)
  n6 <- matrix(rep(c(0, 1, 0), 6), nrow = 6L, byrow = TRUE)

  vertices <-
    rbind(
      cbind(m1, n1),
      cbind(m2, n2),
      cbind(m3, n3),
      cbind(m4, n4),
      cbind(m5, n5),
      cbind(m6, n6)
    )

  rownames(vertices) <- NULL
  colnames(vertices) <- NULL

  vertices
}

