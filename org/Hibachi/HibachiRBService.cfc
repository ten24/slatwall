component output="false" accessors="true" extends="HibachiService" {

	variables.resourceBundles = {};
	variables.instantiaded = now();
	
	public string function getRBKey(required string key, string locale="en_us", string checkedKeys="", string originalKey) {
		
		// Check to see if a list was passed in as the key
		if(listLen(arguments.key) gt 1) {
			
			// Set up "" as the key value to be passed as 'checkedKeys'
			var keyValue = "";
			
			// If there was a list then try to get the key for each item in order
			for(var l=1; l<=listLen(arguments.key); l++) {
				
				// Get the keyValue from this iteration
				var keyValue = getRBKey(key=listGetAt(arguments.key, l), locale=arguments.locale, checkedKeys=keyValue);
				
				// If the keyValue was found, then we can break out of the loop
				if(right(keyValue, "8") != "_missing") {
					break;
				}
			}
			
			return keyValue;
		}
		
		// Check the exact bundle file
		var bundle = getResourceBundle( arguments.locale );
		if(structKeyExists(bundle, arguments.key)) {
			return bundle[ arguments.key ];
		}
		// Because the value was not found, we can add this to the checkedKeys, and setup the original Key
		arguments.checkedKeys = listAppend(arguments.checkedKeys, arguments.key & "_" & arguments.locale & "_missing");
		if(!structKeyExists(arguments, "originalKey")) {
			arguments.originalKey = arguments.key;
		}
		
		// Check the broader bundle file
		if(listLen(arguments.locale, "_") == 2) {
			bundle = getResourceBundle( listFirst(arguments.locale, "_") );
			if(structKeyExists(bundle, arguments.key)) {
				return bundle[ arguments.key ];
			}
			// Add this more broad term to the checked keys
			arguments.checkedKeys = listAppend(arguments.checkedKeys, arguments.key & "_" & listFirst(arguments.locale, "_") & "_missing");
		}
		
		// Recursivly step the key back with the word 'define' replacing the previous.  Basically Look for just the "xxx.yyy.define.zzz" version of the end key and then "yyy.define.zzz" and then "define.zzz"
		if ( listLen(arguments.key, ".") >= 3 && listGetAt(arguments.key, listLen(arguments.key, ".") - 1, ".") eq "define" ) {
			var newKey = replace(arguments.key, "#listGetAt(arguments.key, listLen(arguments.key, ".") - 2, ".")#.define", "define", "one");
			return getRBKey(newKey, arguments.locale, arguments.checkedKeys, arguments.originalKey);
		} else if( listLen(arguments.key, ".") >= 2 && listGetAt(arguments.key, listLen(arguments.key, ".") - 1, ".") neq "define" ) {
			var newKey = replace(arguments.key, "#listGetAt(arguments.key, listLen(arguments.key, ".") - 1, ".")#.", "define.", "one");
			
			return getRBKey(newKey, arguments.locale, arguments.checkedKeys, arguments.originalKey);
		}
		
		if(listFirst(arguments.locale, "_") neq "en") {
			return getRBKey(arguments.originalKey, "en", arguments.checkedKeys);
		}
		
		return arguments.checkedKeys;
	}
	
	public struct function getAggregateResourceBundle(required string locale="en_us") {
		var aggBundle = getResourceBundle(arguments.locale);
		if(listLen(arguments.locale, "_") == 2) {
			structAppend(aggBundle, getResourceBundle( listFirst(arguments.locale, "_") ));
		}
		return aggBundle;
	}
	
	public struct function getResourceBundle(required string locale="en_us") {
		if(!structKeyExists(variables.resourceBundles, arguments.locale)) {
			var javaRB = new JavaRB.JavaRB();
			
			var thisRB = {};
			
			// Get the primary resource bundle for
			try {
				thisRB = javaRB.getResourceBundle(expandPath("/#getApplicationValue('applicationKey')#/config/resourceBundles/#arguments.locale#.properties"));
			} catch (any e) {
				// No RB File Found
			}
			
			// Get whatever resource bundle is in the custom config directory
			try {
				structAppend(thisRB, javaRB.getResourceBundle(expandPath("/#getApplicationValue('applicationKey')#/custom/config/resourceBundles/#arguments.locale#.properties")), true);
			} catch (any e) {
				// No RB File Found
			}
			
			variables.resourceBundles[ arguments.locale ] = thisRB;
		}
		return variables.resourceBundles[ arguments.locale ];
	}
	
	
}