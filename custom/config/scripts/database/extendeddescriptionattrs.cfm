<cfscript>
	var scriptHasErrors = false;
	
	try {
		var attributeCodes = [
			'extendedDescriptionLeft',
			'extendedDescriptionRight',
		];
		
		for ( var attributeCode in attributeCodes ) {
			queryExecute("UPDATE swattribute SET attributeInputType = 'wysiwyg' WHERE attributeCode = '#attributeCode#' LIMIT 1");
			queryExecute("ALTER TABLE swproduct MODIFY COLUMN #attributeCode# VARCHAR(4000)");
		}
	} catch(e) {
    	scriptHasErrors = true;
	}
	
	if ( scriptHasErrors ) {
		writeLog( file = 'Slatwall', text = 'ERROR: Update Script - Extended product description attributes failed.' );
	} else {
		writeLog( file = 'Slatwall', text = 'Update Script - Extended product description attributes updated.' );
	}
</cfscript>
