<cfscript>
	var scriptHasErrors = false;
	
	try {
		var query = new Query();
		
		// Get navigation components.
		var results = query.execute( sql = "SELECT tcontent_id, body FROM tcontent WHERE title LIKE 'Navigation:%'", returntype = 'array' ).getResult();
		
		results.each(function(row) {
	
			if ( !isNull( row.body ) ) {
				// Match URLs for this site.
				var matches = reMatch( 'href="\/[a-z\/-]+"', row.body );
				
				var body = row.body;
				
				if ( len( matches ) ) {
				
					matches.each(function(match) {
						// Clean up the href value to exclude the site.
						var hrefVal = replace( match, 'href="', '' );
							hrefVal = replace( hrefVal, '"', '' );
							hrefVal = replace( hrefVal, '//', '/' );
							hrefVal = replace( hrefVal, '/ca/', '/' );
							hrefVal = replace( hrefVal, '/uk/', '/' );
							hrefVal = replace( hrefVal, '/au/', '/' );
							hrefVal = replace( hrefVal, '/ie/', '/' );
							hrefVal = replace( hrefVal, '/pl/', '/' );
							
						body = replace( 
							body, 
							match, 
							'href="[mura]m.createHREF( filename = ''#hrefVal#'' )[/mura]"'
						);
						
					});
						
					// Update our old body with our new one.
					queryExecute( 
						"UPDATE tcontent SET body = :body WHERE tcontent_id = :tcontentid LIMIT 1", 
						{
							tcontentid = row.tcontent_id,
							body = { 
								value = body, 
								cfsqltype = 'cf_sql_varchar'
							}
						}
					);
				}
			}
		});
	} catch(e) {
    	scriptHasErrors = true;
	}
	
	if ( scriptHasErrors ) {
		writeLog( file = 'Slatwall', text = 'ERROR: Update Script - Update mura navigation components failed.' );
	} else {
		writeLog( file = 'Slatwall', text = 'Update Script - Updated mura navigation components.' );
	}
</cfscript>
