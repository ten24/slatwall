component accessors="true" output="false" extends="HibachiService" {

	property name="cache" type="struct";
	property name="internalCacheFlag" type="boolean";
	property name="railoFlag" type="boolean";

	public any function init() {
		setCache( {} );
		setInternalCacheFlag( false );
		setRailoFlag( false );

		if(structKeyExists(server,"railo") || structKeyExists(server,'lucee')) {
			setRailoFlag( true );

			try {
				cachePut('railo-cache-enabled', 'true');
			} catch(any e) {
				setInternalCacheFlag( true );
			}
		}

		return super.init();
	}

  // Returns an internal application scoped, or session scoped struct for storing cached values
	public any function getCache(boolean sessionFlag=false) {
		if(arguments.sessionFlag) {
			return session;
		}
		return variables.cache;
	}

	public void function updateServerInstanceCache(required string serverInstanceIPAddress){
		var serverInstance = this.getServerInstanceByServerInstanceIPAddress(arguments.serverInstanceIPAddress);
		if(isNull(serverInstance)){
			serverInstance = this.newServerInstance();
			serverInstance.setServerInstanceIPAddress(arguments.serverInstanceIPAddress);
			serverInstance.setServerInstanceExpired(false);
			this.saveServerInstance(serverInstance);
		}

		getDao('hibachiCacheDao').updateServerInstanceCache(serverInstance);
	}

	public boolean function isServerInstanceCacheExpired(required string serverInstanceIPAddress){
		return getDao('hibachiCacheDao').isServerInstanceCacheExpired(arguments.serverInstanceIPAddress);
	}

	public string function getCacheContext() {
		return getApplicationValue('applicationName');
	}

	public string function buildCacheKey( required string key, boolean sessionFlag=false) {
		// Make the key application specific so that we can use one shared cache for multiple applications
		var cacheKey = "#getCacheContext()#-";

		// If this is a session cached value add the sessionID to the key
		if(arguments.sessionFlag) {
			cacheKey &= "#getHibachiObject().getSession().getSessionCookieNPSID()#-";
		}

		// Add the unique key itself
		cacheKey &= arguments.key;

		return cacheKey;
	}

	public any function hasCachedValue( required string key, boolean sessionFlag=false  ) {
		var cacheKey = buildCacheKey(key=arguments.key, sessionFlag=arguments.sessionFlag);

		// If using the internal cache, then check there
		if( getInternalCacheFlag() && structKeyExists(getCache(sessionFlag=arguments.sessionFlag), cacheKey) && structKeyExists(getCache(sessionFlag=arguments.sessionFlag)[ cacheKey ], "reset") && !getCache(sessionFlag=arguments.sessionFlag)[ cacheKey ].reset ) {
			return true;

		// If using the external cache, then check there
		} else if ( !getInternalCacheFlag() && getRailoFlag() && cacheKeyExists(arguments.key) ) {
			var fullValue = cacheGet( cacheKey );
			if(!isNull(fullValue) && isStruct(fullValue) && structKeyExists(fullValue, "reset") && !fullValue.reset && structKeyExists(fullValue, "value")) {
				return true;
			}

		} else if ( !getInternalCacheFlag() ) {
			var fullValue = cacheGet( cacheKey );
			if(!isNull(fullValue) && isStruct(fullValue) && structKeyExists(fullValue, "reset") && !fullValue.reset && structKeyExists(fullValue, "value")) {
				return true;
			}

		}

		// By default return false
		return false;
	}

	public any function getCachedValue( required string key, boolean sessionFlag=false  ) {
		var cacheKey = buildCacheKey(key=arguments.key, sessionFlag=arguments.sessionFlag);

		// If using the internal cache, then check there
		if(getInternalCacheFlag() && structKeyExists(getCache(sessionFlag=arguments.sessionFlag), cacheKey) ) {
			return getCache(sessionFlag=arguments.sessionFlag)[ cacheKey ].value;

		// If using the external cache, then check there
		} else if (!getInternalCacheFlag() && !isNull(cacheGet( arguments.key )) ) {
			return cacheGet( cacheKey ).value;

		}
	}

	public any function setCachedValue( required string key, required any value, boolean sessionFlag=false ) {
		var cacheKey = buildCacheKey(key=arguments.key, sessionFlag=arguments.sessionFlag);

		// If using the internal cache, then set value there
		if(getInternalCacheFlag()) {
			getCache(sessionFlag=arguments.sessionFlag)[ cacheKey ] = {
				value = arguments.value,
				reset = false
			};

		// If using the external cache, then set value there
		} else if (!getInternalCacheFlag()) {
			cachePut( cacheKey, {
				value = arguments.value,
				reset = false
			});

		}
	}

	public any function resetCachedKey( required string key, boolean sessionFlag=false ) {
		var cacheKey = buildCacheKey(key=arguments.key, sessionFlag=arguments.sessionFlag);

		// If using the internal cache, then reset there
		if(getInternalCacheFlag()) {
			if(!structKeyExists(getCache(sessionFlag=arguments.sessionFlag), arguments.key)) {
				getCache(sessionFlag=arguments.sessionFlag)[ arguments.key ] = {};
			}
			getCache(sessionFlag=arguments.sessionFlag)[ arguments.key ].reset = true;

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

				var allKeysArray = listToArray(structKeyList(getCache(sessionFlag=arguments.sessionFlag)));

				var prefixLen = len(keyPrefix);

				for(var key in allKeysArray) {
					if(left(key, prefixLen) eq keyPrefix) {
						getCache(sessionFlag=arguments.sessionFlag)[ key ].reset = true;
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


	public any function getOrCacheFunctionValue(required string key, required any fallbackObject, required any fallbackFunction, struct fallbackArguments={}, boolean sessionFlag=false) {
		var cacheKey = buildCacheKey(key=arguments.key, sessionFlag=arguments.sessionFlag);

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
