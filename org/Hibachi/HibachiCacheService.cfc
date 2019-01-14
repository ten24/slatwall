component accessors="true" output="false" extends="HibachiService" {

	property name="cache" type="struct";
	property name="cacheElementsTotal" type="numeric";
	property name="cacheHitStack" type="array";
	property name="cacheSweepTotal" type="numeric";
	property name="cacheValidationIntervalSeconds" type="numeric";
	property name="internalCacheFlag" type="boolean";
	property name="lastValidationTicks" type="numeric";
	property name="maxCacheElementsLimit" type="numeric";
	property name="railoFlag" type="boolean";
	 
	
	public any function init() {
		setCache( {} );
		setCacheElementsTotal(0);
		setCacheHitStack([]);
		setCacheSweepTotal(0);
		setCacheValidationIntervalSeconds(10);
		setInternalCacheFlag( true );
		setLastValidationTicks(0);
		setMaxCacheElementsLimit(1000);
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
	
	// ===================== START: Logical Methods ===========================
	
	/** 
	* Periodically inspect the cache (determined by interval setting) 
	* to prevent severe and negative impact on the server's processing performance by 
	* consuming too much memory with its footprint. Also reduce cache misses/thrashing 
	* (increase associativity) and avoid processing overhead  of frequent and unecessary 
	* expensive calculations.
	* 
	* Eviction Policy: Enforce an optimal limit on the maximum total num of elements stored by the cache.
	* When the limit is exceeded, determine the priority of elements to evict by identifying
	* the least recently & most frequently used elements
	*
	* If necessary caching functionality could further be enhanced
	*  1. Track individual elements timeToIdle and timeToLive timeouts
	*  2. Creating two separate cache regions to prevent certain data from being evicted.
	*  3. with consideration of the processing time
	*     required to compute an cache element's value (more expensive vs most frequently used)
	*     to create a relative score, and eviction could be based on an element's score ranking.
	*
	* Resource for garbage collection and caching concepts:
	*   https://stackify.com/memory-leaks-java/
	*   https://www.coldfusionmuse.com/index.cfm/2008/2/12/leaky.heap.jvm
	*   http://docs.jboss.org/jbossclustering/hibernate-caching/3.3/en-US/html/eviction.html
	*   https://en.wikipedia.org/wiki/Cache_replacement_policies
	*/
	// @hint Method determines when to inspect and execute the element eviction sweep to optimize application memory usage by the cache
	public void function verifyCacheAndValidate() {
		
		// Lock because we don't want any threads to encounter a race condition to sweep the cache and we want to prevent trying to access a value from the cache if it gets evicted concurrently
		
		// Cache is fresh and initialize with current tick count
		if (isNull(getLastValidationTicks()) || getLastValidationTicks() == 0) {
			lock name="Application_hibachiCacheService" type="exclusive" timeout="30"  {
				if (isNull(getLastValidationTicks()) || getLastValidationTicks() == 0) {
					setLastValidationTicks(getTickCount());
				}
			}
			
		// Cache needs to be inspected and re-validated (interval lapsed)
		} else if ((getTickCount() - getLastValidationTicks()) >= (getCacheValidationIntervalSeconds() * 1000)) {
			lock name="Application_hibachiCacheService" type="exclusive" timeout="30"  {
				if ((getTickCount() - getLastValidationTicks()) >= (getCacheValidationIntervalSeconds() * 1000)) {
					sweepCache();
					setLastValidationTicks(getTickCount());
				}
			}
		}
	}
	
	// @hint Method is not thread-safe, it is meant to be invoked from within an exclusive lock such as through the 'verifyCacheAndValidate' method
	public void function sweepCache() {
		var cacheMaxElementLimitExceededByCount = arrayLen(getCacheHitStack()) - getMaxCacheElementsLimit(); 
		
		// NOTE: Potential future improvement
		// TODO: Check for timeToIdle timeout (time to allow an element to stay in cache if it hasn't been accessed during the timeToidle time period)
		// TODO: Check for expiration (timeToLive)
		
		// Positive diff indicates we've exceeded the limit
		if (cacheMaxElementLimitExceededByCount > 0) {
			variables.cacheSweepTotal++;
			
			if(getInternalCacheFlag()) {
				// Remove each cache element by key from the cache struct that exceeds the limit
				for (var cacheElementKey in arraySlice(getCacheHitStack(), arrayLen(getCacheHitStack()) - cacheMaxElementLimitExceededByCount + 1, cacheMaxElementLimitExceededByCount)) {
					structDelete(getCache(), cacheElementKey);
				}
			
			// External cache
			} else {
				// Remove elements from cache that exceeds the limit using a cache key list
				cacheRemove(arraySlice(getCacheHitStack(), arrayLen(getCacheHitStack()) - cacheMaxElementLimitExceededByCount + 1, cacheMaxElementLimitExceededByCount));
			}
			
			
			// Slice the array to exclude the first N elements that exceed the maxCacheElementsLimit, and update it as the new cacheHitStack
			// This will de-reference those elements
			// NOTE: Potential future improvement could be to slice it back to 75% of the limit (instead of currently 100%) so it doesn't immediately re-fill and evict next sweep
			setCacheHitStack(arraySlice(getCacheHitStack(), 1, arrayLen(getCacheHitStack()) - cacheMaxElementLimitExceededByCount));
		}
	}
	
	// @hint Method is not thread-safe, it maintains the order of the cacheHitStack from MRU to LRU (first element and last element respectively)
	private void function updateCacheHitStack(required string key) {
		
		// Make the key the first element in the stack array. Because we want to be able to pop/slice the last N elements to evict the LRU elements during the sweep
		var cacheKeyExistingIndex = arrayFindNoCase(getCacheHitStack(), arguments.key);
		
		// Repeat hit occurred, just remove its old position
		if (cacheKeyExistingIndex) {
			arrayDeleteAt(getCacheHitStack(), cacheKeyExistingIndex);
		}
		
		// Key set to be the MRU
		arrayInsertAt(getCacheHitStack(), 1, arguments.key);
	}
	
	public any function getCacheElementMRU() {
		if (arrayLen(getCacheHitStack())) {
			var key = arrayFirst(getCacheHitStack());
			
			if (getInternalCacheFlag()) {
				return getCache()[key];
			}
			else if (!getInternalCacheFlag() && getRailoFlag() && cacheKeyExists(key)) {
				return cacheGet(key);
			} else if (!getInternalCacheFlag()) {
				return cacheGet(key);
			}
		}
	}
	
	public any function getCacheElementLRU() {
		if (arrayLen(getCacheHitStack())) {
			var key = arrayLast(getCacheHitStack());
			
			if (getInternalCacheFlag()) {
				return getCache()[key];
			}
			else if (!getInternalCacheFlag() && getRailoFlag() && cacheKeyExists(key)) {
				return cacheGet(key);
			} else if (!getInternalCacheFlag()) {
				return cacheGet(key);
			}
		}
	}
	
	public any function getServerInstanceByServerInstanceIPAddress(required any serverInstanceIPAddress){
		var serverInstance = super.onMissingGetMethod(missingMethodName='getServerInstanceByServerInstanceIPAddress',missingMethodArguments=arguments);
		
		if(isNull(serverInstance) || serverInstance.getNewFlag()){
			serverInstance = this.newServerInstance();
			serverInstance.setServerInstanceIPAddress(arguments.serverInstanceIPAddress);
			serverInstance.setServerInstanceExpired(false);
			serverInstance.setSettingsExpired(false);
			
			this.saveServerInstance(serverInstance); 
			getHibachiScope().flushOrmSession();
		}
		return serverInstance;
	}
	
	
	public any function getDatabaseCacheByDatabaseCacheKey(required databaseCacheKey){
		return getDao('HibachiCacheDAO').getDatabaseCacheByDatabaseCacheKey(arguments.databaseCacheKey);
	}
	
	public any function hasCachedValue( required string key ) {
		
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
	
	public void function updateServerInstanceCache(required string serverInstanceIPAddress){
		var serverInstance = this.getServerInstanceByServerInstanceIPAddress(arguments.serverInstanceIPAddress);
		getDao('hibachiCacheDao').updateServerInstanceCache(serverInstance);
	}
	
	public void function updateServerInstanceSettingsCache(required string serverInstanceIPAddress){
		var serverInstance = this.getServerInstanceByServerInstanceIPAddress(arguments.serverInstanceIPAddress);
		getDao('hibachiCacheDao').updateServerInstanceSettingsCache(serverInstance);
	}
	
	public boolean function isServerInstanceCacheExpired(required string serverInstanceIPAddress){
		var isExpired = getDao('hibachiCacheDao').isServerInstanceCacheExpired(arguments.serverInstanceIPAddress);
		if(isNull(isExpired)){
			this.getServerInstanceByServerInstanceIPAddress(arguments.serverInstanceIPAddress);
			return false;
		}else{
			return isExpired;
		}
	} 
	
	public boolean function isServerInstanceSettingsCacheExpired(required string serverInstanceIPAddress){
		return getDao('hibachiCacheDao').isServerInstanceSettingsCacheExpired(arguments.serverInstanceIPAddress);
	} 
	
	public any function getCachedValue(required string key, boolean useLock=true) {
		if (arguments.useLock) {
			lock name="Application_hibachiCacheService" type="readonly" timeout="30"  {
				return getCachedValue_internal(argumentcollection=arguments);
			}
		} else {
			return this.getCachedValue_internal(argumentcollection=arguments);
		}
	}
	
	private any function getCachedValue_internal( required string key ) {
		// If using the internal cache, then check there
		if(getInternalCacheFlag() && structKeyExists(getCache(), key) && (!structKeyExists(getCache()[key],"expirationDateTime") || getCache()[key].expirationDateTime > now()) ) {
			// Update last access time
			getCache()[ arguments.key ].accessLast = getTickCount();
			getCache()[ arguments.key ].hits++;
			return getCache()[ arguments.key ].value;
			
		// If using the external cache, then check there
		} else if (!getInternalCacheFlag() && !isNull(cacheGet( arguments.key )) && (!structKeyExists(cacheGet( arguments.key ),"expirationDateTime") || cacheGet( arguments.key ).expirationDateTime > now())  ) {
			
			// Update last access time
			var cacheData = cacheGet( arguments.key );
			cacheData.accessLast = getTickCount();
			cacheData.hits++;
			cachePut(arguments.key, cacheData);
			
			return cacheData.value;
		}
	}
	
	// @hint Method is not thread-safe, should be used with exclusive Application_hibachiCacheService lock
	public any function setCachedValue( required string key, required any value, date expirationDateTime ) {
		
		// If using the internal cache, then set value there
		updateCacheHitStack(arguments.key);

		var dataToCache = {
			value = arguments.value,
			reset = false,
			accessLast = getTickCount(),
			hits = 1
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
	
	
	public any function getOrCacheFunctionValue(required string key, required any fallbackObject, required any fallbackFunction, struct fallbackArguments={}, date expirationDateTime) {
		// Check to see if this cache key already exists, and if so just return the cached value
		lock name="Application_hibachiCacheService" type="readonly" timeout="30"  {
			if(hasCachedValue(arguments.key)) {
				return getCachedValue(arguments.key, false);
			}
		}
		
		// If a string was passed in, then we will figure out what type of object it is and instantiate
		if(!isObject(arguments.fallbackObject) && right(arguments.fallbackObject, 7) eq "Service") {
			arguments.fallbackObject = getService( arguments.fallbackObject );
		} else if (!isObject(arguments.fallbackObject) && right(arguments.fallbackObject, 3) eq "DAO") {
			arguments.fallbackObject = getDAO( arguments.fallbackObject );
		} else if (!isObject(arguments.fallbackObject)) {
			arguments.fallbackObject = getBean( arguments.fallbackObject );
		}
		
		// If not then execute the function, append to the arguments struct to pass through to the setCachedValue method
		arguments.value = arguments.fallbackObject.invokeMethod(arguments.fallbackFunction, arguments.fallbackArguments);
		
		// Cache the result of the function
		lock name="Application_hibachiCacheService" type="exclusive" timeout="30"  {
			setCachedValue(argumentCollection=arguments);
		}
		
		// Return the results
		return arguments.value;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== END: DAO Passthrough =============================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	public numeric function getCacheElementsTotal() {
		if(getInternalCacheFlag()) {
			return structCount(getCache());
		} else {
			return arrayLen(cacheGetAllIds());
		}
	}
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
	// ===================== START: Logging Methods ===========================
	
	// ===================== END: Logging Methods =============================
	
	// =================== START: Deprecated Functions ========================
	
	// ===================  END: Deprecated Functions =========================
}
