#Will perform PERMANOVA-based analysis for beta diversity using Bray Curtis dissimilarities. 
# Calculate Bray-Curtis dissimilarity in T1 samples among three study cohorts (LC, non-LC and SARS-CoV-2 negatives)

set.seed(1)
BC_T1 <- vegdist(phylo_s.rff_all, method = "bray")
my_model_perm <- adonis3(BC_T1 ~ age+sex+CCI_score+cpd+thirty_day_antibiotic+comparison_three, data = clin_meta, permutations = 999)$aov.tab

#Inspect ANOVA table 
my_model_perm

#Look at the posthoc analysis. It appears to be LC and non-LC cohorts have very different microbial composition during acute infection. 
my_model_perm_pairwise <- pairwise.perm.manova(BC_T1, clin_meta$comparison_three, nperm=999, progress= TRUE, p.method="fdr", F=TRUE, R2=TRUE)

my_model_perm_pairwise

################
#Will now compute BC matrix in subsetted cohort including only SARS-CoV-2 positive cohort. This was subsetted in earlier code done for model input. Here, will compare LC and non-LC after adjusting for clinical confounders. 
#Looking at T1 samples again. "kit" column corresponds to sample_ID of T1 samples in fasta files for each participants. 

set.seed(1)
BC_positives <- vegdist(phylo_s.rff.ra_model_pos, method = "bray")
test_match_order(rownames(phylo_s.rff.ra_model_pos),clin_meta_positive$kit)

my_model_perm_positives <- adonis3(BC_positives ~ sex+CCI_score+cpd+comparison_three, data = clin_meta_positive, permutations = 999)$aov.tab
my_model_perm_positives
