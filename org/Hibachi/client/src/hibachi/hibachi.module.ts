/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//import alertmodule = require('./alert/alert.module');
import {alertmodule} from "../alert/alert.module";
import {cardmodule} from "../card/card.module";
import {collectionmodule} from "../collection/collection.module";
import {listingmodule} from "../listing/listing.module";
import {dialogmodule} from "../dialog/dialog.module";
import {entitymodule} from "../entity/entity.module";
import {paginationmodule} from "../pagination/pagination.module";
import {formmodule} from "../form/form.module";
import {validationmodule} from "../validation/validation.module";
import {workflowmodule} from "../workflow/workflow.module";

//directives
import {SWSaveAndFinish} from "./components/swsaveandfinish";

var hibachimodule = angular.module('hibachi',[
    alertmodule.name,
    cardmodule.name,
    collectionmodule.name,
    entitymodule.name,
    dialogmodule.name,
    listingmodule.name,
    paginationmodule.name,
    formmodule.name,
    validationmodule.name,
    workflowmodule.name
]).config([()=>{

}])
.run(['$rootScope','publicService','$hibachi','localStorageService', ($rootScope, publicService, $hibachi, localStorageService)=> {

    $rootScope.hibachiScope = publicService;
    $rootScope.hasAccount = publicService.hasAccount;
    if($hibachi.newAccount){
        $rootScope.hibachiScope.getAccount();
    }
    if($hibachi.newOrder){
        $rootScope.hibachiScope.getCart();
    }
    if($hibachi.newCountry){
        $rootScope.hibachiScope.getCountries();
    }
    if($hibachi.newState){
        $rootScope.hibachiScope.getStates();
    }
    if($hibachi.newState){
        $rootScope.hibachiScope.getAddressOptions();
    }

    if(localStorageService.hasItem('selectedPersonalCollection')){
        $rootScope.hibachiScope.selectedPersonalCollection = angular.fromJson(localStorageService.getItem('selectedPersonalCollection'));
    }

}])
.constant('hibachiPartialsPath','hibachi/components/')
.directive('swSaveAndFinish',SWSaveAndFinish.Factory())
;

export{
    hibachimodule
};
