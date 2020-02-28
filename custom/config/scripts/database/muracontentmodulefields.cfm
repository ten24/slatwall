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
		
		// Large Image
		var languageMap = {
			'': '',
			'_es_mx': ' (Spanish Mexico)',
			'_fr_ca': ' (French Canada)',
			'_pl_pl': ' (Polish Poland)',
			'_ga_ie': ' (Gaelic Ireland)',
		}
		
		var siteArray = [
			'default',
			'uk',
			'ca',
			'ie',
			'au',
			'pl'
		];
		
		var colorsOptionList = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''White'' )[/mura]";
		var colorsOptionLabelList = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''White'' )[/mura]";
		
		arrayEach( siteArray, function( siteID ) {
		
			var subTypeID = createUUID();
			var extendSetID = createUUID();
		
			// Create Class Extention
			sql &= 'INSERT INTO tclassextend (';
			sql &= 'subTypeID, siteID, baseTable, baseKeyField, dataTable, type, subType, isActive, hasSummary, hasBody, hasAssocFile, hasConfigurator, adminonly';
			sql &= ') VALUES (';
			sql &= "'#subTypeID#', '#siteID#', 'tcontent', 'contentHistID', 'tclassextenddata', 'Page', 'Large Image', 1, 0, 0, 1, 0, 0";
			sql &= "); ";
		
			// Create Class Extention Set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Attributes', 1, 'Basic'";
			sql &= "); ";
			
			var orderno = 10;
			
			for ( var code in languageMap ) {
				var lang = languageMap[ code ];
				
				var orderNumber = ( '' == code ) ? 1 : orderno;
				
				// Create Button Text Field
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly';
				sql &= ') VALUES (';
				sql &= "'#extendSetID#', '#siteID#', 'buttonText#code#', 'Button Text#lang#', 'TextBox', #orderNumber#, 1, 'false', 0";
				sql &= "); ";
					
				orderno++;
				
				// Create Button URL Field
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly';
				sql &= ') VALUES (';
				sql &= "'#extendSetID#', '#siteID#', 'buttonUrl#code#', 'Button Url#lang#', 'TextBox', #orderNumber#, 1, 'false', 0";
				sql &= "); ";
					
				orderno++;
			}
			
			// Create Text Color Option
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#colorsOptionList#', '#colorsOptionLabelList#'";
			sql &= "); ";
				
			orderno++;

			// Create Button Style Option
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'buttonStyle', 'Button Style', 'SelectBox', #orderno#, 1, 'false', 0, '', 'bg-primary^bg-secondary', 'Primary^Secondary'";
			sql &= "); ";
				
			orderno++;
		});
		
		queryExecute( sql );
		
	} catch(e) {
    	scriptHasErrors = true;
	}
	
	if ( scriptHasErrors ) {
		writeLog( file = 'Slatwall', text = 'ERROR: Update Script - Add content module fields failed.' );
	} else {
		writeLog( file = 'Slatwall', text = 'Update Script - Add content module fields.' );
	}
</cfscript>
