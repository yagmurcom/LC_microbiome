##Extracting the impactful features. Will repeat the model that incorporated both clinical variables and species level microbiome composition. 
#Use the same parameters, except extract the features with highest absolute coef from each optimized outer fold cv iteration.

random_seed_trials = 10
nested_scores = np.zeros(random_seed_trials)

best_params_list = []
top_features_coefficients_list = []

Logit_unfitted = LogisticRegression(class_weight=class_weights_dict,  random_state=42, solver='liblinear')
param_grid = {'C': np.logspace(-3, 1, 100)}
fold_counter = 0 

for seed in range(random_seed_trials):
    outer_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=seed)
    outer_scores = []     
    for train_index, test_index in outer_cv.split(X_combined_scaled, y):
        fold_counter += 1
        X_train, X_test = X_combined_scaled.iloc[train_index], X_combined_scaled.iloc[test_index]
        y_train, y_test = y.iloc[train_index], y.iloc[test_index]
        clf = GridSearchCV(estimator=Logit_unfitted, param_grid=param_grid, scoring='accuracy',cv=5)
        clf.fit(X_train, y_train)
        best_model = clf.best_estimator_
        best_params = clf.best_params_
        coefficients = best_model.coef_[0]
        feature_names = X_train.columns
        coeff_df = pd.DataFrame({'feature': feature_names, 'coefs': coefficients})
        coeff_df_sorted = coeff_df.reindex(coeff_df['coefs'].abs().sort_values(ascending=False).index)
        top_20_features = coeff_df_sorted.head(20)
        best_params_list.append(best_params)
        top_features_coefficients_list.append({'trial_seed': seed, 'outer_fold': fold_counter,'best_params': best_params,'top_20_features': top_20_features })

for record in top_features_coefficients_list:
    print(f"\nTrial seed={record['trial_seed']}, Outer fold={record['outer_fold']}")
    print(f"Best params: {record['best_params']}")
    print("Top 20 features:\n", record['top_20_features'])
