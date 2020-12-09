/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class CacheService{

    private cacheData = {};

    //@ngInject
    constructor(
        private localStorageService
    ){
        if(localStorageService.hasItem("cacheData")){
            this.cacheData = localStorageService.getItem("cacheData");
        }
    }

    private saveCacheData = () =>{
        this.localStorageService.setItem("cacheData",this.cacheData);
    }

    public hasKey = (key) =>{

        if(angular.isDefined(this.cacheData[key])){
            return true;
        }
        return false;
    }

    public dateExpired = (key) =>{
        if(this.cacheData[key].expiresTime=="forever"){
            return false;
        }
        return this.cacheData[key].expiresTime < Date.now();
    }

    public put = (key, dataPromise, dataTarget, expiresTime="forever") =>{
        this.cacheData[key] = {};
        this.cacheData[key].expiresTime = expiresTime;
        this.cacheData[key].dataPromise = dataPromise;
        this.cacheData[key].dataTarget = dataTarget;
        dataPromise.then(
            (response)=>{
                this.localStorageService.setItem(key,response[dataTarget]);
            },
            (reason)=>{
                delete this.cacheData[key];
            }
        );
        this.saveCacheData();
        return dataPromise;
    }

    public reload = (key,expiresTime="forever") =>{
        this.cacheData[key].expiresTime = expiresTime;
        this.cacheData[key].dataPromise.then(
            (response)=>{
                this.localStorageService.setItem(key,response[this.cacheData[key].dataTarget]);
            },
            (reason)=>{
                delete this.cacheData[key];
            }
        );
        this.saveCacheData();
        return this.cacheData[key].dataPromise;
    }

    public fetch = (key) =>{
        if(this.hasKey(key) && !this.dateExpired(key)){
            if(this.localStorageService.hasItem(key)){
                return this.localStorageService.getItem(key);
            }
            this.put(key, this.cacheData[key].dataPromise, this.cacheData[key].dataTarget, this.cacheData[key].expiresTime).finally(
                ()=>{
                    return this.localStorageService.getItem(key);
                }
            );
        }
    }

    public fetchOrReload = (key, expiresTime) =>{
        if(angular.isDefined(this.fetch(key))){
            return this.fetch(key);
        } else {
            this.reload(key,expiresTime).then(
                (response)=>{
                    return this.fetch(key);
                },
                (reason)=>{
                    //throw
                }
            );
        }
    }

}
export{CacheService};

