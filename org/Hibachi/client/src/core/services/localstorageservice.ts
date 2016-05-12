/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class LocalStorageService{


    //@ngInject
    constructor(
       public $window:ng.IWindowService
    ){
        this.$window = $window;
    }

    hasItem = (key:string)=>{
        return (
            this.$window.localStorage.getItem(key)
            && this.$window.localStorage.getItem(key) !== null
            && this.$window.localStorage.getItem(key) !== "undefined"
        );
    }

    getItem = (key:string)=>{


        return angular.fromJson(this.$window.localStorage.getItem(key));
    }

    setItem = (key:string, data:any)=>{
        if(angular.isObject(data) || angular.isArray(data)){
            data = angular.toJson(data);
        }
        this.$window.localStorage.setItem(key,data);
    }


}
export {
    LocalStorageService
};