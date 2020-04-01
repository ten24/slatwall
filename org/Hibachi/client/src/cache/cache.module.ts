declare var angular: any;

import { CacheFactory, BinaryHeap, utils, defaults  } from 'cachefactory';
// relies on http://www.pseudobry.com/CacheFactory/latest/tutorial-basics.html
// there's an angular-js project, but it's not being maitainde since 2017 

utils.equals = angular.equals;
utils.isObject = angular.isObject;
utils.fromJson = angular.fromJson;

let cacheModule = angular.module('hibachi.cache',[])
  .provider('BinaryHeap', () => {
      this.$get = () =>  BinaryHeap;
  })
  .provider('CacheFactory', () => {
        //override default-configs
        let newDefaults = angular.extend({}, defaults, {
            'storagePrefix': 'hb.caches.',
            'capacity': Number.MAX_VALUE, // how many items per cache
            'storageMode': 'localStorage', // available options "memory"(default), "localStorage", "sessionStorage"
            
            'recycleFreq': 60*1000, // all caceh will be scaned every 1 minute for expired items
            'maxAge': Number.MAX_VALUE, // number of milies after which the cache will be expired 
            'deleteOnExpire': 'aggressive', // available options "none", "passive", "aggressive"
            'onExpire': (key, value) => {
                console.log(`Cache Expired for Key: ${key}, Value: ${value}`);
            }
        });
        
        this.$get = ['$q', ($q) => {
            
            //set the PromiseConstructor to angular's $q
            utils.Promise = $q; 
            
            let cacheFactory = new CacheFactory();
            Object.defineProperty(cacheFactory, 'defaults', {
                'value': newDefaults,
                'writable': true,
            });
            return cacheFactory;
        }];
        
  })
  .provider('localStorageCache', () => {
      
        /**
         * localStorageCache will be availabe to inject anywhere,
         * this cache is shared b/w browser-tabs and windows
         * this cache has no max-age
         * 
        */
        this.$get = ['cacheFactory', (cacheFactory) => {
            let cache;
            if(!this.cacheFactory.get('localStoragecache')) {
                // this will create a localStorege based cache, which will be availabe to inject anywhere
                cache = this.cacheFactory('localStoragecache', {
                    
                });
            }
            return cache;
        }];
  })
  .provider('sessionStorageCache', () => {
      
      /**
       * sessionStorageCache will be availabe to inject anywhere,
       * this cache is unique for every browser-window, and is sahred b/w tabs
       * 
      */
        this.$get = ['cacheFactory', (cacheFactory) => {
            let cache;
            if(!this.cacheFactory.get('sessionStoragecache')) {
                // this will create a sessionStorege based cache
                cache = this.cacheFactory('sessionStoragecache', {
                    'storageMode': 'sessionStorage',
                    'recycleFreq': 5*1000, // will scane the cache every 5 sec for expired items
                    'maxAge': 15*60*1000, // anything will expire after 15 minutes
                    'onExpire': (key, value) => {
                        console.log(`Session Cache Expired for Key: ${key}, Value: ${value}`);
                    }
                });
            }
            return cache;
        }];
  })
  .provider('memoryCache', () => {
        this.$get = ['cacheFactory', (cacheFactory) => {
            let cache;
            if(!this.cacheFactory.get('memoryStoragecache')) {
                // this will create a memory-based cache, which will be availabe to inject anywhere
                cache = this.cacheFactory('memoryStoragecache', {
                    'storageMode': 'memory',
                    'recycleFreq': 2*1000, // will scane the cache every 2 sec for expired items
                    'maxAge': 5*60*1000, // anything will expire after 5 minutes
                    'onExpire': (key, value) => {
                        console.log(`Memory Cache Expired for Key: ${key}, Value: ${value}`);
                    }
                });
            }
            return cache;
        }];
  });

export {
    cacheModule
};
