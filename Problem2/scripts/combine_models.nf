// Load models from pickle file and combine all model results
process combine_models {
    input:
    path model_dir

    output:
    file "combined_models.csv"

    script:
    """
    python -c "
    import pandas as pd
    import joblib
    import glob
    import os

    # List all .pkl files in the model directory so we can get the model file paths.
    model_files = glob.glob(os.path.join('${model_dir}', '*.pkl'))
    
    # Create empty list to append all model results to.
    results = []

    for model_file in model_files:
        # Load the model.
        model = joblib.load(model_file)

        # Get model results: coefficient, intercepts, species info.
        coef = model.coef_[0]
        intercept = model.intercept_
        species = os.path.splitext(os.path.basename(model_file))[0].replace('model_', '')
        results.append({'species': species, 'coef': coef.tolist(), 'intercept': intercept})

    # Create a dataframe of model outputs.
    models_out = pd.DataFrame(results)
    # Write output to csv.
    models_out.to_csv('combined_models.csv', index = False)
    "
    """
}
