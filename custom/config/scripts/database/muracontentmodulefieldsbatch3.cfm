<cfscript>
	var scriptHasErrors = false;
	
	try {
		
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
		
		var sql = '';
		
		// Page / module-fixed-cta
		arrayEach( siteArray, function( siteID ) {
			
			var subTypeID = createUUID();
			var extendSetID = createUUID();
		
			// Create Class Extention
			sql &= 'INSERT INTO tclassextend (';
			sql &= 'subTypeID, siteID, baseTable, baseKeyField, dataTable, type, subType, availableSubTypes, isActive, hasSummary, hasBody, hasAssocFile, hasConfigurator, adminonly';
			sql &= ') VALUES (';
			sql &= "'#subTypeID#', '#siteID#', 'tcontent', 'contentHistID', 'tclassextenddata', 'Page', 'module-fixed-cta', '', 1, 1, 0, 1, 0, 0";
			sql &= "); ";
		
			// Create Class Extention Set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Content Options', 1, 'Basic'";
			sql &= "); ";
			
			var orderno = 10;
			
			for ( var code in languageMap ) {
				var lang = languageMap[ code ];
				
				var orderNumber = ( '' == code ) ? 9 : orderno;
				
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
			
			var textColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
			var textColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
				
			// text color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#textColor#', '#textColorLabel#'";
			sql &= "); ";
			
			orderno++;
			
			var bgColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''White'' )[/mura]";
			var bgColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''White'' )[/mura]";
				
			// background color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'backgroundColor', 'Background Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#bgColor#', '#bgColorLabel#'";
			sql &= "); ";
			
			orderno++;
			
			var buttonStyle = "[mura]m.getOptionListByTypeCode( ''buttonStyle'', ''Black'' )[/mura]";
			var buttonStyleLabel = "[mura]m.getOptionLabelListByTypeCode( ''buttonStyle'', ''Black'' )[/mura]";
				
			// button style
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'buttonStyle', 'Button Style', 'SelectBox', #orderno#, 1, 'false', 0, '', '#buttonStyle#', '#buttonStyleLabel#'";
			sql &= "); ";
			
			orderno++;
		});
		
		// module-content-split
		var query = new Query();
		var classExtends = query.execute( sql = "SELECT subTypeID, siteID FROM tclassextend WHERE subType = 'module-content-split'", returntype = 'array' ).getResult();

		arrayEach( classExtends, function( classExtend ) {
			var subTypeID = classExtend.subTypeID;
			var siteID = classExtend.siteID;
			
			var query = new Query();
			var extendSets = query.execute( sql = "SELECT extendSetID FROM tclassextendsets WHERE subTypeID = '#subTypeID#'", returntype = 'array' ).getResult();
			
			if ( !len( extendSets ) ) {
				continue;
			}
			
			var extendSetID = extendSets[1].extendSetID;
			
			var orderno = 20;
			
			for ( var code in languageMap ) {
				var lang = languageMap[ code ];
				
				var orderNumber = ( '' == code ) ? 19 : orderno;
				
				// Create Secondary Link Label Field
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly';
				sql &= ') VALUES (';
				sql &= "'#extendSetID#', '#siteID#', 'secondaryLinkLabel#code#', 'Secondary Link Label#lang#', 'TextBox', #orderNumber#, 1, 'false', 0";
				sql &= "); ";
					
				orderno++;
				
				// Create Secondary Link URL Field
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly';
				sql &= ') VALUES (';
				sql &= "'#extendSetID#', '#siteID#', 'secondaryLinkUrl#code#', 'Secondary Link Url#lang#', 'TextBox', #orderNumber#, 1, 'false', 0";
				sql &= "); ";
					
				orderno++;
			}
			
		});
		
		queryExecute( sql );
		
	} catch(e) {
    	scriptHasErrors = true;
	}
	
	if ( scriptHasErrors ) {
		writeLog( file = 'Slatwall', text = 'ERROR: Update Script - Add content module fields batch3 failed.' );
	} else {
		writeLog( file = 'Slatwall', text = 'Update Script - Add content module fields batch3.' );
	}
</cfscript>
