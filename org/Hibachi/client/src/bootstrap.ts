/*jshint browser:true */
'use strict';

import {BaseBootStrapper} from "./basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
import {loggermodule} from "./logger/logger.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    constructor(){
      super();
        
        
      this.bootstrapConfigPromise.then((response:any)=>{
          var config = response.data;
          this.myApplication.constant("appConfig",config);
          var initInjector = angular.injector(["ng",this.myApplication.name]);
          console.log(initInjector.get('appConfig'));
//          var rbkeyService = initInjector.get('rbkeyService');
//          rbkeyService.getResourceBundles().then(()=>{
            this.bootstrapApplication();    
//          });
          
      });

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



