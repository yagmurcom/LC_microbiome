y = labels
X_species_no_zero = df_species.replace(0, np.finfo(float).eps)
log_X = np.log(X_species_no_zero)
row_means = log_X.mean(axis=1)
X_clr = log_X.subtract(row_means, axis=0)
X_clr = pd.DataFrame(X_clr, columns=df_species.columns)
X_clr_scaled = scaler.fit_transform(X_clr)

#Nested CV to optimize on accuracy - SCALED microbiome only
nested_scores_microbiome_accuracy = np.zeros((random_seed_trials,5))
for i in range(random_seed_trials):
    inner_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    outer_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    logit_unfitted = LogisticRegression(class_weight=class_weights_dict, random_state=42, solver='liblinear')
    grid_search = GridSearchCV(logit_unfitted, param_grid, cv=inner_cv, scoring='accuracy')
    cv_scores = cross_val_score(grid_search, X=X_clr_scaled, y=y, cv=outer_cv, scoring='accuracy')
    nested_scores_microbiome_accuracy[i] = cv_scores
    print(f"Trial {i+1} - accuracy scores: {cv_scores}")

print("\nnested_scores_microbiome_accuracy for all trials:")
print(nested_scores_microbiome_accuracy)

