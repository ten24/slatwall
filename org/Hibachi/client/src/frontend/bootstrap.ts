/*jshint browser:true */
'use strict';

import {BaseBootStrapper} from "../basebootstrap";
import {frontendmodule} from "./frontend.module";


//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    constructor(){
      super();
      this.myApplication = frontendmodule; 
      this.bootstrapConfigPromise.then((response:any)=>{
          var config = response.data;
          this.myApplication.constant("appConfig",config);
          this.bootstrapApplication();
           
      });
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



