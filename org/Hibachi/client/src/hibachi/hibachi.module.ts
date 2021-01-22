/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
import {alertmodule} from "../alert/alert.module";
import {dialogmodule} from "../dialog/dialog.module";
import {entitymodule} from "../entity/entity.module";
import {paginationmodule} from "../pagination/pagination.module";
import {formmodule} from "../form/form.module";
import {validationmodule} from "../validation/validation.module";

//directives
import {SWSaveAndFinish} from "./components/swsaveandfinish";

var hibachimodule = angular.module('hibachi',[
    alertmodule.name,
    entitymodule.name,
    dialogmodule.name,
    paginationmodule.name,
    formmodule.name,
    validationmodule.name,
])
.run(['$rootScope','publicService','$hibachi','localStorageService','isAdmin', ($rootScope, publicService, $hibachi, localStorageService, isAdmin)=> {
    $rootScope.hibachiScope = publicService;
    $rootScope.hasAccount = publicService.hasAccount;
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
