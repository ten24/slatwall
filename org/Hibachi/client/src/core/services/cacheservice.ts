/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class CacheService{

    private cacheData = {}; 

    constructor(
        private localStorageService
    ){
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

    public put = (key, dataPromise, expiresTime="forever") =>{
        this.cacheData[key].expiresTime = expiresTime;
        this.cacheData[key].dataPromise = dataPromise; 
        dataPromise.then(
            (response)=>{
                this.localStorageService.setItem(key,response); 
            },
            (reason)=>{
                delete this.cacheData[key];
            }
        );
        return dataPromise;
    }

    public reload = (key,expiresTime="forever") =>{
        this.cacheData[key].expiresTime = expiresTime;
        this.cacheData[key].dataPromise.then(
            (response)=>{
                this.localStorageService.setItem(key,response); 
            },
            (reason)=>{
                delete this.cacheData[key];
            }
        );
    }

    public fetch = (key) =>{
        if(this.hasKey(key) && !this.dateExpired(key)){
            if(this.localStorageService.hasItem(key)){
                return this.localStorageService.getItem(key);
            }     
            this.put(key, this.cacheData[key].dataPromise, this.cacheData[key].expiresTime).finally(
                ()=>{
                    return this.localStorageService.getItem(key);
                }
            );
        }
    }

}
export{CacheService};

