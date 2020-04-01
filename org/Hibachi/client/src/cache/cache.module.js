"use strict";
var _this = this;
exports.__esModule = true;
var cachefactory_1 = require("cachefactory");
// relies on http://www.pseudobry.com/CacheFactory/latest/tutorial-basics.html
// there's an angular-js project, but it's not being maitainde since 2017 
cachefactory_1.utils.equals = angular.equals;
cachefactory_1.utils.isObject = angular.isObject;
cachefactory_1.utils.fromJson = angular.fromJson;
var cacheModule = angular.module('hibachi.cache', [])
    .provider('BinaryHeap', function () {
    _this.$get = function () { return cachefactory_1.BinaryHeap; };
})
    .provider('CacheFactory', function () {
    //override default-configs
    var newDefaults = angular.extend({}, cachefactory_1.defaults, {
        'storagePrefix': 'hb.caches.',
        'capacity': Number.MAX_VALUE,
        'storageMode': 'localStorage',
        'recycleFreq': 60 * 1000,
        'maxAge': Number.MAX_VALUE,
        'deleteOnExpire': 'aggressive',
        'onExpire': function (key, value) {
            console.log("Cache Expired for Key: " + key + ", Value: " + value);
        }
    });
    _this.$get = ['$q', function ($q) {
            //set the PromiseConstructor to angular's $q
            cachefactory_1.utils.Promise = $q;
            var cacheFactory = new cachefactory_1.CacheFactory();
            Object.defineProperty(cacheFactory, 'defaults', {
                'value': newDefaults,
                'writable': true
            });
            return cacheFactory;
        }];
})
    .provider('localStorageCache', function () {
    /**
     * localStorageCache will be availabe to inject anywhere,
     * this cache is shared b/w browser tabs and tabs
     *
    */
    _this.$get = ['cacheFactory', function (cacheFactory) {
            var cache;
            if (!_this.cacheFactory.get('localStoragecache')) {
                // this will create a localStorege based cache, which will be availabe to inject anywhere
                cache = _this.cacheFactory('localStoragecache', {});
            }
            return cache;
        }];
})
    .provider('sessionStorageCache', function () {
    /**
     * sessionStorageCache will be availabe to inject anywhere,
     * this cache is unique for every browser-window, and is sahred b/w tabs
     *
    */
    _this.$get = ['cacheFactory', function (cacheFactory) {
            var cache;
            if (!_this.cacheFactory.get('sessionStoragecache')) {
                // this will create a sessionStorege based cache
                cache = _this.cacheFactory('sessionStoragecache', {
                    'storageMode': 'sessionStorage',
                    'recycleFreq': 5 * 1000,
                    'maxAge': 15 * 60 * 1000,
                    'onExpire': function (key, value) {
                        console.log("Session Cache Expired for Key: " + key + ", Value: " + value);
                    }
                });
            }
            return cache;
        }];
})
    .provider('memoryCache', function () {
    _this.$get = ['cacheFactory', function (cacheFactory) {
            var cache;
            if (!_this.cacheFactory.get('memoryStoragecache')) {
                // this will create a memory-based cache, which will be availabe to inject anywhere
                cache = _this.cacheFactory('memoryStoragecache', {
                    'storageMode': 'memory',
                    'recycleFreq': 2 * 1000,
                    'maxAge': 5 * 60 * 1000,
                    'onExpire': function (key, value) {
                        console.log("Session Cache Expired for Key: " + key + ", Value: " + value);
                    }
                });
            }
            return cache;
        }];
});
exports.cacheModule = cacheModule;
