/*jshint browser:true */
'use strict';

require('./vendor.ts')();
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
import {giftcardmodule} from "./giftcard/giftcard.module";
import {loggermodule} from "./hibachi/logger/logger.module"; 

//custom bootstrapper
class bootstrapper{
    constructor(){
      //this.fetchData().then(()=>{
          this.bootstrapApplication();
      //});
    }
    //should contain any data that is required by angular prior to bootstrapping
//    fetchData =()=> {
//        var initInjector = angular.injector(["ng"]);
//        var $timeout = initInjector.get<ng.ITimeoutService>("$timeout");
//    
//        return $timeout.then((response)=> {
//            //appModule.constant("config", response.data);
//        }, (errorResponse)=> {
//            // Handle error case
//        });
//    }
    
    bootstrapApplication = ()=> {
        angular.element(document).ready(function() {
            angular.bootstrap(document, [loggermodule.name,slatwalladminmodule.name], {
            //strictDi: true
                
          });
        });
    }
}

export = new bootstrapper();



