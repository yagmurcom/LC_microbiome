
##Create boxplots for alpha diversity.
# Create a new data frame for plotting
plot_data <- data.frame(
  Condition = clin_meta$comparison_three,
  Shannon = shannon,
  Chao1 = chao1
)

# Define colors for the labels
group_order <- c( "3", "1", "2")
group_labels <- c( "LC","SARS-CoV-2 negative", "Non-LC" )

plot_data$Condition <- factor(plot_data$Condition, levels = group_order, labels = group_labels)

label_colors <- c( "LC" = "#99004C","SARS-CoV-2 negative" = "#C0C0C0" , "Non-LC" = "#0066CC")

p1 <-  ggplot(plot_data, aes(x = Condition, y = Chao1)) +
 geom_boxplot(fill = NA,  stat = "boxplot", outlier.shape = NA,  color=label_colors) +
  stat_boxplot(geom ='errorbar', color=label_colors, width=0.25, coef=1.5,guide = FALSE) + 
  geom_jitter(aes(color = Condition), size=2.5, width = 0.2, alpha = 0.6,guide = FALSE) +
  scale_color_manual(values = label_colors,guide = FALSE) +
  labs(x= "Cohort", y = "Chao1") +
  theme_minimal() +
  theme( axis.text.x = element_text(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
     axis.line.x = element_line(color = "black", size = 1),
    axis.line.y = element_line(color = "black", size =1),
    axis.text = element_text(size = 18,color = "black"),
    axis.title = element_text(size = 20,color = "black",face = "bold"))+
  ylim(500,2100)+
   annotate("text", x = 1.5, y = 2050, label = paste0('**'), parse = F, size =11) +
  theme(axis.ticks = element_line(linewidth = 1))+
  geom_segment(aes(x = 1, xend = 1.9, y = 1990, yend =1990),
               color = "black", size = 1) +theme(axis.ticks = element_line(linewidth = 1))+
  annotate("text", x = 2.5, y = 2050, label = paste0("**"),parse = F,size = 11) +
  theme(axis.ticks = element_line(linewidth = 1))+
  geom_segment(aes(x = 2.1, xend = 3, y = 1990, yend =1990),
               color = "black", size = 1)+ theme(axis.ticks = element_line(linewidth = 1))+  
scale_x_discrete(labels = function(x) gsub("negative", "\nnegative", x))

p2 <- ggplot(plot_data, aes(x = Condition, y = Shannon)) +
  geom_boxplot(fill = NA,  stat = "boxplot", outlier.shape = NA,  color=label_colors) +
  stat_boxplot(geom ='errorbar', color=label_colors, width=0.25, coef=1.5) + 
  geom_jitter(aes(color = Condition), width = 0.2, size=2.5,alpha = 0.6) +
  scale_color_manual(values = label_colors) +
  labs( x= "Cohort", y = "Shannon Diversity") +
  theme_minimal() +
 theme( axis.text.x = element_text(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(color = "black"),
     axis.line.x = element_line(color = "black", size = 1),
    axis.line.y = element_line(color = "black", size =1),
    axis.text = element_text(size = 18,color = "black"),
    axis.title = element_text(size = 20,color = "black",face = "bold"))+
  guides(fill = FALSE, color = FALSE) +
  ylim(0,6)+theme(axis.ticks = element_line(linewidth = 1))+ 
  geom_segment(aes(x = 1, xend = 2.9, y = 5.5, yend =5.5),
               color = "black", size = 1) +theme(axis.ticks = element_line(linewidth = 1))+
  annotate("text", x = 2, y = 5.9, label = paste0("ns"),parse = F,size = 11) +
  scale_x_discrete(labels = function(x) gsub("negative", "\nnegative", x))


png("./figures/alpha_chao_microbiome.png", width = 6, height =5, units = "in", res = 600)
p1
dev.off()

png("./figures/alpha_shannon_microbiome.png", width = 6, height =5, units = "in", res = 600)
p2
dev.off()

