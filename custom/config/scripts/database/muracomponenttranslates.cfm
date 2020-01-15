<cfscript>
	var scriptHasErrors = false;
	
	try {
	
		// Ensure we haven't already run this script.
		var query = new Query();
		var results = query.execute( sql = "SELECT subTypeID FROM tclassextend WHERE type = 'Component' AND subType = 'Default'", returntype = 'array' ).getResult();
		if ( arrayLen( results ) ) {
			return;
		}
		
		var languageMap = {
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
		
		arrayEach( siteArray, function( siteID ) {
		
			var subTypeID = createUUID();
			var extendSetID = createUUID();
		
			// Create Class Extention
			sql &= 'INSERT INTO tclassextend (';
			sql &= 'subTypeID, siteID, baseTable, baseKeyField, dataTable, type, subType, isActive, hasSummary, hasBody, hasAssocFile, hasConfigurator, adminonly';
			sql &= ') VALUES (';
			sql &= "'#subTypeID#', '#siteID#', 'tcontent', 'contentHistID', 'tclassextenddata', 'Component', 'Default', 1, 1, 1, 1, 0, 0";
			sql &= "); ";
		
			// Create Class Extention Set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Language Translations', 1, 'Basic'";
			sql &= "); ";
			
			var orderno = 1;
			for ( var code in languageMap ) {
				var lang = languageMap[ code ];
				
				// Create Title Field
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly';
				sql &= ') VALUES (';
				sql &= "'#extendSetID#', '#siteID#', 'title#code#', 'Title#lang#', 'TextBox', #orderno#, 1, 'false', 0";
				sql &= "); ";
					
				orderno++;
				
				// Create Content Field
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly';
				sql &= ') VALUES (';
				sql &= "'#extendSetID#', '#siteID#', 'body#code#', 'Content#lang#', 'HTMLEditor', #orderno#, 1, 'false', 0";
				sql &= "); ";
					
				orderno++;
					
			}
			
		});
		
		queryExecute( sql );
		
	} catch(e) {
    	scriptHasErrors = true;
	}
	
	if ( scriptHasErrors ) {
		writeLog( file = 'Slatwall', text = 'ERROR: Update Script - Update mura navigation components failed.' );
	} else {
		writeLog( file = 'Slatwall', text = 'Update Script - Updated mura navigation components.' );
	}
</cfscript>
