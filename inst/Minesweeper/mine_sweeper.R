input.data <- function()  {
  w <- (readline("Veuillez saisir le numéro de largeur:"))
  w <- as.numeric(w)
  h <- (readline("Veuillez saisir le numéro de hauteur:"))
  h <- as.numeric(h)
  m <- (readline("Veuillez saisir le numéro de mines :"))
  m <- as.numeric(m)
  list(w = w, h = h , m = m)
}

# La fonction commencer maintenant
start <- function ()  {
  inputs <- input.data()
  mine_sweeper(inputs$w, inputs$h, inputs$m)
}


mine_sweeper <- function(largeur, hauteur, mines_in) {
  if (.Platform$OS.type == "windows") x11() else x11(type = "Xlib")
  mine_sweeper_1(width = largeur, height = hauteur, mines = mines_in, cheat = FALSE)
}


# Pour le joueur idiot, vous pouvez tricher!
mine_sweeper.cheat <- function(largeur, hauteur, mines_in) {
  mine_sweeper_1(width = largeur, height = hauteur, mines = mines_in, cheat = TRUE)
}


mine_sweeper_1 <- function(width, height, mines, cheat = FALSE) {
  # Traiter avec quelques exceptions .
  if (!interactive()) return()
  if (mines >= width * height - 1) {
    stop("Êtes-vous un terroriste ??? Trop de mines !")
  }
  if (width <= 0 | height <= 0 | mines <= 0) {
    stop("largeur,hauteur et les mines devraient être positives!")
  }
  width <- floor(width)
  height <- floor(height)
  mines <- floor(mines)
  
  m <- rep(0, width * height)
  # Statut: 0 pour les zones non testées, 1 pour les zones testées, 2 pour les drapeaux
  mat.status <- matrix(m, height, width)
  mine.index <- sample(width * height, mines)
  m[mine.index] <- -10
  mine.mat <- matrix(m, height, width)
  search.mine <- which(mine.mat < 0, arr.ind = TRUE)
  mine.row <- search.mine[, 1]
  mine.col <- search.mine[, 2]
  # Calculer le nombre de mines dans chaque carré 3x3
  for (i in 1:mines) {
    mrow <- intersect(1:height, (mine.row[i] - 1):(mine.row[i] + 1))
    mcol <- intersect(1:width, (mine.col[i] - 1):(mine.col[i] + 1))
    mine.mat[mrow, mcol] <- mine.mat[mrow, mcol] + 1
  }
  mine.mat <- ifelse(mine.mat < 0, -1, mine.mat)
  # -1 pour les mines
  if (cheat) print(mine.mat)
  
  # Tracer une grille
  plot.grid <- function(x, y, w = 1, h = 1, col1 = "#D6E3F0", col2 = "#92B0CA", slices = 10) {
    #  créer des dégradés de couleur 
    f <- colorRampPalette(c(col1, col2))
    cols <- f(slices)
    xs <- rep(x, slices)
    ys <- seq(y + 0.5 * h - 0.5 * h / slices, y - 0.5 * h + 0.5 * h / slices,
              length.out = slices)
    gwidth <- rep(w, slices)
    gheight <- rep(h / slices, slices)
    # Rectangles aux couleurs contiguës :
    symbols(xs, ys, rectangles = cbind(gwidth, gheight), fg = cols, bg = cols,
            inches = FALSE, add = TRUE)
    #         polygon(x + c(-0.5, -0.5, -0.45) * w,
    #                 y + c(0.45, 0.5, 0.5) * h,
    #                 border = NA, col = "#DDDDDD")
    #         polygon(x + c(0.45, 0.5, 0.5) * w,
    #                 y + c(0.5, 0.5, 0.45) * h,
    #                 border = NA, col = "#DDDDDD")
    #         polygon(x + c(-0.5, -0.5, -0.45) * w,
    #                 y + c(-0.5, -0.45, -0.5) * h,
    #                 border = NA, col = "#DDDDDD")
    #         polygon(x + c(0.45, 0.5, 0.5) * w,
    #                 y + c(-0.5, -0.45, -0.5) * h,
    #                 border = NA, col = "#DDDDDD")
    #         polygon(x + c(-0.5, -0.45, 0.45, 0.5, 0.5, 0.45, -0.45, -0.5) * w,
    #                 y + c(0.45, 0.5, 0.5, 0.45, -0.45, -0.5, -0.5, -0.45) * h,
    #                 border = "#777777", lwd = 1)
    # Border
    polygon(x + c(-0.5, -0.5, 0.5, 0.5) * w, y + c(-0.5, 0.5, 0.5, -0.5) * h,
            border = "#777777")
  }
  
  # Tracer l’interface :
  par(mar = c(0, 0, 0, 0), bg = "#DDDDDD")
  plot(1, type = "n", asp = 1, xlab = "", ylab = "",
       xlim = c(0.5, width + 0.5), ylim = c(0.5, height + 0.5), axes = FALSE)
  
  # Définir la police de l'appareil X11
  if(.Device == "X11") {
  #X11Font() pour spécifier une police de caractères personnalisée
    fixed <- X11Font("-*-fixed-*-*-*-*-*-*-*-*-*-*-*-*")
    X11Fonts(fixed = fixed)
    par(family = "fixed")
  }
  x.grid <- (width + 1) / 2
  y.grid <- 1:height
  for (i in 1:height)  plot.grid(x.grid, y.grid[i], w = width, h = 1)
  x0 <- x1 <- seq(1.5, by = 1, length.out = width - 1)
  y0 <- rep(0.5, width - 1)
  y1 <- y0 + height
  segments(x0, y0, x1, y1, col = "#777777")
  
  # Couleurs pour dessiner des nombres
  col.palette <- c("DarkBlue", "ForestGreen", "brown", "green",
                   "blue", "yellow", "orange", "red")
  # Fonction permettant de déterminer la taille de police des nombres
  text.cex <- function() {
    ps <- par("ps")
    0.6 * min(dev.size(units = "px") / c(width, height)) / ps
  }
  # tracer les nombre 
  plot.num <- function(x, y, num) {
    for(i in 1:length(x))  plot.grid(x[i], y[i], col1 = "#FFFFFF", col2 = "#C8C8C8")
    pnum = num[num > 0]
    px = x[num > 0]
    py = y[num > 0]
    text(px, py, pnum, col = col.palette[pnum], cex = text.cex())
  }
  # Tirer des mines non explosées -- vectorisées
  plot.mine <- function(x, y) {
    for(i in 1:length(x))  plot.grid(x[i], y[i], col1 = "#FFFFFF", col2 = "#C8C8C8")
    symbols(x, y, circles = rep(0.35, length(x)),
            inches = FALSE, fg = NULL, bg = "black", add = TRUE)
    op = par(lend = 2)
    segments(x - 0.4, y, x + 0.4, y, col = "black", lwd = 5)
    segments(x, y - 0.4, x, y + 0.4, col = "black", lwd = 5)
    d = 0.4 / sqrt(2)
    segments(x - d, y - d, x + d, y + d, col = "black", lwd = 5)
    segments(x - d, y + d, x + d, y - d, col = "black", lwd = 5)
  }
  # Dessiner les mines explosée
  plot.mine.explode <- function(x, y) {
    plot.grid(x, y, col1 = "#FFFFFF", col2 = "#C8C8C8")
    star <- t(matrix(c(0.3, 0.4), 20, length(x)))
    symbols(x, y, stars = star, inches = FALSE, bg = "red", fg = NA, add = TRUE)
    symbols(x, y, stars = 0.7 * star, inches = FALSE, bg = "yellow", fg = NA, add = TRUE)
  }
  # Dessiner les drapeaux -- vectorisé
  plot.flag <- function(x, y) {
    symbols(x + 0.075, y + 0.2,
            rectangles = matrix(rep(c(0.35, 0.2), rep(length(x), 2)), ncol = 2),
            inches = FALSE, fg = "red", bg = "red", add = TRUE)
    symbols(x, y - 0.25,
            rectangles = matrix(rep(c(0.6, 0.1), rep(length(x), 2)), ncol = 2),
            inches = FALSE, fg = "black", bg = "black", add = TRUE)
    segments(x - 0.1, y + 0.3, x - 0.1, y - 0.2)
  }
  search.zeroes <- function(pos, mat) {
    nr <- nrow(mat)
    nc <- ncol(mat)
    x <- ifelse(pos %% nr == 0, nr, pos %% nr)
    y <- ceiling(pos / nr)
    areas <- c(pos, (x > 1 & y > 1) * (pos - nr - 1), (y > 1) * (pos - nr),
               (x < nr & y > 1) * (pos - nr + 1), (x > 1) * (pos - 1),
               (x < nr) * (pos + 1), (x > 1 & y < nc) * (pos + nr - 1),
               (y < nc) * (pos + nr), (x < nr & y < nc) * (pos + nr + 1))
    areas <- unique(areas[areas != 0])
    zeroes <- intersect(areas, which(mat == 0))
    return(list(zeroes = zeroes, areas = areas))
  }
  
  mousedown <- function(buttons, x, y) {
    ## le clic droit mène aux boutons = c (0, 1)
    if (length(buttons) == 2) buttons <- 2
    plx <- round(grconvertX(x, "ndc", "user")) #La fonction grconvertX() est utilisée pour convertir 
    ply <- round(grconvertY(y, "ndc", "user")) #des coordonnées d'un système de coordonnées graphique
    ms <- mat.status
    if (plx < 1 || plx > width || ply < 1 || ply > height || buttons == 1) {
      return(ms)
    }
    current.status <- ms[height + 1 - ply, plx]
    current.mat <- mine.mat[height + 1 - ply, plx]
    ## Bouton gauche
    if (buttons == 0) {
      ## Zone non testée
      if (current.status == 0) {
        ## c'est une mine
        if (current.mat == -1) {
          plot.mine(mine.col, height + 1 - mine.row)
          plot.mine.explode(plx, ply)
          gameover("Game Over!\n")
          repeat{
            #La fonction locator() est utilisée pour permettre à l'utilisateur de cliquer 
            #sur le graphique pour récupérer les coordonnées d'un point.
            l = locator(1)
            x = l$x
            y = l$y
            if(x>42.3 & x<58 & y>12 & y<27){closeit()}
          }
          ## Zone vide :
        } else if (current.mat == 0) {
          pos <- height * plx + 1 - ply
          while (TRUE) {
            temp <- pos
            lst <- search.zeroes(pos, mine.mat)
            pos <- lst$zeroes
            if (length(pos) == length(temp)) {
              areas <- lst$areas
              areas.row <- ifelse(areas %% height == 0, height, areas %% height)
              areas.col <- ceiling(areas / height)
              plot.num(areas.col, height + 1 - areas.row, mine.mat[areas])
              ms[areas] <- 1
              break
            }
          }
          if (sum(ms == 1) == width * height - mines) {
            plot.flag(mine.col, height + 1 - mine.row)
            gameover("You win!\n")
            repeat{
              l = locator(1)
              x = l$x
              y = l$y
              if(x>42.3 & x<58 & y>12 & y<27){closeit()}
            }
          }
          return(ms)
          ## Zone numérotée
        } else {
          plot.num(plx, ply, current.mat)
          if (sum(ms == 1) == width * height - mines -1) {
            plot.flag(mine.col, height + 1 - mine.row)
            gameover("You win!\n")
            repeat{
              l = locator(1)
              x = l$x
              y = l$y
              if(x>42.3 & x<58 & y>12 & y<27){closeit()}
            }
          }
          ms[height + 1 - ply, plx] <- 1
          return(ms)
        }
        ## Zone ou drapeau testé - aucune action
      } else {
        return(ms)
      }
    }
    ## Bouton droit : 
    if (buttons == 2) {
      ## Zone vide
      if (current.status == 0) {
        ms[height + 1 - ply, plx] <- 2
        plot.flag(plx, ply)
        return(ms)
        ## Flag
      } else if (current.status == 2) {
        ms[height + 1 - ply, plx] <- 0
        plot.grid(plx, ply)
        return(ms)
        ## Zone numérotée -- aucune action
      } else {
        return(ms)
      }
    }
    return(ms)
  }
  
  while (TRUE) {
    if (length(mat.status) == 1) break
    mat.status <- getGraphicsEvent(prompt = "", onMouseDown = mousedown)
  }
}
# Fonction de fermeture sans retour d’erreur
closeit <- function() {
  graphics.off()
  return()
}
#function pour lire le résultat .
result <- function(a) {
  a <- as.character(a)
  list(a=a)
}

#'Fonctions de retour d’information pour la réponse au redémarrage
answer <- function (a)  {
  ans <- result(a)
  Check <- c("YES", "NO")
  if (is.null(ans$a)) {
    message("That's not an answer \n Type Y or N")
  }
  ans.feed <- match.arg(ans$a, Check)
  switch(ans.feed,
         Y = restart(),
         N = graphics.off()
  )
  return()
}

#`Fin du jeu
gameover = function(reslt){
  n = 100
  plot(1:n, type = "n", xlim = c(1, n), axes = FALSE, xlab = "",
       ylab = "", bty = "o", lab = c(n, n, 1))
  text(50,80,label=reslt,cex=3)
  text(50,20,label="Quit",cex=2,col=2)
  rect(42.3,12,58,27)
}