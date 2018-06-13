/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
import {Injectable, Inject} from "@angular/core";

@Injectable()
export class SlatwallPathBuilder{
    public baseURL:string;
    public basePartialsPath:string;
    
    constructor(){

    }

    public setBaseURL(baseURL:string):void {
        this.baseURL = baseURL;
    }

    public setBasePartialsPath(basePartialsPath:string):void {
        this.basePartialsPath = basePartialsPath
    }

    public buildPartialsPath(componentsPath:string):string {
        if(angular.isDefined(this.baseURL) && angular.isDefined(this.basePartialsPath)){
            return this.baseURL + this.basePartialsPath + componentsPath;
         }else{
            throw('need to define baseURL and basePartialsPath in hibachiPathBuilder. Inject hibachiPathBuilder into module and configure it there');
        }
    }
}