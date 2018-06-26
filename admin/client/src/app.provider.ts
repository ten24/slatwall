import { Injectable } from '@angular/core';
import { HttpClient, HttpResponse } from '@angular/common/http';
import {Observable} from 'rxjs/Observable';
import {Subject} from 'rxjs/Subject';
import {fromPromise} from 'rxjs/observable/fromPromise';

declare var hibachiConfig:any;
var md5 = require('md5');
@Injectable()
export class AppConfig {
  public action: string= "";
  public applicationKey:string="";
  public attributeCacheKey:string="";
  public baseURL : string = "";
  public dateFormat: string = "";
  public debugFlag:boolean;
  public instantiationKey: string ="";
  public modelConfig:any={};
  public rbLocale: string = "";
  public timeFormat: string = "";
  constructor(){
  }
}
@Injectable()
export class ResourceBundles {
  constructor(){
  }
}

@Injectable()
export class AttributeMetaData {
  constructor(){
  }
}

@Injectable()
export class AppProvider {
  public hasData$:Observable<boolean>;
  public hasDataSubject:Subject<boolean>;
  public appConfig;
  public _resourceBundle = {};
  public attributeMetaData:any;
  public instantiationKey:string;
  public _hasData:boolean;

  constructor(private http: HttpClient) {
    this.hasDataSubject = new Subject<boolean>();
    this.hasData$ = this.hasDataSubject.asObservable();
  }

  set hasData(newValue) {
    this._hasData = newValue;
    this.hasDataSubject.next(newValue);
  }

  public fetchData():Promise<any>{
      var baseURL = hibachiConfig.baseURL;
      if(!baseURL) {
          baseURL = ''
      }
      if(baseURL.length && baseURL.slice(-1) !== '/'){
          baseURL += '/';
      }

     return this.getInstantiationKey(baseURL).then((instantiationKey:string)=>{
          this.instantiationKey = instantiationKey;
          console.log('test3');
          var invalidCache = [];
          try{
              var hashedData = localStorage.getItem('attributeChecksum');
              if(hashedData !== null && hibachiConfig.attributeCacheKey === hashedData.toUpperCase()){
                  this.attributeMetaData = JSON.parse(localStorage.getItem('attributeMetaData'));
              }else{
                  invalidCache.push('attributeCacheKey');
              }
          }catch(e){
              invalidCache.push('attributeCacheKey');
          }

          try{
              this.appConfig = JSON.parse(localStorage.getItem('appConfig'));
              console.log(hibachiConfig);
              console.log(this.appConfig);
              if(hibachiConfig.instantiationKey === this.appConfig.instantiationKey){
                  console.log('test',this.appConfig);
                  return this.getResourceBundles();
              }else{
                
                  invalidCache.push('instantiationKey');
              }
          }catch(e){
              invalidCache.push('instantiationKey');
          }

          return this.getData(invalidCache);
      });
      
  }

  public getInstantiationKey(baseURL:string):Promise<any>{
      return new Promise((resolve, reject)=> {
          if(hibachiConfig.instantiationKey){
              resolve(hibachiConfig.instantiationKey);
          }else{
              
              return this.http.get(baseURL+'?'+hibachiConfig.action+'=api:main.getInstantiationKey').toPromise().then((resp:any) => resolve(resp.data.instantiationKey));

          }
      });
  };


  public getData(invalidCache:string[]):Promise<any>{
      var promises:any ={};
      for(var i in invalidCache){
          var invalidCacheName = invalidCache[i];
          var functionName = invalidCacheName.charAt(0).toUpperCase()+invalidCacheName.slice(1);
          promises[invalidCacheName] = this['get'+functionName+'Data']();
          
      }
      return Promise.all(promises);
  };

  public getAttributeCacheKeyData():Promise<any>{
      var urlString = "";

      if(!hibachiConfig){
          hibachiConfig = {};
      }

      if(!hibachiConfig.baseURL){
          hibachiConfig.baseURL = '';
      }
      urlString += hibachiConfig.baseURL;

      if(urlString.length && urlString.slice(-1) !== '/'){
          urlString += '/';
      }
      return new Promise((resolve,reject)=>{
        return this.http.get(urlString+'?'+hibachiConfig.action+'=api:main.getAttributeModel')
        .subscribe( (resp:any)=> {
            //for safari private mode which has no localStorage
            try{
                localStorage.setItem('attributeMetaData',JSON.stringify(resp.data));
                localStorage.setItem('attributeChecksum',md5(JSON.stringify(resp.data)));
            }catch(e){}
            this.attributeMetaData = resp.data;
            resolve(true);
        });
      });

  };

  public getInstantiationKeyData():Promise<any>{
      if(!this.instantiationKey){
          var d = new Date();
          var n = d.getTime();
          this.instantiationKey = n.toString();
      }
      var urlString = "";
      if(!hibachiConfig){
          hibachiConfig = {};
      }
      if(!hibachiConfig.baseURL){
          hibachiConfig.baseURL = '';
      }
      urlString += hibachiConfig.baseURL;
      if(hibachiConfig.baseURL.length && hibachiConfig.baseURL.charAt(hibachiConfig.baseURL.length-1) != '/'){
          urlString+='/';
      }
      console.log('getINstan');
      return this.http.get(urlString+'/custom/config/config.json?instantiationKey='+this.instantiationKey)
      .toPromise().then( (resp:any)=> {
        console.log('testhere');
      	var appConfig = resp.data;
          if(hibachiConfig.baseURL.length){
              appConfig.baseURL=urlString;    
          }
          try{
              localStorage.setItem('appConfig',JSON.stringify(resp.data));
          }catch(e){}
          
          this.appConfig = appConfig;
          console.log('getINstan2');
          return this.getResourceBundles();
      });

  };

  public getResourceBundle(locale):Promise<any>{
      var locale = locale || this.appConfig.rbLocale;

      if(this._resourceBundle[locale]) {
          return this._resourceBundle[locale];
      }

      var urlString = this.appConfig.baseURL+'/custom/config/resourceBundles/'+locale+'.json?instantiationKey='+this.appConfig.instantiationKey;
      
      return new Promise((resolve,reject)=>{
        this.http.get(urlString).toPromise().then((response:any) => {
            
            this._resourceBundle[locale] = response;
            resolve(true);
        },(error:any) => {
            if(error.status === 404){
                this._resourceBundle[locale] = {};
                resolve(true);
            }else{
                reject(true);
            }
        });
      });
  };

  public getResourceBundles():Promise<any>{
    console.log('test4');
      var localeListArray = this.appConfig.rbLocale.split('_');
      var rbPromise;
      var rbPromises = [];
      rbPromise = this.getResourceBundle(this.appConfig.rbLocale);
      rbPromises.push(rbPromise);
      if(localeListArray.length === 2) {
          rbPromise = this.getResourceBundle(localeListArray[0]);
          rbPromises.push(rbPromise);
      }
      if(localeListArray[0] !== 'en') {
          //this.getResourceBundle('en_us');
          this.getResourceBundle('en');
      }
      console.log('test5');
      return Promise.all(rbPromises)
      /*.then((data) => {
        console.log('test',this._resourceBundle,data);
      },(error) =>{
          //can enter here due to 404
      });*/

  }
}