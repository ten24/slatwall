In this directory you can place custom JSON files that get used for validation.

For example if you would like to add additional validations on accounts,
you can drop a file in here called Account.JSON and require company for example like this:

{
	"company":[{required=true}]
}

Please reference any of the validations inside of /model/validation for examples to format your validations.