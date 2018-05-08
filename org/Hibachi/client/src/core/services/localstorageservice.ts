/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import { Injectable } from '@angular/core';

@Injectable()
export class LocalStorageService{


    //@ngInject
    constructor(
       
    ){
        
    }

    hasItem(key:string){
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

    getItem(key:string){
        let value = this.$window.localStorage.getItem(key);
        if(value.charAt(0)==='{' || value.charAt(0)==='['){
            value = angular.fromJson(value);
        }
        return value;
    }

    setItem(key:string, data:any){
        console.log(data);
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