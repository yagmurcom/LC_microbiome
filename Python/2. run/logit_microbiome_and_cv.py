X_combined = pd.concat([X_meta, df_species], axis=1)

scaler = MinMaxScaler()
X_combined_scaled = scaler.fit_transform(X_combined)
X_combined_scaled = pd.DataFrame(X_combined_scaled)
X_combined_scaled.columns = X_combined.columns

nested_scores_microbiome_clinical_accuracy = np.zeros((random_seed_trials,5))
for i in range(random_seed_trials):
    inner_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    outer_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    logit_unfitted = LogisticRegression(class_weight=class_weights_dict, random_state=42, solver='liblinear')
    grid_search = GridSearchCV(logit_unfitted, param_grid, cv=inner_cv, scoring='accuracy')
    cv_scores = cross_val_score(grid_search, X=X_combined_scaled, y=y, cv=outer_cv, scoring='accuracy')
    nested_scores_microbiome_clinical_accuracy[i] = cv_scores
    print(f"Trial {i+1} - accuracy scores: {cv_scores}")
