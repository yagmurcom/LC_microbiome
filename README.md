# LongCovid
The project examines the role of human gut microbiome in long COVID. 
Details about the project will be added here upon publication. Preprint of the study can be found at https://www.biorxiv.org/content/10.1101/2024.12.10.626852v1

## **Repository Structure**
The repository is organized into two main sections:

Python/ → Scripts for predictive modeling and feature analysis.

R/ → Scripts for microbiome data processing, comparative analysis, and input data generation for modeling.

## **Python folder (Python/)**
Contains scripts for building predictive models using nested cross-validation, as well as feature selection and preprocessing steps.

📂lib/ — Library imports & preprocessing
     lib_nn.py & lib_logit.py → Defines required Python libraries for predictive modeling. 

If these libraries are not  installed, use pip or conda to install them.

     Preprocessing.py → Loads and preprocesses microbiome and clinical data before modeling. 
     
 A reference script (in R/Model/) for generating CSV input files can be found in R/Model/model_input

📂 run/ — Model Training Scripts
  Scripts for training predictive models with nested cross-validation. 
       
Three main types of input data were used in these models:

1.  Clinical cariables only → Scripts ending with _cv.
       
2.  Microbiome data only → Scripts ending with _microbiome.
       
3.  Combined clinical & microbiome data → scripts ending with _microbiome_and_cv.
     
📂 output/ — Model Outputs & Feature Selection
 contains raw outputs from models, highlighting the 20 most influential features based on absolute coefficients 
 (logistic regression) or SHAP values (neural network).
     
 Features are extracted from the highest-performing outer-loop fold and repeated across 50 nested cross- 
 validation runs.

     features_logit.py → Extracts key features from logistic regression models.
     features_nn.py → Extracts key features from neural network models.

## **R Folder (R/)**
Contains scripts for microbiome data processing, statistical analysis, visualization, and model input preparation.

📂 Microbiome/ — Comparative analysis & visualization

Scripts for alpha and beta diversity analysis, differential abundance testing using ZicoSeq, and generating 
    
microbiome plots as described in the Methods section of the manuscript.

📂 Model/ — Data preparation for predictive models

Scripts used to generate input data tables for machine learning models.
    
Includes an R script for computing z-scores from the most impactful features used in model decision-making.

