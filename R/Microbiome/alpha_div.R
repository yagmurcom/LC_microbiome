
#compute alpha diversity and compare study groups. Will use rarefied file at species level. Looked at two indices (Choa1 and Shannon)
set.seed(123)
measures=c('Chao1', 'Shannon')

otu_table <- otu_table(phylo_s.rff_all, taxa_are_rows = FALSE)  
alphadiversity <- estimate_richness(otu_table, measures = measures)

chao1 <- alphadiversity$Chao1 
shannon <- alphadiversity$Shannon 

p_shannon <- aov(shannon ~ clin_meta$comparison_three)
p_chao1 <- aov(chao1 ~ clin_meta$comparison_three) 

TukeyHSD(chao1 ~ comparison_three,
         data=clin_meta)

TukeyHSD(shannon ~ comparison_three,
         data=clin_meta)
