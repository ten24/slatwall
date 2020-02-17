<cfscript>
	var scriptHasErrors = false;
	
	try {
		
		
		// module-header-content-int
		var query = new Query();
		var classExtends = query.execute( sql = "SELECT subTypeID FROM tclassextend WHERE subType = 'module-header-content-int'", returntype = 'array' ).getResult();

		var sql = '';
		arrayEach( classExtends, function( classExtend ) {
			var subTypeID = classExtend.subTypeID;
			
			var query = new Query();
			var extendSets = query.execute( sql = "SELECT extendSetID, siteID FROM tclassextendsets WHERE subTypeID = '#subTypeID#'", returntype = 'array' ).getResult();
			
			arrayEach( extendSets, function( extendSet ) {
				var orderno = 10;
				
				var colorsOptionList = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
				var colorsOptionLabelList = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
	
				// Create Text Color Option
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
				sql &= ') VALUES (';
				sql &= "'#extendSet.extendSetID#', '#extendSet.siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#colorsOptionList#', '#colorsOptionLabelList#'";
				sql &= "); ";
					
				orderno++;
				
				colorsOptionList = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''White'' )[/mura]";
				colorsOptionLabelList = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''White'' )[/mura]";
				
				// Create Background Color Option
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
				sql &= ') VALUES (';
				sql &= "'#extendSet.extendSetID#', '#extendSet.siteID#', 'backgroundColor', 'Background Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#colorsOptionList#', '#colorsOptionLabelList#'";
				sql &= "); ";
					
				orderno++;
			});
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
