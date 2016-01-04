/*jshint browser:true */
'use strict';

require('../vendor.ts')();
import{frontendmodule} from "./frontend.module";
//import {slatwalladminmodule} from "../slatwall/slatwalladmin.module";

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
        var urlString = '/?slatAction=api:main.getModel';//use the admin address here.
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
            angular.bootstrap(document, [frontendmodule.name], {
            //strictDi: true
                
          });
        });
    }
}

export = new bootstrapper();



