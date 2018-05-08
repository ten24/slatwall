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
                window.localStorage.getItem(key)
                && window.localStorage.getItem(key) !== null
                && window.localStorage.getItem(key) !== "undefined"
            );
        }catch(e){
            return false;    
        }
    }

    getItem(key:string){
        let value = window.localStorage.getItem(key);
        if(value.charAt(0)==='{' || value.charAt(0)==='['){
            value = angular.fromJson(value);
        }
        return value;
    }

    setItem(key:string, data:any){
        //try catch to handle safari in private mode which does not allow localstorage
        try{
            if(angular.isObject(data) || angular.isArray(data)){
                data = angular.toJson(data);
            }
            window.localStorage.setItem(key,data);
        }catch(e){
            
        }
    }


}