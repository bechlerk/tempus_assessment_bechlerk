// Fit regression model on each slice in parallel
process fit_model {
    input:
    path sliced_data

    output:
    file 'model_*.pkl'

    publishDir './model', mode: 'copy'

    script:
    """
    python -c "
    import pandas as pd
    from sklearn.linear_model import LinearRegression
    import joblib
    import os

    # Load sliced data.
    sliced_data = pd.read_csv('${sliced_data}')

    # Segment to features and target and drop NAs for linear regression.
    sliced_data = sliced_data[['bill_length_mm', 'flipper_length_mm']]
    sliced_data_na_rm = sliced_data.dropna()

    # Define features and target.
    X = sliced_data_na_rm[['bill_length_mm']]
    y = sliced_data_na_rm['flipper_length_mm']

    # Fit a regression model.
    lr_model = LinearRegression().fit(X, y)
    
    # Save the model as a pickle file.
    file_name = 'model_${sliced_data.baseName}.pkl'
    joblib.dump(lr_model, file_name)
    "
    """
}
