def create_model_microbiome(neurons=64, dropout_rate=0.5):
    model = tf.keras.Sequential([
        tf.keras.layers.Dense(neurons, activation='relu', input_shape=(X_combined_scaled.shape[1],)),
        tf.keras.layers.Dropout(dropout_rate),
        tf.keras.layers.Dense(neurons // 2, activation='relu'),
        tf.keras.layers.Dropout(dropout_rate),
        tf.keras.layers.Dense(1, activation='sigmoid')  
    ])
    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['AUC'])
    return model

random_seed_trials = 10
n_splits = 5
dropout_rates = [0, 0.2, 0.4, 0.6]

best_params_list = []
top_features_shap_values_list = []
fold_counter = 0  

for i in range(random_seed_trials):
    outer_cv = StratifiedKFold(n_splits=n_splits, shuffle=True, random_state=i)
    for train_index, test_index in outer_cv.split(X_combined_scaled, y):
        fold_counter += 1
        X_train = X_combined_scaled.iloc[train_index]
        X_test  = X_combined_scaled.iloc[test_index]
        y_train = y.iloc[train_index]
        y_test  = y.iloc[test_index]
        best_accuracy = 0.0
        best_dropout_rate = None
        for dr in dropout_rates:
            model_can = create_model_microbiome(dropout_rate=dr)
            model_can.fit(X_train, y_train, epochs=50, verbose=0, class_weight=class_weights_dict, callbacks=[callback])
            _, accuracy = model_can.evaluate(X_test, y_test, verbose=0)
            if accuracy > best_accuracy:
                best_accuracy = accuracy
                best_dropout_rate = dr
        model_fin = create_model_microbiome(dropout_rate=best_dropout_rate)
        model_fin.fit(X_train, y_train, epochs=50, verbose=0, class_weight=class_weights_dict, callbacks=[callback])
        explainer = shap.GradientExplainer(model_fin, X_train.values)
        shap_values = explainer.shap_values(X_test.values)[0]  
        mean_abs_shap = np.abs(shap_values).mean(axis=0) 
        shap_feature_importance = pd.DataFrame({'feature': X_train.columns,'shap_importance': mean_abs_shap
                                               }).sort_values(by='shap_importance', ascending=False)
        top_20_features = shap_feature_importance.head(20).copy()
        best_params_list.append({'trial_seed': i, 'outer_fold': fold_counter, 'dropout_rate': best_dropout_rate})
        top_features_shap_values_list.append({'trial_seed': i,  'outer_fold': fold_counter,'dropout_rate': best_dropout_rate, 'top_20_features': top_20_features
        })

print("Best dropout rates per outer fold:")
for bp in best_params_list:
    print(bp)

for record in top_features_shap_values_list:
    print(f"\nTrial={record['trial_seed']} | OuterFold={record['outer_fold']} | Best dropout={record['dropout_rate']}")
    print("Top 20 features by mean absolute SHAP:")
    print(record['top_20_features'])
