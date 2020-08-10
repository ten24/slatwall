/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class LocalStorageService{


    //@ngInject
    constructor(
       public $window:ng.IWindowService
    ){
        this.$window = $window;
    }
    
    removeItem = (key:string)=>{
        try{
            this.$window.localStorage.removeItem(key);
        }
        catch(e){
            console.error(e);
        }
    }

    hasItem = (key:string)=>{
        //try catch to handle safari in private mode which does not allow localstorage
        try{
            return (
                this.$window.localStorage.getItem(key)
                && this.$window.localStorage.getItem(key) !== null
                && this.$window.localStorage.getItem(key) !== "undefined"
            );
        }catch(e){
            return false;    
        }
    }

    getItem = (key:string)=>{
        let value = this.$window.localStorage.getItem(key);
        if(value.charAt(0)==='{' || value.charAt(0)==='['){
            value = angular.fromJson(value);
        }
        return value;
    }

    setItem = (key:string, data:any)=>{
        //try catch to handle safari in private mode which does not allow localstorage
        try{
            if(angular.isObject(data) || angular.isArray(data)){
                data = angular.toJson(data);
            }
            this.$window.localStorage.setItem(key,data);
        }catch(e){
            
        }
    }


}
export {
    LocalStorageService
};
