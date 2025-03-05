#Upload the logit output csv file. The file is 1001x2. Two columns include feature name and coef value. Each row is a feature that appeared in top 20 features with highest abs(coef) in 50 nested cv runs. 

logit<- read_csv("logit_output.csv")

logit<- logit%>%
  filter(!is.na(feature))

logit <- logit %>%
  group_by(feature) %>%
  mutate(measurement_id = row_number()) %>%
  ungroup()

df_wide_logit <- pivot_wider(logit,
                       names_from = feature,
                       values_from = coef,
                       names_prefix = "",
                       id_cols = measurement_id)

counts_subtracted_logit <- colSums(!is.na(df_wide_logit))

ordered_counts_logit <- sort(counts_subtracted_logit, decreasing = TRUE)

result_df_logit <- data.frame(column_name = names(ordered_counts_logit), counts = ordered_counts_logit)

print(result_df_logit)

result_df_logit <- result_df_logit[2:100,]

appearances_logit <- result_df_logit[["counts"]]

n_runs <- 50
p_x <- 0.0035
lambda_x <- n_runs*p_x

appearances_logit <- result_df_logit[["counts"]]


poisson_pmf <- function(x, lambda) {
  probability <- (lambda^x * exp(-lambda)) / factorial(x)
  return(probability)
}

poisson_pmf(appearances_logit, lambda_x)

z_score_logit <- (appearances_logit - lambda_x) / sqrt(lambda_x)
z_score_logit <- as.data.frame(z_score_logit)

rownames(z_score_logit) <- rownames(result_df_logit)
