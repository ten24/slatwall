<cfscript>
	var scriptHasErrors = false;
	
	try {
		
		// Update extended set name to Slider Options to make more sense.
		queryExecute("UPDATE tclassextendsets SET name = 'Slider Options' WHERE name = 'Optional Button'");
		
		var query = new Query();
		var extendSets = query.execute( sql = "SELECT extendSetID, siteID FROM tclassextendsets WHERE name = 'Slider Options'", returntype = 'array' ).getResult();
		
		var sql = '';
		
		arrayEach( extendSets, function( extendSet ) {
			var orderno = 10;
				
			// Create Text Alignment Field
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSet.extendSetID#', '#extendSet.siteID#', 'textAlignment', 'Text Alignment', 'SelectBox', #orderno#, 1, 'false', 0, 'left', 'left^center^right', 'Left^Center^Right'";
			sql &= "); ";
				
			orderno++;

			// Create Text Color Option
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSet.extendSetID#', '#extendSet.siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, 'left', '##fff^##000^##1C1932^##2E2A4A^##ECECEC', 'White^Black^Deep Blue^Blue^Light Grey'";
			sql &= "); ";
				
			orderno++;
			
		});
		
		queryExecute( sql );
		
	} catch(e) {
    	scriptHasErrors = true;
	}
	
	if ( scriptHasErrors ) {
		writeLog( file = 'Slatwall', text = 'ERROR: Update Script - Add slider fields failed.' );
	} else {
		writeLog( file = 'Slatwall', text = 'Update Script - Add slider fields.' );
	}
</cfscript>
