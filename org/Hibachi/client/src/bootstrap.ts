/*jshint browser:true */
'use strict';

require('./vendor.ts')();
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
import {loggermodule} from "./logger/logger.module"; 

declare var slatwallAngular:any;


//custom bootstrapper
class bootstrapper{
    constructor(){
      this.fetchData().then((data:any)=>{
          slatwallAngular.modelConfig = data.data;
          this.bootstrapApplication();
      });
    }
    //should contain any data that is required by angular prior to bootstrapping
   fetchData =()=> {
       var initInjector = angular.injector(["ng"]);
       var $http = initInjector.get<ng.IHttpService>("$http");
       var $q = initInjector.get<ng.IQService>("$q");
   
      var deferred = $q.defer();
      var urlString = 'index.cfm/?slatAction=api:main.getModel';
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
    
    bootstrapApplication = ()=> {
        angular.element(document).ready(function() {
            angular.bootstrap(document, [loggermodule.name,slatwalladminmodule.name], {
            //strictDi: true
                
          });
        });
    }
}

export = new bootstrapper();



