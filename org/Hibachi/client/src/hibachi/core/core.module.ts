/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {UtilityService} from "./services/utilityservice";
import {SelectionService} from "./services/selectionservice";
import {ObserverService} from "./services/observerservice";
import {FormService} from "./services/formservice";
import {MetaDataService} from "./services/metadataservice";
//filters
import {PercentageFilter} from "./filters/percentage";
//directives
import {SWTypeaheadSearch} from "./components/swtypeaheadsearch";

class PathBuilderConfig{
    public baseURL:string;
    public basePartialsPath:string;
    constructor(){
        
    }
    
    public setBaseURL = (baseURL:string):void=>{
        this.baseURL = baseURL;
    }
    
    public setBasePartialsPath = (basePartialsPath:string):void=>{
        this.basePartialsPath = basePartialsPath
    }
    
    public buildPartialsPath = (componentsPath:string):string=>{
        if(angular.isDefined(this.baseURL) && angular.isDefined(this.basePartialsPath)){
            return this.baseURL + this.basePartialsPath + componentsPath;
         }else{
            throw('need to define baseURL and basePartialsPath in pathBuilderConfig. Inject pathBuilderConfig into module and configure it there');
        }
    }
}

var coremodule = angular.module('hibachi.core',[]).config(()=>{
    
}).constant('pathBuilderConfig',new PathBuilderConfig())
//services
.service('utilityService',UtilityService)
.service('selectionService',SelectionService)
.service('observerService',ObserverService)  
.service('formService',FormService)
.service('metadataService',MetaDataService)
//filters 
.filter('percentage',[PercentageFilter.Factory])
//directives
.directive('swTypeahedSearch',SWTypeaheadSearch.Factory())
;  
export{
	coremodule
}