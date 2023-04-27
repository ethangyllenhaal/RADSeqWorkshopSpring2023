if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("LEA")

# Load in additional tools for sNMF
source("http://membres-timc.imag.fr/Olivier.Francois/Conversion.R")
source("http://membres-timc.imag.fr/Olivier.Francois/POPSutilities.R")
# Load main library, LEA
library(LEA)
library("RColorBrewer")
library(viridis)

setwd('D:/Documents/Projects/PachyHybrid/sNMF')


BlackYellow <- colorRampPalette(c("yellow", "black"))

# Plotting function used to plot sNMF output.
# Input is sNMF object, the k value, and optionally an array of colors (has default of 10).
plot_sNMF <- function(input, k_val, colors = BlackYellow(k_val+1)){
  # picks best run best on cross entropy
  best_run <- which.min(cross.entropy(input, K = k_val))
  # makes q matrix of ancestry coeffs
  q_matrix <- Q(input, K = k_val, run = best_run)
  # plots the output, space makes blank between indivs
  barplot(t(q_matrix), col = colors, border = NA, space = 0.25, xlab = "Individuals", ylab = "Admixture coefficients", horiz=FALSE)
}

vcf2geno("pachy_nosingle_vanua75.vcf", output = "D:/Documents/Projects/PachyHybrid/sNMF/vanua.geno")
vanua_snmf = snmf("D:/Documents/Projects/PachyHybrid/sNMF/vanua.geno", ploidy=2, 
                  K = 1:5, alpha = 10, project = "new", entropy = T, repetitions = 50)

# plot to decide optimal K, although don't put too much stock in k values
plot(vanua_snmf, cex = 1.2, col = "lightblue", pch = 19)

# here I override the default colors
par(mfrow=c(2,1), mar=c(0,2,0,0), oma=c(1,2,1,0))
plot_sNMF(vanua_snmf, 2, c("yellow", "black"))
plot_sNMF(vanua_snmf, 3, c("black", "yellow", "yellow4"))
plot_sNMF(vanua_snmf, 4)
plot_sNMF(vanua_snmf, 5)
