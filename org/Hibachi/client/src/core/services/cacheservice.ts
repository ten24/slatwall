/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class CacheService{

    private cacheData = {}; 

    constructor(
        private localStorageService
    ){
    }

    public hasKey = (key) =>{
        console.log("hasKey",this.cacheData);
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
    }

    public fetch = (key) =>{
        console.log("fetching?",this.hasKey(key),!this.dateExpired(key));
        if(this.hasKey(key) && !this.dateExpired(key)){
            if(this.localStorageService.hasItem(key)){
                console.log("fetching", this.localStorageService.getItem(key));
                return this.localStorageService.getItem(key);
            }     
            this.put(key, this.cacheData[key].dataPromise, this.cacheData[key].expiresTime).finally(
                ()=>{
                    console.log("fetching", this.localStorageService.getItem(key));
                    return this.localStorageService.getItem(key);
                }
            );
        }
    }

}
export{CacheService};

