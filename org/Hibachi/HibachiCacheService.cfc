component accessors="true" output="false" extends="HibachiService" {

	property name="cache" type="struct";
	property name="internalCacheFlag" type="boolean";
	property name="railoFlag" type="boolean";
	
	public any function init() {
		setCache( {} );
		setInternalCacheFlag( true );
		setRailoFlag( false );
		
		var hibachiConfig = getApplicationValue('hibachiConfig');
		if(structKeyExists(hibachiConfig, "useCachingEngineFlag") && hibachiConfig.useCachingEngineFlag) {
			setInternalCacheFlag( false );
		}
		if(structKeyExists(server,"railo") || structKeyExists(server,'lucee')) {
			setRailoFlag( true );	
		}
		
		return super.init();
	}

	public any function hasCachedValue( required string key ) {
		// If using the internal cache, then check there
		if( getInternalCacheFlag() && structKeyExists(getCache(), arguments.key) && structKeyExists(getCache()[ arguments.key ], "reset") && !getCache()[ arguments.key ].reset ) {
			return true;
			
		// If using the external cache, then check there
		} else if ( !getInternalCacheFlag() && getRailoFlag() && cacheKeyExists(arguments.key) ) {
			var fullValue = cacheGet( arguments.key );
			if(!isNull(fullValue) && isStruct(fullValue) && structKeyExists(fullValue, "reset") && !fullValue.reset && structKeyExists(fullValue, "value")) {
				return true;	
			}
			
		} else if ( !getInternalCacheFlag() ) {
			var fullValue = cacheGet( arguments.key );
			if(!isNull(fullValue) && isStruct(fullValue) && structKeyExists(fullValue, "reset") && !fullValue.reset && structKeyExists(fullValue, "value")) {
				return true;
			}
			
		}
		
		// By default return false
		return false;
	}
	
	public any function getCachedValue( required string key ) {
		// If using the internal cache, then check there
		if(getInternalCacheFlag() && structKeyExists(getCache(), key) ) {
			return getCache()[ arguments.key ].value;
			
		// If using the external cache, then check there
		} else if (!getInternalCacheFlag() && !isNull(cacheGet( arguments.key )) ) {
			return cacheGet( arguments.key ).value;
			
		}
	}
	
	public any function setCachedValue( required string key, required any value ) {
		// If using the internal cache, then set value there
		if(getInternalCacheFlag()) {
			getCache()[ arguments.key ] = {
				value = arguments.value,
				reset = false
			};
			
		// If using the external cache, then set value there
		} else if (!getInternalCacheFlag()) {
			cachePut( arguments.key, {
				value = arguments.value,
				reset = false
			});
			
		}
	}
	
	public any function resetCachedKey( required string key ) {
		// If using the internal cache, then reset there
		if(getInternalCacheFlag()) {
			if(!structKeyExists(getCache(), arguments.key)) {
				getCache()[ arguments.key ] = {};	
			}
			getCache()[ arguments.key ].reset = true;
			
		// If using the external cache, then reset there
		} else if (!getInternalCacheFlag()) {
			var tuple = {
				reset = true
			};
			
			// Done in a try catch in case the value doesn't exist
			try{
				tuple.value = cacheGet( arguments.key ).value;
			} catch(any e){};
			
			cachePut( arguments.key, tuple );
		}
	}
	
	public any function resetCachedKeyByPrefix( required string keyPrefix, boolean waitForThreadComplete=false ) {
		// Because there could be lots of keys potentially we do this in a thread
		var threadName="hibachiCacheService_resetCachedKeyByPrefix_#replace(createUUID(),'-','','ALL')#";
		thread name="#threadName#" keyPrefix=arguments.keyPrefix {
			if(getInternalCacheFlag()) {
				
				var allKeysArray = listToArray(structKeyList(getCache()));
				
				var prefixLen = len(keyPrefix);
				
				for(var key in allKeysArray) {
					if(left(key, prefixLen) eq keyPrefix) {
						getCache()[ key ].reset = true;
					}
				}
			} else {
				var allKeysArray = cacheGetAllIDs( '#keyPrefix#*' );
				
				for(var key in allKeysArray) {
					var tuple = cacheGet( key );
					tuple.reset = true;
					cachePut( key, tuple );
				}
			}
			
		}
		if(arguments.waitForThreadComplete){
			threadJoin(threadName);	
		}
		
		return evaluate(threadName);
	}
	
	
	public any function getOrCacheFunctionValue(required string key, required any fallbackObject, required any fallbackFunction, struct fallbackArguments={}) {
		// Check to see if this cache key already exists, and if so just return the cached value
		if(hasCachedValue(arguments.key)) {
			return getCachedValue(arguments.key);
		}
		
		// If a string was passed in, then we will figure out what type of object it is and instantiate
		if(!isObject(arguments.fallbackObject) && right(arguments.fallbackObject, 7) eq "Service") {
			arguments.fallbackObject = getService( arguments.fallbackObject );
		} else if (!isObject(arguments.fallbackObject) && right(arguments.fallbackObject, 3) eq "DAO") {
			arguments.fallbackObject = getDAO( arguments.fallbackObject );
		} else if (!isObject(arguments.fallbackObject)) {
			arguments.fallbackObject = getBean( arguments.fallbackObject );
		}
		
		// If not then execute the function
		var results = arguments.fallbackObject.invokeMethod(arguments.fallbackFunction, arguments.fallbackArguments);
		
		// Cache the result of the function
		setCachedValue(arguments.key, results);
		
		// Return the results
		return results;
	}
}