// Slice data (from stock data set palmer penguins) and pass slices to next step
process slice_data {
    output:
    path "sliced_data_*.csv", emit: sliced_files

    publishDir './sliced_data', mode: 'copy' // Create a copy of dataset in assigned directory

    script:
    """
    python -c "
    import pandas as pd
    from palmerpenguins import load_penguins
    import os

    # Create the output directory if it doesn't exist
    os.makedirs('./sliced_data', exist_ok=True)

    # Load and slice dataset by a relevant variable.
    penguins = load_penguins()

    # Group by species, slice the data and write to separate csvs.
    for species, group in penguins.groupby('species'):
        group.to_csv(f'sliced_data_{species}.csv', index = False)
    "
    """
}