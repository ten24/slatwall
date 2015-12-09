/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {AccountService} from "./services/accountservice";
import {CartService} from "./services/cartservice";
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
import {SWListingGlobalSearch} from "./components/swlistingglobalsearch";
//  entity
import {SWDetailTabs} from "./entity/swdetailtabs";
import {SWDetail} from "./entity/swdetail";
import {SWList} from "./entity/swlist";
//form
import {SWInput} from "./form/swinput";
import {SWFFormField} from "./form/swfformfield";
import {SWForm} from "./form/swform";
import {SWFormField} from "./form/swformfield";
import {SWFormFieldJson} from "./form/swformfieldjson";
import {SWFormFieldNumber} from "./form/swformfieldnumber";
import {SWFormFieldPassword} from "./form/swformfieldpassword";
import {SWFormFieldRadio} from "./form/swformfieldradio";
import {SWFormFieldSearchSelect} from "./form/swformfieldsearchselect";
import {SWFormFieldSelect} from "./form/swformfieldselect";
import {SWFormFieldText} from "./form/swformfieldtext";
import {SWFormRegistrar} from "./form/swformregistrar";
import {SWFPropertyDisplay} from "./form/swfpropertydisplay";
import {SWPropertyDisplay} from "./form/swpropertydisplay";
//  validation
import {SWValidate} from "./validation/swvalidate";
import {SWValidationMinLength} from "./validation/swvalidationminlength";
import {SWValidationDataType} from "./validation/swvalidationdatatype";
import {SWValidationEq} from "./validation/swvalidationeq";
import {SWValidationGte} from "./validation/swvalidationgte";
import {SWValidationLte} from "./validation/swvalidationlte";
import {SWValidationMaxLength} from "./validation/swvalidationmaxlength";
import {SWValidationMaxValue} from "./validation/swvalidationmaxvalue";
import {SWValidationMinValue} from "./validation/swvalidationminvalue";
import {SWValidationNeq} from "./validation/swvalidationneq";
import {SWValidationNumeric} from "./validation/swvalidationnumeric";
import {SWValidationRegex} from "./validation/swvalidationregex";
import {SWValidationRequired} from "./validation/swvalidationrequired";
import {SWValidationUnique} from "./validation/swvalidationunique";
import {SWValidationUniqueOrNull} from "./validation/swvalidationuniqueornull";


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
.constant('coreEntityPartialsPath','core/entity/')
.constant('coreFormPartialsPath','core/form/')
.constant('coreValidationPartialsPath','core/validation/')
//services
.service('accountService',AccountService)
.service('cartService',CartService)
.service('utilityService',UtilityService)
.service('selectionService',SelectionService)
.service('observerService',ObserverService)
.service('formService',FormService)
.service('metadataService',MetaDataService)
//controllers
.controller('globalSearch',GlobalSearchController)
.controller('otherwiseController',OtherWiseController)
.controller('routerController',RouterController)
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
.directive('swListingGlobalSearch',SWListingGlobalSearch.Factory())

//entity
.directive('swDetail',SWDetail.Factory())
.directive('swDetailTabs',SWDetailTabs.Factory())
.directive('swList',SWList.Factory())
//form
.directive('swInput',SWInput.Factory())
.directive('swfFormField',SWFFormField.Factory())
.directive('swForm',SWForm.Factory())
.directive('swFormField',SWFormField.Factory())
.directive('swFormFieldJson',SWFormFieldJson.Factory())
.directive('swFormFieldNumber',SWFormFieldNumber.Factory())
.directive('swFormFieldPassword',SWFormFieldPassword.Factory())
.directive('swFormFieldRadio',SWFormFieldRadio.Factory())
.directive('swFormFieldSearchSelect',SWFormFieldSearchSelect.Factory())
.directive('swFormFieldSelect',SWFormFieldSelect.Factory())
.directive('swFormFieldText',SWFormFieldText.Factory())
.directive('swFormRegistrar',SWFormRegistrar.Factory())
.directive('swfPropertyDisplay',SWFPropertyDisplay.Factory())
.directive('swPropertyDisplay',SWPropertyDisplay.Factory())
//validation
.directive('swValidate',SWValidate.Factory())
.directive('swvalidationminlength',SWValidationMinLength.Factory())
.directive('swvalidationdatatype',SWValidationDataType.Factory())
.directive('swvalidationeq',SWValidationEq.Factory())
.directive("swvalidationgte", SWValidationGte.Factory())
.directive("swvalidationlte",SWValidationLte.Factory())
.directive('swvalidationmaxlength',SWValidationMaxLength.Factory())
.directive("swvalidationmaxvalue",SWValidationMaxValue.Factory())
.directive("swvalidationminvalue",SWValidationMinValue.Factory())
.directive("swvalidationneq",SWValidationNeq.Factory())
.directive("swvalidationnumeric",SWValidationNumeric.Factory())
.directive("swvalidationregex",SWValidationRegex.Factory())
.directive("swvalidationrequired",SWValidationRequired.Factory())
.directive("swvalidationunique",SWValidationUnique.Factory())
.directive("swvalidationuniqueornull",SWValidationUniqueOrNull.Factory())
;
export{
	coremodule
}