#Only change from the nn_microbiome is the input data. We now use the both microbiome at species level and clinical variables combined. 

X_combined = pd.concat([df_meta_encoded, df_species], axis=1)
scaler = MinMaxScaler()
X_combined_scaled = scaler.fit_transform(X_combined)
X_combined_scaled = pd.DataFrame(X_combined_scaled)
X_combined_scaled.columns = X_combined.columns
X_combined_scaled

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

model = KerasClassifier(model=create_model_microbiome, epochs=50, verbose=0,class_weight=class_weights_dict,callbacks=[callback])

param_grid_microbiome = {
    'model__dropout_rate': [0, 0.2, 0.4, 0.6]}

random_seed_trials = 10 

nested_scores_microbiome_clinical_accuracy = np.zeros((random_seed_trials,5))

for i in range(random_seed_trials):
    inner_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    outer_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=i)
    grid_search = GridSearchCV(model, param_grid_microbiome, cv=inner_cv, scoring='accuracy')
    cv_scores = cross_val_score(grid_search, X= X_combined_scaled, y=y, cv=outer_cv, scoring='accuracy')
    nested_scores_microbiome_clinical_accuracy[i] = cv_scores
    print(f"Trial {i+1} - accuracy scores: {cv_scores}")
