/* Write a SQL query to aggregate all transcript TPM values to a gene-level log2(TPM+1) output
for every unique gene in every unique patient.
Ensure that your query handles cases where there may be a single transcript for a given
gene and ensure that your query handles cases where there may be a null value(s) for
transcript_tpm. This is done by using COALESCE in the SELECT statement.
 */
SELECT
    t.patient_id,
    egm.gene_symbol,
    LOG(2, SUM(COALESCE(t.transcript_tpm, 0)) + 1) AS log2_tpm
FROM
    transcripts t
    JOIN transcript_gene_map tgm ON t.transcript_code = tgm.transcript_code
    JOIN ensembl_gene_map egm ON tgm.ensembl_gene_id = egm.ensembl_gene_id
GROUP BY
    t.patient_id,
    egm.gene_symbol
ORDER BY
    t.patient_id,
    egm.gene_symbol;

