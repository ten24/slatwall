/// <reference path='../typings/slatwallTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
import {BaseBootStrapper} from "../../../org/Hibachi/client/src/basebootstrap";

import { slatwalladminmodule } from "./slatwall/slatwalladmin.module";
import { UpgradeModule } from "@angular/upgrade/static";
//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication;
    constructor(){
        var angular:any = super(slatwalladminmodule.name);
        try{
            angular.bootstrap();
            return angular.resolve(()=>{
                console.log(this.myApplication);
                angular.myApplication = this.myApplication;
            });
        }catch(e){
            
        }
    }


}

export {bootstrapper};



