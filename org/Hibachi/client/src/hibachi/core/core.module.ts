/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {UtilityService} from "./services/utilityservice";
import {SelectionService} from "./services/selectionservice";
import {ObserverService} from "./services/observerservice";
import {FormService} from "./services/formservice";
import {MetaDataService} from "./services/metadataservice";
//controllers
import {GlobalSearchController} from "./controllers/globalsearch";
import {OtherWiseController} from "./controllers/otherwisecontroller";
import {RouterController} from "./controllers/routercontroller";
//filters
import {PercentageFilter} from "./filters/percentage";
//directives
//  components
import {SWActionCaller} from "./components/swactioncaller";
import {SWTypeaheadSearch} from "./components/swtypeaheadsearch";
import {SWActionCallerDropdown} from "./components/swactioncallerdropdown";
import {SWColumnSorter} from "./components/swcolumnsorter";
import {SWConfirm} from "./components/swconfirm";
import {SWEntityActionBar} from "./components/swentityactionbar";
import {SWEntityActionBarButtonGroup} from "./components/swentityactionbarbuttongroup";
import {SWExpandableRecord} from "./components/swexpandablerecord";
import {SWListingDisplay} from "./components/swlistingdisplay";
import {SWListingColumn} from "./components/swlistingcolumn";
import {SWLogin} from "./components/swlogin";
import {SWNumbersOnly} from "./components/swnumbersonly";
import {SWLoading} from "./components/swloading";
import {SWScrollTrigger} from "./components/swscrolltrigger";
import {SWRbKey} from "./components/swrbkey";
import {SWOptions} from "./components/swoptions";
import {SWSelection} from "./components/swselection";
import {SWClickOutside} from "./components/swclickoutside";
import {SWDirective} from "./components/swdirective";
import {SWExportAction} from "./components/swexportaction";
import {SWHref} from "./components/swhref";
import {SWProcessCaller} from "./components/swprocesscaller";
import {SWResizedImage} from "./components/swresizedimage";
import {SWSortable} from "./components/swsortable";
//  entity
import {SWDetail} from "./entity/swdetail";
import {SWList} from "./entity/swlist";
//  validation
import {SWValidate} from "./validation/swvalidate";
import {SWValidationMinLength} from "./validation/swvalidationminlength";
import {SWValidationDataType} from "./validation/swvalidationdatatype";
import {SWValidationEq} from "./validation/swvalidationeq";




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
.constant('corePartialsPath','core/components/')
//services
.service('utilityService',UtilityService)
.service('selectionService',SelectionService)
.service('observerService',ObserverService)  
.service('formService',FormService)
.service('metadataService',MetaDataService)
//controllers
.controller('globalSearch',GlobalSearchController)
.controller('otherwiseController',OtherWiseController)
.controller('routercontroller',RouterController)
//filters 
.filter('percentage',[PercentageFilter.Factory])
//directives
.directive('swTypeahedSearch',SWTypeaheadSearch.Factory())
.directive('swActionCaller',SWActionCaller.Factory())
.directive('swActionCallerDropdown',SWActionCallerDropdown.Factory())
.directive('swColumnSorter',SWColumnSorter.Factory())
.directive('swConfirm',SWConfirm.Factory())
.directive('swEntityActionBar',SWEntityActionBar.Factory())
.directive('swEntityActionBarButtonGroup',SWEntityActionBarButtonGroup.Factory())
.directive('swExpandableRecord',SWExpandableRecord.Factory())
.directive('swListingDisplay',SWListingDisplay.Factory())
.directive('swListingColumn',SWListingColumn.Factory())
.directive('swLogin',SWLogin.Factory())
.directive('swNumbersOnly',SWNumbersOnly.Factory())
.directive('swValidate',SWValidate.Factory())
.directive('swvalidationminlength',SWValidationMinLength.Factory())
.directive('swLoading',SWLoading.Factory())
.directive('swScrollTrigger',SWScrollTrigger.Factory())
.directive('swRbkey',SWRbKey.Factory())
.directive('swOptions',SWOptions.Factory())
.directive('swSelection',SWSelection.Factory())
.directive('swClickOutside',SWClickOutside.Factory())
.directive('swDirective',SWDirective.Factory())
.directive('swExportAction',SWExportAction.Factory())
.directive('swHref',SWHref.Factory())
.directive('swProcessCaller',SWProcessCaller.Factory())
.directive('swresizedimage',SWResizedImage.Factory())
.directive('sw:sortable',SWSortable.Factory())
.directive('swDetail',SWDetail.Factory())
.directive('swList',SWList.Factory())
.directive('swvalidationdatatype',SWValidationDataType.Factory())
.directive('swvalidationeq',SWValidationEq.Factory())
;  
export{
	coremodule
}