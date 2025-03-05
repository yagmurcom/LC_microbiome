
#Hyperparameter tuning for the same "C" range for all models.
param_grid = {'C': np.logspace(-3, 1, 100)} 
print(param_grid) #Inspect to make sure they are distributed. 

#Repeat each model with random seeds 10 times. 
random_seed_trials = 10

# Nested CV to optimize on accuracy - scaled clinical variables only
nested_scores_clinical_accuracy = np.zeros((random_seed_trials ,5))

for i in range(random_seed_trials ):
    inner_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    outer_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    Logit_cv = LogisticRegression(class_weight=class_weights_dict, random_state=42, solver='liblinear')
    grid_search = GridSearchCV(Logit_cv, param_grid, cv=inner_cv, scoring='accuracy')
    cv_scores = cross_val_score(grid_search, X=X_scaled, y=y, cv=outer_cv, scoring='accuracy')
    nested_scores_clinical_accuracy[i, :] = cv_scores
    print(f"Trial {i+1} - Accuracy scores: {cv_scores}")

print("\nNested CV (scaled clinical variables) accuracy scores for all trials:")
print(nested_scores_clinical_accuracy)
