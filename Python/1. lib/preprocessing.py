df_s = pd.read_csv("df_s_model_rarefied_pos.csv", index_col=0)
df_s['comparison_three']
df_s['comparison_three'] = df_s['comparison_three'].replace({2: 0, 3: 1})#Relabeling, will label LC patients with 1 and no LC patients with 0. 
df_s['sex'] = df_s['sex'].replace({2: 1, 1: 0})
labels = df_s.pop("comparison_three")
#Last 25 variables are clinical covariates.
clin_covariates = df_s.columns[-25:].tolist()

df_species = df_s.drop(columns=clin_covariates)
df_meta = df_s[clin_covariates]

#Look at the missing data 
print(df_meta.isna().any())

df_meta_encoded = pd.get_dummies(df_meta, columns=['ppi','sex','immunosuppression',"fully_vac_index", 'dis_sev', 'DM', 'rend', 'cpd', 'ibd', 'metacanc', 'mi', 'msld', 'transplant_hx','rheumd', 'steroids', 'cancer_chemo', 'calcineurin_inh', 'antimetabolites', 'biologics', 'antiproliferative_agents', 'other'], drop_first=True)

import numpy as np
X_meta = df_meta_encoded
y = labels
scaler = MinMaxScaler()
X_scaled = scaler.fit_transform(X_meta)

#Train test split
X_train, X_test, y_train, y_test = train_test_split(X_scaled , y, test_size=0.3, random_state=42,stratify=y)

#Calculate the class weight and reweigh
unique_classes = np.unique(y_train)
class_weights = compute_class_weight('balanced', classes=unique_classes, y=y_train.values.reshape(-1))
class_weights_dict = dict(enumerate(class_weights))


