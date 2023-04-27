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
vcf2geno("pachy_nosingle_graef90_sloppyNoOva.vcf", output = "D:/Documents/Projects/PachyHybrid/sNMF/graef.geno")
graef_snmf = snmf("D:/Documents/Projects/PachyHybrid/sNMF/graef.geno", ploidy=2, 
                   K = 1:6, alpha = 10, project = "new", entropy = T, repetitions = 10)

plot(graef_snmf, cex = 1.2, col = "lightblue", pch = 19)

par(mfrow=c(4,1), mar=c(0,2,1.5,0), oma=c(1,2,1,0))
plot_sNMF(graef_snmf, 2, c("yellow2", "#000000"))
plot_sNMF(graef_snmf, 3, c("yellow2", "#7F7F00", "#000000"))
plot_sNMF(graef_snmf, 4, c("#000000", "#AAAA00", "#555500", "yellow2"))
plot_sNMF(graef_snmf, 5, c("yellow2", "#7F7F00", "#BFBF00", "#3F3F00", "#000000"))
plot_sNMF(graef_snmf, 6)


vcf2geno("pachy_nosingle_vanua75.vcf", output = "D:/Documents/Projects/PachyHybrid/sNMF/vanua.geno")
vanua_snmf = snmf("D:/Documents/Projects/PachyHybrid/sNMF/vanua.geno", ploidy=2, 
                  K = 1:5, alpha = 10, project = "new", entropy = T, repetitions = 50)

plot(vanua_snmf, cex = 1.2, col = "lightblue", pch = 19)

par(mfrow=c(2,1), mar=c(0,2,0,0), oma=c(1,2,1,0))
plot_sNMF(vanua_snmf, 2, c("yellow", "black"))
plot_sNMF(vanua_snmf, 3, c("black", "yellow", "yellow4"))
plot_sNMF(vanua_snmf, 4)
plot_sNMF(vanua_snmf, 5)

vcf2geno("pachy_nosingle_graef90_limit4.vcf", output = "D:/Documents/Projects/PachyHybrid/sNMF/graef_limit4.geno")
limit4_snmf = snmf("D:/Documents/Projects/PachyHybrid/sNMF/graef_limit4.geno", ploidy=2, 
                  K = 1:6, alpha = 10, project = "new", entropy = T, repetitions = 50)

plot(limit4_snmf, cex = 1.2, col = "lightblue", pch = 19)

par(mfrow=c(4,1), mar=c(0,2,0,0), oma=c(1,2,1,0))
plot_sNMF(limit4_snmf, 2)
plot_sNMF(limit4_snmf, 3)
plot_sNMF(limit4_snmf, 4)
plot_sNMF(limit4_snmf, 5)
plot_sNMF(limit4_snmf, 6)

