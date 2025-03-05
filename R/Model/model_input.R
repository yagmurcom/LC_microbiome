# Subset data (will remove SARS-CoV-2 negatives to process the data for model) -- comparison_three =1 is the negatives. 
# Kit column corresponds to the sample_ID in unprocessed fasta files. In models, used only the timepoint-1 samples. 
# Clin_meta is the metadata file; will subset this as well to remove negatives.

model_labels_positives <- clin_meta$kit[clin_meta$comparison_three == 2|clin_meta$comparison_three == 3]
rownames(clin_meta) <- clin_meta$kit

phylo_s.rff.ra_model_pos <- phylo_s.rff.ra %>%
  .[rownames(.) %in% model_labels_positives, ] %>%
  .[, colSums(.) != 0] 

phylo_g.rff.ra_model_pos <- phylo_g.rff.ra %>%
  .[rownames(.) %in% model_labels_positives, ] %>%
  .[, colSums(.) != 0] 

clin_meta_positive <- clin_meta %>%
  .[rownames(.) %in% model_labels_positives, ] 

#Reorder on rownames
phylo_s.rff.ra_model_pos <- phylo_s.rff.ra_model_pos[order(rownames(phylo_s.rff.ra_model_pos)), ]
phylo_g.rff.ra_model_pos <- phylo_g.rff.ra_model_pos[order(rownames(phylo_g.rff.ra_model_pos)), ]
clin_meta_positive <- clin_meta_positive[order(rownames(clin_meta_positive)), ]

#Make sure that these are aligned
test_match_order(row.names(phylo_s.rff.ra_model_pos),clin_meta_positive$kit)
test_match_order(row.names(phylo_s.rff.ra_model_pos),row.names(phylo_g.rff.ra_model_pos))
test_match_order(row.names(phylo_g.rff.ra_model_pos),clin_meta_positive$kit)

phylo_s.rff.ra_model_pos <- as.data.frame(phylo_s.rff.ra_model_pos)
phylo_g.rff.ra_model_pos <- as.data.frame(phylo_g.rff.ra_model_pos)

#Define the variables in clin_meta file to merge with the microbiome data.

clinical_var <- c(
  "age", "dis_sev", "sex", "CCI_score", "BMI", "fully_vac_index", 
  "thirty_day_antibiotic", "immunosuppression", "comparison_three", 
  "DM", "rend", "cpd", "ibd", "metacanc", "mi", "msld", "transplant_hx", 
  "rheumd", "steroids", "cancer_chemo", "calcineurin_inh", "antimetabolites", 
  "biologics", "antiproliferative_agents", "other", "ppi"
)

phylo_s.rff.ra_model_pos[clinical_cols] <- clin_meta_positive[clinical_cols]
phylo_g.rff.ra_model_pos[clinical_cols] <- clin_meta_positive[clinical_cols]

