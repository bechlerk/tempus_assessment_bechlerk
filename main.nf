// Set DSL2 syntax for Nextflow pipeline
nextflow.enable.dsl = 2

// Include 3 separate nextflow steps for 1) slicing the data, 2) fitting the regression model, and 3) combining the results
include { slice_data } from './scripts/slice_data.nf'
include { fit_model } from './scripts/fit_model.nf'
include { combine_models } from './scripts/combine_models.nf'

// Define workflow
workflow {
    // Step 1: Load and slice data
    slice_output = slice_data()

    // Step 2: Fit regression models in parallel to each sliced dataset
    // Create a channel that holds all the file paths
    csv_files = Channel.fromPath('./sliced_data/*.csv')
    model_output = csv_files | fit_model

    // Step 3: Combine all model results into one table
    combined_results = combine_models(model_output)
    // Output results table
    combined_results
}