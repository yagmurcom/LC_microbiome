
##Will plot beta diversity for all cohort. 
pcoa_all <- cmdscale(BC_T1, k = 2, eig = TRUE)
pcoa_coords <- as.data.frame(pcoa_all$points)
colnames(pcoa_coords) <- c("PC1", "PC2")
pcoa_eigenvals <- pcoa_all$eig / sum(abs(pcoa_all$eig))

clin_meta$comparison_three <- as.factor(clin_meta$comparison_three)

Ord <- data.frame(PC1 = pcoa_coords[,1], PC2 = pcoa_coords[,2], Study_Group =clin_meta$comparison_three)
group_order <- c( "1", "2", "3")
group_labels <- c( "SARS-CoV-2 negative", "Non-LC", "LC")
Ord$Study_Group <- factor(Ord$Study_Group, levels = group_order, labels = group_labels)
centroid_data <- aggregate(cbind(PC1, PC2) ~ Study_Group, data = Ord, FUN = mean)
merged_data <- merge(Ord, centroid_data, by = "Study_Group", suffixes = c("", "_centroid"))
merged_data$Study_Group

PCOA_plot_BC <- ggplot(merged_data, aes(x = PC1, y = PC2, color = Study_Group, shape = Study_Group)) +
  geom_point(
    size = 3.5,
    alpha = ifelse(merged_data$Study_Group == "SARS-CoV-2 negative", 0.7,
                   ifelse(merged_data$Study_Group == "Non-LC", 0.7, 0.9))
  ) +
  geom_segment(
    aes(xend = PC1_centroid, yend = PC2_centroid),
    size = 0.1,
    alpha = ifelse(merged_data$Study_Group == "SARS-CoV-2 negative", 0.7,
                   ifelse(merged_data$Study_Group == "Non-LC", 0.7, 0.9))
  ) +
  geom_point(
    data = centroid_data,
    aes(x = PC1, y = PC2),
    color = "black",
    size  = 4
  ) +
  scale_shape_manual(
    values = c("SARS-CoV-2 negative" = 18, "Non-LC" = 16, "LC" = 16),
    guide  = FALSE,
    name   = "Cohort"
  ) +
  scale_color_manual(
    values = c("SARS-CoV-2 negative" = "#C0C0C0", "Non-LC" = "#0066CC", "LC" = "#99004C"),
    name   = "Cohort"
  ) +
  labs(
    x = paste0("PC1 (", round(pcoa_eigenvals[1] * 100, 1), "%)"),
    y = paste0("PC2 (", round(pcoa_eigenvals[2] * 100, 1), "%)")
  ) +
  theme_minimal() +
  theme(
    axis.title      = element_text(color = "black", size = 22, face = "bold"),
    axis.text       = element_text(color = "black", size = 20),
    axis.line       = element_line(color = "black", linewidth = 1),
    axis.ticks      = element_line(linewidth = 1),
    panel.grid      = element_blank(),
    panel.background = element_blank()
  ) +
  annotate("text", x = -0.25, y = -0.30,
           label = expression(paste("R"^2, "=0.004")),
           size  = 7, color = "black", hjust = 0) +
  annotate("text", x = -0.25, y = -0.35,
           label = "P<0.001",
           size  = 7, color = "black", hjust = 0) +
  scale_x_continuous(
    breaks = seq(-0.25, 0.55, 0.1),
    limits = c(-0.25, 0.55),
    labels = function(x) sprintf("%.1f", x)
  ) +
  scale_y_continuous(
    breaks = seq(-0.35, 0.35, 0.1),
    limits = c(-0.35, 0.35),
    labels = function(x) sprintf("%.1f", x)
  ) +
  ggside::geom_xsideboxplot(
    aes(y = Study_Group, fill = Study_Group, color = "black"),
    orientation  = "y",
    show.legend  = FALSE
  ) +
  ggside::scale_ysidex_discrete(labels = FALSE) +
  ggside::geom_ysideboxplot(
    aes(x = Study_Group, fill = Study_Group, color = "black"),
    orientation  = "x",
    show.legend  = FALSE
  ) +
  ggside::scale_xsidey_discrete(labels = FALSE) +
  scale_fill_manual(
    values = c("SARS-CoV-2 negative" = "#C0C0C0", "Non-LC" = "#0066CC", "LC" = "#99004C"),
    name   = "Cohort"
  ) +
  ggside::theme_ggside_void() +
  theme(
    legend.position = NULL,
    legend.title    = element_text(size = 20),
    legend.text     = element_text(size = 20)
  ) 

PCOA_plot_BC
