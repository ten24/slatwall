component accessors="true" output="false" extends="HibachiService" {

	property name="cache" type="struct";
	property name="internalCacheFlag" type="boolean";
	
	public any function init() {
		setCache( {} );
		setInternalCacheFlag( true );
		
		var hibachiConfig = getApplicationValue('hibachiConfig');
		if(structKeyExists(hibachiConfig, "useCachingEngineFlag") && hibachiConfig.useCachingEngineFlag) {
			setInternalCacheFlag( false );
		}
		
		return super.init();
	}

	public any function hasCachedValue( required string key ) {
		// If using the internal cache, then check there
		if(getInternalCacheFlag() && structKeyExists(getCache(), arguments.key) && !getCache()[ arguments.key ].reset ) {
			return true;
			
		// If using the external cache, then check there
		} else if (!getInternalCacheFlag() && arrayFindNoCase(cacheGetAllIDs(), arguments.key) && !cacheGet( arguments.key ).reset ) {
			return true;
			
		}
		
		// By default return false
		return false;
	}
	
	public any function getCachedValue( required string key ) {
		// If using the internal cache, then check there
		if(getInternalCacheFlag() && structKeyExists(getCache(), key) ) {
			return getCache()[ arguments.key ].value;
			
		// If using the external cache, then check there
		} else if (!getInternalCacheFlag() && arrayFindNoCase(cacheGetAllIDs(), key) ) {
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
			getCache()[ arguments.key ].reset = true;
			
		// If using the external cache, then reset there
		} else if (!getInternalCacheFlag()) {
			var tuple = {
				reset = true
			};
			if(arrayFindNoCase(cacheGetAllIDs(), arguments.key)) {
				tuple.value = cacheGet( arguments.key ).value;
			}
			cachePut( arguments.key, tuple );
		}
	}
	
	public any function resetCachedKeyByPrefix( required string keyPrefix ) {
		// Because there could be lots of keys potentially we do this in a thread
		thread name="hibachiCacheService_resetCachedKeyByPrefix_#createUUID()#" keyPrefix=arguments.keyPrefix {
			var allKeysArray = [];
			if(getInternalCacheFlag()) {
				allKeysArray = listToArray(structKeyList(getCache()));
			} else {
				allKeysArray = cacheGetAllIDs();
			}
			var prefixLen = len(keyPrefix);
			for(var key in allKeysArray) {
				if(left(key, prefixLen) eq keyPrefix) {
					resetCachedKey( key );
				}
			}
		}
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