Hi!

## Found an issue?

If you have detected an issue in _recount-brain_, please provide the following information:

* The version of the _recount_ R package you used. You can obtain that using `packageVersion('recount')`
* The `add_metadata()` call you used. For example, `add_metadata(source = 'recount_brain_v1')`.
* The sample ID(s) and details about the problem you have identified.

## Curated a new brain dataset?

If you have curated another dataset and wish to contribute it to `recount-brain`, please verify that you have a table with all the current columns in `recount-brain`. Maybe some of the biological phenotype or experimental condition variables were not recorded in the new dataset, so it's ok to have `NA` values. Your contributed table, say `my_data`, should be easy to merge with `recount-brain` using code like this:

```R
## Use the latest recount-brain version available
recount_brain <- recount::add_metadata(source = 'recount_brain_v2')
rbind(recount_brain, my_data)
```

Please share with us your data file so we can add it to the `recount-brain` repository. We will require information on how you extracted the information using the format in [metadata_reproducibility](metadata_reproducibility/README.md)

We will also need the contact information (name, email, website, address, optionally twitter) for the person responsible for the new data.

## Curated another tissue?

If you have curated another tissue and wish to have your data available via `recount::add_metadata()`, please get in touch with us via email. We will likely need to have a meeting to go over the variables you decided to include in your table. Whenever possible, please re-use the variable names present in `recount-brain` if they can be applied to the new tissue.

Thank you!
The _recount-brain_ team
