/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

import {HibachiInterceptor,IHibachi,IHibachiConfig,HibachiJQueryStatic} from "./services/hibachiinterceptor";
//constant
import {HibachiPathBuilder} from "./services/hibachipathbuilder";

//services
import {PublicService} from "./services/publicservice";
import {AccountService} from "./services/accountservice";
import {CartService} from "./services/cartservice";
import {UtilityService} from "./services/utilityservice";
import {SelectionService} from "./services/selectionservice";
import {ObserverService} from "./services/observerservice";
import {OrderService} from "./services/orderservice";
import {OrderPaymentService} from "./services/orderpaymentservice";
import {FormService} from "./services/formservice";
import {ExpandableService} from "./services/expandableservice";
import {MetaDataService} from "./services/metadataservice";
import {RbKeyService} from "./services/rbkeyservice";
import {$Hibachi} from "./services/hibachiservice";
import {LocalStorageService} from "./services/localstorageservice";
import {HibachiServiceDecorator} from "./services/hibachiservicedecorator";
import {HibachiScope} from "./services/hibachiscope";
import {RequestService} from "./services/requestservice";
import {HibachiValidationService} from "./services/hibachivalidationservice";
import {EntityService} from "./services/entityservice";
//controllers
import {GlobalSearchController} from "./controllers/globalsearch";

//filters
import {PercentageFilter} from "./filters/percentage";
import {EntityRBKey} from "./filters/entityrbkey";
import {SWTrim} from "./filters/swtrim";
import {DateFilter} from "./filters/datefilter";
//directives
//  components
import {SWActionCaller} from "./components/swactioncaller";
import {SWTypeaheadSearch} from "./components/swtypeaheadsearch";
import {SWTypeaheadInputField} from "./components/swtypeaheadinputfield";
import {SWTypeaheadSearchLineItem} from "./components/swtypeaheadsearchlineitem";
import {SWCollectionConfig} from "./components/swcollectionconfig";
import {SWCollectionFilter} from "./components/swcollectionfilter";
import {SWCollectionColumn} from "./components/swcollectioncolumn";
import {SWActionCallerDropdown} from "./components/swactioncallerdropdown";
import {SWColumnSorter} from "./components/swcolumnsorter";
import {SWConfirm} from "./components/swconfirm";
import {SWEntityActionBar} from "./components/swentityactionbar";
import {SWEntityActionBarButtonGroup} from "./components/swentityactionbarbuttongroup";
import {SWExpandableRecord} from "./components/swexpandablerecord";
import {SWGravatar} from "./components/swgravatar";
import {SWListingDisplay} from "./components/swlistingdisplay";
import {SWListingControls} from "./components/swlistingcontrols";
import {SWListingAggregate} from "./components/swlistingaggregate";
import {SWListingColorFilter} from "./components/swlistingcolorfilter";
import {SWListingColumn} from "./components/swlistingcolumn";
import {SWListingFilter} from "./components/swlistingfilter";
import {SWListingFilterGroup} from "./components/swlistingfiltergroup";
import {SWListingOrderBy} from "./components/swlistingorderby";
import {SWLogin} from "./components/swlogin";
import {SWNumbersOnly} from "./components/swnumbersonly";
import {SWLoading} from "./components/swloading";
import {SWScrollTrigger} from "./components/swscrolltrigger";
import {SWTooltip} from "./components/swtooltip";
import {SWRbKey} from "./components/swrbkey";
import {SWOptions} from "./components/swoptions";
import {SWSelection} from "./components/swselection";
import {SWClickOutside} from "./components/swclickoutside";
import {SWDirective} from "./components/swdirective";
import {SWExportAction} from "./components/swexportaction";
import {SWHref} from "./components/swhref";
import {SWProcessCaller} from "./components/swprocesscaller";
import {SWSortable} from "./components/swsortable";
import {SWListingGlobalSearch} from "./components/swlistingglobalsearch";
import {BaseObject} from "./model/baseobject";
declare var $:any;

var coremodule = angular.module('hibachi.core',[
  //Angular Modules
  'ngAnimate',
  'ngSanitize',
  //3rdParty modules
  'ui.bootstrap'
]).config(['$httpProvider','$logProvider','$filterProvider','$provide','hibachiPathBuilder','appConfig',($httpProvider,$logProvider,$filterProvider,$provide,hibachiPathBuilder,appConfig)=>{
    hibachiPathBuilder.setBaseURL(appConfig.baseURL);
    hibachiPathBuilder.setBasePartialsPath('/org/Hibachi/client/src/');

    $logProvider.debugEnabled( appConfig.debugFlag );
     $filterProvider.register('likeFilter',function(){
         return function(text){
             if(angular.isDefined(text) && angular.isString(text)){
                 return text.replace(new RegExp('%', 'g'), '');

             }
         };
     });
     //This filter is used to shorten a string by removing the charecter count that is passed to it and ending it with "..."
     $filterProvider.register('truncate',function(){
         return function (input, chars, breakOnWord) {
             if (isNaN(chars)) return input;
             if (chars <= 0) return '';
             if (input && input.length > chars) {
                 input = input.substring(0, chars);
                 if (!breakOnWord) {
                     var lastspace = input.lastIndexOf(' ');
                     //get last space
                     if (lastspace !== -1) {
                         input = input.substr(0, lastspace);
                     }
                 }else{
                     while(input.charAt(input.length-1) === ' '){
                         input = input.substr(0, input.length -1);
                     }
                 }
                 return input + '...';
             }
             return input;
         };
     });
     //This filter is used to shorten long string but unlike "truncate", it removes from the start of the string and prepends "..."
     $filterProvider.register('pretruncate',function(){
         return function (input, chars, breakOnWord) {
             if (isNaN(chars)) return input;
             if (chars <= 0) return '';
             if (input && input.length > chars) {
                 input = input.slice('-' + chars);
                //  input = input.substring(0, chars);
                 if (!breakOnWord) {
                     var lastspace = input.lastIndexOf(' ');
                     //get last space
                     if (lastspace !== -1) {
                         input = input.substr(0, lastspace);
                     }
                 }else{
                     while(input.charAt(input.length-1) === ' '){
                         input = input.substr(0, input.length -1);
                     }
                 }
                 return '...' + input;
             }
             return input;
         };
     });


    hibachiPathBuilder.setBaseURL(appConfig.baseURL);
    hibachiPathBuilder.setBasePartialsPath('/org/Hibachi/client/src/');
   // $provide.decorator('$hibachi',
     $httpProvider.interceptors.push('hibachiInterceptor');
}])
.run(['$rootScope','$hibachi', '$route', '$location',($rootScope,$hibachi, $route, $location)=>{
    $rootScope.buildUrl = $hibachi.buildUrl;
    var original = $location.path;
    $location.path = function (path, reload) {
        if (reload === false) {
            var lastRoute = $route.current;
            var un = $rootScope.$on('$locationChangeSuccess', function () {
                $route.current = lastRoute;
                un();
            });
        }
        return original.apply($location, [path]);
    };
}])
.constant('hibachiPathBuilder',new HibachiPathBuilder())
.constant('corePartialsPath','core/components/')
//services
.service('publicService',PublicService)
.service('utilityService',UtilityService)
.service('selectionService',SelectionService)
.service('observerService',ObserverService)
.service('expandableService',ExpandableService)
.service('formService',FormService)
.service('metadataService',MetaDataService)
.service('rbkeyService',RbKeyService)
.provider('$hibachi',$Hibachi)
.decorator('$hibachi',HibachiServiceDecorator)
.service('hibachiInterceptor', HibachiInterceptor.Factory())
.service('hibachiScope',HibachiScope)
.service('localStorageService',LocalStorageService)
.service('requestService',RequestService)
.service('accountService',AccountService)
.service('orderService',OrderService)
.service('orderPaymentService',OrderPaymentService)
.service('cartService',CartService)
.service('hibachiValidationService',HibachiValidationService)
.service('entityService',EntityService)
//controllers
.controller('globalSearch',GlobalSearchController)
//filters
.filter('dateFilter',['$filter',DateFilter.Factory])
.filter('percentage',[PercentageFilter.Factory])
.filter('trim', [SWTrim.Factory])
.filter('entityRBKey',['rbkeyService',EntityRBKey.Factory])
//directives
.directive('swCollectionConfig',SWCollectionConfig.Factory())
.directive('swCollectionColumn',SWCollectionColumn.Factory())
.directive('swCollectionFilter',SWCollectionFilter.Factory())
.directive('swTypeaheadSearch',SWTypeaheadSearch.Factory())
.directive('swTypeaheadInputField',SWTypeaheadInputField.Factory())
.directive('swTypeaheadSearchLineItem', SWTypeaheadSearchLineItem.Factory())
.directive('swActionCaller',SWActionCaller.Factory())
.directive('swActionCallerDropdown',SWActionCallerDropdown.Factory())
.directive('swColumnSorter',SWColumnSorter.Factory())
.directive('swConfirm',SWConfirm.Factory())
.directive('swEntityActionBar',SWEntityActionBar.Factory())
.directive('swEntityActionBarButtonGroup',SWEntityActionBarButtonGroup.Factory())
.directive('swExpandableRecord',SWExpandableRecord.Factory())
.directive('swGravatar', SWGravatar.Factory())
.directive('swListingDisplay',SWListingDisplay.Factory())
.directive('swListingControls',SWListingControls.Factory())
.directive('swListingAggregate',SWListingAggregate.Factory())
.directive('swListingColorFilter',SWListingColorFilter.Factory())
.directive('swListingColumn',SWListingColumn.Factory())
.directive('swListingFilter',SWListingFilter.Factory())
.directive('swListingFilterGroup',SWListingFilterGroup.Factory())
.directive('swListingOrderBy',SWListingOrderBy.Factory())
.directive('swLogin',SWLogin.Factory())
.directive('swNumbersOnly',SWNumbersOnly.Factory())
.directive('swLoading',SWLoading.Factory())
.directive('swScrollTrigger',SWScrollTrigger.Factory())
.directive('swRbkey',SWRbKey.Factory())
.directive('swOptions',SWOptions.Factory())
.directive('swSelection',SWSelection.Factory())
.directive('swTooltip', SWTooltip.Factory())
.directive('swClickOutside',SWClickOutside.Factory())
.directive('swDirective',SWDirective.Factory())
.directive('swExportAction',SWExportAction.Factory())
.directive('swHref',SWHref.Factory())
.directive('swProcessCaller',SWProcessCaller.Factory())
.directive('sw:sortable',SWSortable.Factory())
.directive('swListingGlobalSearch',SWListingGlobalSearch.Factory())
;
export{
	coremodule
}
