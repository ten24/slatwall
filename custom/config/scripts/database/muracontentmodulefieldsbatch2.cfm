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
		
		// module-content-split
		var query = new Query();
		var classExtends = query.execute( sql = "SELECT subTypeID, siteID FROM tclassextend WHERE subType = 'module-content-split'", returntype = 'array' ).getResult();

		var sql = '';
		arrayEach( classExtends, function( classExtend ) {
			var subTypeID = classExtend.subTypeID;
			var extendSetID = createUUID();
			var siteID = classExtend.siteID;
			
			var orderno = 10;
			
			// extend set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Content options', 1, 'Basic'";
			sql &= "); ";
				
			var bgColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''Light Grey'' )[/mura]";
			var bgColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''Light Grey'' )[/mura]";
				
			// background color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'backgroundColor', 'Background Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#bgColor#', '#bgColorLabel#'";
			sql &= "); ";
			
			orderno++;
			
			var textColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
			var textColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
				
			// text color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#textColor#', '#textColorLabel#'";
			sql &= "); ";
		});
		
		// Board Member Listing	
		// delete class extentions first
		arrayEach( siteArray, function( siteID ) {
			
			var subTypeID = createUUID();
			var extendSetID = createUUID();
		
			// Create Class Extention
			sql &= 'INSERT INTO tclassextend (';
			sql &= 'subTypeID, siteID, baseTable, baseKeyField, dataTable, type, subType, isActive, hasSummary, hasBody, hasAssocFile, hasConfigurator, adminonly';
			sql &= ') VALUES (';
			sql &= "'#subTypeID#', '#siteID#', 'tcontent', 'contentHistID', 'tclassextenddata', 'Page', 'Board Member Listing', 1, 1, 0, 1, 0, 0";
			sql &= "); ";
		
			// Create Class Extention Set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Listing Options', 1, 'Basic'";
			sql &= "); ";
			
			var orderno = 10;
			
			// MemberURL
			for ( var code in languageMap ) {
				var lang = languageMap[ code ];
				
				var orderNumber = ( '' == code ) ? 1 : orderno;
				
				sql &= 'INSERT INTO tclassextendattributes (';
				sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly';
				sql &= ') VALUES (';
				sql &= "'#extendSetID#', '#siteID#', 'memberURL#code#', 'Member URL#lang#', 'TextBox', #orderNumber#, 1, 'false', 0";
				sql &= "); "
				
				orderno++;
			}
			
			var textColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''White'' )[/mura]";
			var textColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''White'' )[/mura]";
				
			// text color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#textColor#', '#textColorLabel#'";
			sql &= "); ";
		});
		
		// Folder / module-container-lg-image
		// delete class extentions first
		arrayEach( siteArray, function( siteID ) {
			
			var subTypeID = createUUID();
			var extendSetID = createUUID();
			var orderno = 10;
		
			// Create Class Extention
			sql &= 'INSERT INTO tclassextend (';
			sql &= 'subTypeID, siteID, baseTable, baseKeyField, dataTable, type, subType, isActive, hasSummary, hasBody, availableSubTypes, hasAssocFile, hasConfigurator, adminonly';
			sql &= ') VALUES (';
			sql &= "'#subTypeID#', '#siteID#', 'tcontent', 'contentHistID', 'tclassextenddata', 'Folder', 'module-container-lg-image', 1, 0, 0, 'Page/Board Member Listing', 0, 0, 0";
			sql &= "); ";
		
			// Create Class Extention Set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Content Options', 1, 'Basic'";
			sql &= "); ";
				
			var bgColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''White'' )[/mura]";
			var bgColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''White'' )[/mura]";
			
			orderno++;
				
			// background color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'backgroundColor', 'Background Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#bgColor#', '#bgColorLabel#'";
			sql &= "); ";
			
			var textColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
			var textColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
				
			// text color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#textColor#', '#textColorLabel#'";
			sql &= "); ";
		});
		
		// Page / module-content-columns
		var query = new Query();
		var classExtends = query.execute( sql = "SELECT subTypeID, siteID FROM tclassextend WHERE type = 'Page' AND subType = 'module-content-columns'", returntype = 'array' ).getResult();

		arrayEach( classExtends, function( classExtend ) {
			var subTypeID = classExtend.subTypeID;
			var extendSetID = createUUID();
			var siteID = classExtend.siteID;
			
			var orderno = 10;
			
			// extend set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Content options', 1, 'Basic'";
			sql &= "); ";
			
			var textColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
			var textColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
				
			// text color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#textColor#', '#textColorLabel#'";
			sql &= "); ";
		});
		
		// Folder / module-content-columns
		// delete us class extention
		arrayEach( siteArray, function( siteID ) {
			
			var subTypeID = createUUID();
			var extendSetID = createUUID();
		
			// Create Class Extention
			sql &= 'INSERT INTO tclassextend (';
			sql &= 'subTypeID, siteID, baseTable, baseKeyField, dataTable, type, subType, availableSubTypes, isActive, hasSummary, hasBody, hasAssocFile, hasConfigurator, adminonly';
			sql &= ') VALUES (';
			sql &= "'#subTypeID#', '#siteID#', 'tcontent', 'contentHistID', 'tclassextenddata', 'Folder', 'module-content-columns', 'Page/module-content-columns', 1, 1, 0, 1, 0, 0";
			sql &= "); ";
		
			// Create Class Extention Set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Content Options', 1, 'Basic'";
			sql &= "); ";
			
			var orderno = 10;
			
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
		});
		
		// Page / image-content-int
		var query = new Query();
		var classExtends = query.execute( sql = "SELECT subTypeID, siteID FROM tclassextend WHERE subType = 'module-image-content-int'", returntype = 'array' ).getResult();

		arrayEach( classExtends, function( classExtend ) {
			var subTypeID = classExtend.subTypeID;
			var siteID = classExtend.siteID;
			
			var query = new Query();
			var extendSets = query.execute( sql = "SELECT extendSetID FROM tclassextendsets WHERE subTypeID = '#subTypeID#'", returntype = 'array' ).getResult();
			
			if ( !len( extendSets ) ) {
				continue;
			}
			
			var extendSetID = extendSets[1].extendSetID;
			var orderno = 10;
				
			var buttonStyle = "[mura]m.getOptionListByTypeCode( ''buttonStyle'', ''Black'' )[/mura]";
			var buttonStyleLabel = "[mura]m.getOptionLabelListByTypeCode( ''buttonStyle'', ''Black'' )[/mura]";
				
			// button style
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'buttonStyle', 'Button Style', 'SelectBox', #orderno#, 1, 'false', 0, '', '#buttonStyle#', '#buttonStyleLabel#'";
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
			
			var textColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
			var textColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
				
			// text color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#textColor#', '#textColorLabel#'";
			sql &= "); ";
		});
		
		// Page / module-full-content-split
		var query = new Query();
		var classExtends = query.execute( sql = "SELECT subTypeID, siteID FROM tclassextend WHERE subType = 'module-full-content-split'", returntype = 'array' ).getResult();

		arrayEach( classExtends, function( classExtend ) {
			var subTypeID = classExtend.subTypeID;
			var siteID = classExtend.siteID;
			var extendSetID = createUUID();
			
			var orderno = 10;
			
			// Create Class Extention Set
			sql &= 'INSERT INTO tclassextendsets (';
			sql &= 'extendSetID, subTypeID, siteID, name, orderno, container';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#subTypeID#', '#siteID#', 'Content Options', 1, 'Basic'";
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
			
			var textColor = "[mura]m.getOptionListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
			var textColorLabel = "[mura]m.getOptionLabelListByTypeCode( ''brandColors'', ''Black'' )[/mura]";
				
			// text color
			sql &= 'INSERT INTO tclassextendattributes (';
			sql &= 'extendSetID, siteID, name, label, type, orderno, isActive, required, adminonly, defaultValue, optionList, optionLabelList';
			sql &= ') VALUES (';
			sql &= "'#extendSetID#', '#siteID#', 'textColor', 'Text Color', 'SelectBox', #orderno#, 1, 'false', 0, '', '#textColor#', '#textColorLabel#'";
			sql &= "); ";
		});
		
		queryExecute( sql );
		
	} catch(e) {
    	scriptHasErrors = true;
	}
	
	if ( scriptHasErrors ) {
		writeLog( file = 'Slatwall', text = 'ERROR: Update Script - Add content module fields batch2 failed.' );
	} else {
		writeLog( file = 'Slatwall', text = 'Update Script - Add content module fields batch2.' );
	}
</cfscript>
