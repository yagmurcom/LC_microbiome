

random_seed_trials = 10 

nested_scores_microbiome_clinical_accuracy = np.zeros((random_seed_trials,5))

for i in range(random_seed_trials):
    inner_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    outer_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    grid_search = GridSearchCV(model, param_grid_microbiome, cv=inner_cv, scoring='accuracy')
    cv_scores = cross_val_score(grid_search, X= X_combined_scaled, y=y, cv=outer_cv, scoring='accuracy')
    nested_scores_microbiome_clinical_accuracy[i] = cv_scores
    print(f"Trial {i+1} - accuracy scores: {cv_scores}")
