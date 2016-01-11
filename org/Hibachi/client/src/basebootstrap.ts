/*jshint browser:true */
'use strict';

require('./vendor.ts')();
import {coremodule} from "./core/core.module";
interface IBaseBootStrapper{
    bootstrapConfigPromise:any;
    myApplication:any;
}

//custom bootstrapper
class BaseBootStrapper implements IBaseBootStrapper{
    public bootstrapConfigPromise:any;
    public myApplication:any;
    constructor(){
      this.myApplication = coremodule;
      this.bootstrapConfigPromise = this.fetchConfig();

    }

    fetchConfig=()=>{
          var initInjector = angular.injector(["ng"]);
          var $http = initInjector.get<ng.IHttpService>("$http");
          var $q = initInjector.get<ng.IQService>("$q");

          var deferred = $q.defer();
          var urlString = '/index.cfm/?slatAction=api:main.getConfig';
          var params = {};
          $http.get(urlString,{
              params:params
          }).success((data)=>{
              deferred.resolve(data);
          }).error((reason)=>{
              deferred.reject(reason);
          });
          return deferred.promise;
    }

}

export = {BaseBootStrapper};



