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

	public any function getServerInstanceByServerInstanceKey(required string serverInstanceKey, boolean returnNewIfNotFound, string serverInstanceIPAddress){
		getHibachiScope().setValue('dirtyReadAllowed',true);
		var serverInstance = super.onMissingGetMethod(missingMethodName='getServerInstanceByServerInstanceKey',missingMethodArguments=arguments);
		getHibachiScope().setValue('dirtyReadAllowed',false);
		
		if(isNull(serverInstance)){
			lock name="create_serverinstance_#arguments.serverInstanceKey#" type="exclusive" timeout="10"  {
				// check one more time to make avoid duplicate server instance 
				serverInstance = super.onMissingGetMethod(missingMethodName='getServerInstanceByServerInstanceKey',missingMethodArguments=arguments);
				if(isNull(serverInstance)){
					serverInstance = this.newServerInstance();
				
					if(!structKeyExists(arguments, 'serverInstanceIPAddress')){
						arguments.serverInstanceIPAddress = getHibachiScope().getServerInstanceIPAddress();
					}
					serverInstance.setServerInstanceKey(arguments.serverInstanceKey);
					serverInstance.setServerInstanceIPAddress(arguments.serverInstanceIPAddress);
					serverInstance.setServerInstancePort(getHibachiScope().getServerInstancePort());
					serverInstance.setServerInstanceClusterName(getHibachiScope().getApplicationValue('applicationCluster'));
					serverInstance.setServerInstanceExpired(false);
					serverInstance.setSettingsExpired(false);
					serverInstance.setLastRequestDateTime(now());
					
					this.saveServerInstance(serverInstance); 
					getHibachiScope().flushOrmSession();

				}
			}
		}
		return serverInstance;	
	} 
	
	public any function getDatabaseCacheByDatabaseCacheKey(required databaseCacheKey){
		return getDao('HibachiCacheDAO').getDatabaseCacheByDatabaseCacheKey(arguments.databaseCacheKey);
	}
	
	public any function hasCachedValue( required string key ) {
		
		verifyCacheKey(arguments.key);

		// If using the internal cache, then check there
		if( getInternalCacheFlag() && 
			structKeyExists(getCache(), arguments.key) && 
			structKeyExists(getCache()[ arguments.key ], "reset") && 
			!getCache()[ arguments.key ].reset &&
			( !structKeyExists(getCache()[ arguments.key ], 'expirationDateTime') ||
			  getCache()[ arguments.key ].expirationDateTime > now() ) 
		) {
			return true;
			
		// If using the external cache, then check there
		} else if ( !getInternalCacheFlag() && getRailoFlag() && cacheKeyExists(arguments.key) ) {
			var fullValue = cacheGet( arguments.key );
			if(!isNull(fullValue) && 
				isStruct(fullValue) && 
				structKeyExists(fullValue, "reset") && 
				!fullValue.reset && 
				structKeyExists(fullValue, "value") &&
				( !structKeyExists(fullValue, 'expirationDateTime') ||
				  fullValue.expirationDateTime > now() ) 
			) {
				return true;	
			}
			
		} else if ( !getInternalCacheFlag() ) {
			var fullValue = cacheGet( arguments.key );
			if(!isNull(fullValue) && 
				isStruct(fullValue) && 
				structKeyExists(fullValue, "reset") && 
				!fullValue.reset && 
				structKeyExists(fullValue, "value")  &&
				( !structKeyExists(fullValue, 'expirationDateTime') ||
				  fullValue.expirationDateTime > now() ) 
			) {
				return true;
			}
			
		}
		
		// By default return false
		return false;
	}
	
	public void function resetPermissionCache() {
		this.resetCachedKeyByPrefix('getPermissionRecordRestrictions',true);
		//clears cache keys on the permissiongroup Object
		this.resetCachedKeyByPrefix('PermissionGroup.');
	}
	
	public void function updateServerInstanceCache(string serverInstanceKey){
		if(!structKeyExists(arguments, 'serverInstanceKey')){
			arguments.serverInstanceKey = server[getApplicationValue('applicationKey')].serverInstanceKey;
		}
		var serverInstance = this.getServerInstanceByServerInstanceKey(arguments.serverInstanceKey);
		getDao('hibachiCacheDao').updateServerInstanceCache(serverInstance);
	}
	
	public void function updateServerInstanceSettingsCache(string serverInstanceKey){
		if(getHibachiScope().getApplicationValue('applicationEnvironment') == 'local'){
			return;
		}		

		if(!structKeyExists(arguments, 'serverInstanceKey')){
			arguments.serverInstanceKey = server[getApplicationValue('applicationKey')].serverInstanceKey;
		}
		var serverInstance = this.getServerInstanceByServerInstanceKey(arguments.serverInstanceKey);
		getDao('hibachiCacheDao').updateServerInstanceSettingsCache(serverInstance);
	}
	
	public any function getCachedValue( required string key ) {
		verifyCacheKey(arguments.key);

		// If using the internal cache, then check there
		if(getInternalCacheFlag() && structKeyExists(getCache(), arguments.key) && (!structKeyExists(getCache()[arguments.key],"expirationDateTime") || getCache()[arguments.key].expirationDateTime > now()) ) {
			return getCache()[ arguments.key ].value;
			
		// If using the external cache, then check there
		} else if (!getInternalCacheFlag() && !isNull(cacheGet( arguments.key )) && (!structKeyExists(cacheGet( arguments.key ),"expirationDateTime") || cacheGet( arguments.key ).expirationDateTime > now())  ) {
			return cacheGet( arguments.key ).value;
		}
	}
	
	private void function verifyCacheKey(required string key){
		if(isNUll(arguments.key) || !Len(arguments.key)){
			throw("Cache Key can't be null or emply");
		}
	}
	
	public any function setCachedValue( required string key, required any value, date expirationDateTime ) {
		// If using the internal cache, then set value there
		
		verifyCacheKey(arguments.key);
		
		var dataToCache = {
			value = arguments.value,
			reset = false
		};
  
		if(structKeyExists(arguments, "expirationDateTime")){ 
			dataToCache.expirationDateTime = arguments.expirationDateTime; 
		} 

		if(getInternalCacheFlag()) {
			getCache()[ arguments.key ] = dataToCache;  			
		// If using the external cache, then set value there
		} else if (!getInternalCacheFlag()) {
			cachePut( arguments.key, dataToCache);
		}
	}
	
	public any function resetCachedKey( required string key ) {

		verifyCacheKey(arguments.key);

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
		
		verifyCacheKey(arguments.keyPrefix);

		// Because there could be lots of keys potentially we do this in a thread
		var threadName="hibachiCacheService_resetCachedKeyByPrefix_#replace(createUUID(),'-','','ALL')#";
		thread name="#threadName#" keyPrefix=arguments.keyPrefix {
			if(getInternalCacheFlag()) {
				
				var allKeysArray = listToArray(structKeyList(getCache(), '|'),'|');
				
				var prefixLen = len(keyPrefix);
				
				for(var key in allKeysArray) {
					if(left(key, prefixLen) == keyPrefix) {
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
