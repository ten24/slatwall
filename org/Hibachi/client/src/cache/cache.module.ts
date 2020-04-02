declare var angular: any;
declare var ng: any;

import { CacheFactory, BinaryHeap, utils, defaults  } from 'cachefactory';
// relies on http://www.pseudobry.com/CacheFactory/latest/tutorial-basics.html
// there's an angular-js project, but it's not being maitainde since 2017 

utils.equals = angular.equals;
utils.isObject = angular.isObject;
utils.fromJson = angular.fromJson;

class BinaryHeapProvider implements ng.IServiceProvider {
        
        constructor() {}
        
        public $get() {
                return BinaryHeap;
        };
}

class CacheFactoryProvider implements ng.IServiceProvider {
    
    private config:any={};
    
    constructor() {

        this.config = defaults;

        this.config.storagePrefix = 'hb.caches.';
        this.config.capacity = Number.MAX_VALUE; // how many items per cache
        this.config.storageMode = 'localStorage'; // available options "memory"(default); "localStorage"; "sessionStorage"
        
        // making-default to never, we can override as needed
        // this.config.recycleFreq = 15*60*1000; // all caceh will be scaned every 1 minute for expired items
        
        this.config.maxAge = Number.MAX_VALUE; // number of milies after which the cache will be expired 
        this.config.deleteOnExpire = 'aggressive'; // available options "none", "passive", "aggressive"
        
	    this.$get.$inject = [ '$q'];
    }
    
    public override(overrides) {
         this.config =  {...this.config, ...overrides}; //merge with overriding 
    }

    public $get($q) {
            
            utils.Promise = $q;
            
            let cacheFactory = new CacheFactory();
            Object.defineProperty(cacheFactory, 'defaults', {
              value: this.config
            })
            
            return cacheFactory;
    };
}

class LocalStorageCacheProvider implements ng.IServiceProvider {
    
    private config:any={
        'name': 'ls.default'
    };
    
    constructor() {
        this.config.onExpire = (key, value) => {
            console.log(`LocalStorage-cache ${this.config.name}, has expired for Key: ${key}, Value: ${value}`);
        }
	    this.$get.$inject = [ 'CacheFactory'];
    }
    
    public override(overrides) {
         this.config =  {...this.config, ...overrides}; //merge with overriding 
    }

    public $get(CacheFactory) {
        let cache;
        //check if cache-object is already created
    	if(CacheFactory.exists(this.config.name)){
    		cache = CacheFactory.get(this.config.name);
    	} else {
            // this will retain data if any from LocalStorege, and will create a cacheObject, 
            // this which will be availabe to inject into any service/controller/component
        	cache = CacheFactory.createCache(this.config.name, this.config);
		}
        return cache;
    };
}

class SessionStorageCacheProvider implements ng.IServiceProvider {
    
    private config:any={
        'name': 'ss.default',
        'storageMode': 'sessionStorage',
        'recycleFreq': 5*1000, // will scan the cache every 5 sec for expired items
        'maxAge': 15*60*1000, // anything will expire after 15 minutes
    };
    
    constructor() {
        this.config.onExpire = (key, value) => {
            console.log(`SessionStorage-cache ${this.config.name}, has expired for Key: ${key}, Value: ${value}`);
        }
	    this.$get.$inject = [ 'CacheFactory'];
    }
    
    public override(overrides) {
        this.config =  {...this.config, ...overrides}; //merge with overriding 
    }

    public $get(CacheFactory) {
        let cache;
        //check if cache-object is already created
    	if(CacheFactory.exists(this.config.name)){
    		cache = CacheFactory.get(this.config.name);
    	} else {
            // this will retain data if any from Session-Storege, and will create a cacheObject, 
            // this which will be availabe to inject into any service/controller/component
        	cache = CacheFactory.createCache(this.config.name, this.config);
		}
        return cache;
    };
}


class MemoryCacheProvider implements ng.IServiceProvider {
    
    private config:any = {
        'name': 'mem.default',
        'storageMode': 'memory',
        'recycleFreq': 2*1000, // will scan the cache every 2 sec for expired items
        'maxAge': 5*60*1000, // anything will expire after 5 minutes
    };
    
    constructor() {
        this.config.onExpire = (key, value) => {
            console.log(`Memory-cache ${this.config.name}, has expired for Key: ${key}, Value: ${value}`);
        }
	    this.$get.$inject = [ 'CacheFactory'];
    }
    
    public override(overrides) {
         this.config =  {...this.config, ...overrides}; //merge with overriding 
    }

    public $get(CacheFactory) {
        let cache;
        //check if cache-object is already created
    	if(CacheFactory.exists(this.config.name)){
    		cache = CacheFactory.get(this.config.name);
    	} else {
            // this will create a In-Memory caceh-Object, 
            // this which will be availabe to inject into any service/controller/component
        	cache = CacheFactory.createCache(this.config.name, this.config);
		}
        return cache;
    };
}


/**
 * For uses/api-ref, see 
 * http://www.pseudobry.com/CacheFactory/latest/Cache.html 
 * http://www.pseudobry.com/CacheFactory/latest/CacheFactory.html
 *
*/ 


let cacheModule = angular.module('hibachi.cache',[])
  .provider("BinaryHeap",  BinaryHeapProvider)
  .provider("CacheFactory", CacheFactoryProvider)
  .provider('localStorageCache', LocalStorageCacheProvider)
  .provider('sessionStorageCache', SessionStorageCacheProvider)
  .provider('inMemoryCache', MemoryCacheProvider) //can use a better name, like currentPageCache
;

export {
    cacheModule
};
