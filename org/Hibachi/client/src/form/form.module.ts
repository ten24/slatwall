/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//services
// import {AccountService} from "./services/accountservice";
// import {CartService} from "./services/cartservice";
// import {UtilityService} from "./services/utilityservice";
// import {SelectionService} from "./services/selectionservice";
// import {ObserverService} from "./services/observerservice";
// import {FormService} from "./services/formservice";
// import {MetaDataService} from "./services/metadataservice";
import {FileService} from "./services/fileservice"; 
//directives
//  components
//form
import {SWInput} from "./components/swinput";
import {SWFFormField} from "./components/swfformfield";
import {SWForm} from "./components/swform";
import {SWFormField} from "./components/swformfield";
import {SWFormFieldJson} from "./components/swformfieldjson";
import {SWFormFieldNumber} from "./components/swformfieldnumber";
import {SWFormFieldCurrency} from "./components/swformfieldcurrency"
import {SWFormFieldPassword} from "./components/swformfieldpassword";
import {SWFormFieldRadio} from "./components/swformfieldradio";
import {SWFormFieldRevertHelper} from "./components/swformfieldreverthelper";
import {SWFormFieldSearchSelect} from "./components/swformfieldsearchselect";
import {SWFormFieldSelect} from "./components/swformfieldselect";
import {SWFormFieldSingleEdit} from "./components/swformfieldsingleedit";
import {SWFormFieldText} from "./components/swformfieldtext";
import {SWFormFieldDate} from "./components/swformfielddate";
import {SWFormFieldFile} from "./components/swformfieldfile";
import {SWFormRegistrar} from "./components/swformregistrar";
import {SWFPropertyDisplay} from "./components/swfpropertydisplay";
import {SWPropertyDisplay} from "./components/swpropertydisplay";


var formmodule = angular.module('hibachi.form',['angularjs-datetime-picker']).config(()=>{

})
.constant('coreFormPartialsPath','form/components/')

.service('fileService',FileService)
//directives
.directive('swInput',SWInput.Factory())
.directive('swfFormField',SWFFormField.Factory())
.directive('swForm',SWForm.Factory())
.directive('swFormField',SWFormField.Factory())
.directive('swFormFieldJson',SWFormFieldJson.Factory())
.directive('swFormFieldNumber',SWFormFieldNumber.Factory())
.directive('swFormFieldCurrency',SWFormFieldCurrency.Factory())
.directive('swFormFieldPassword',SWFormFieldPassword.Factory())
.directive('swFormFieldRadio',SWFormFieldRadio.Factory())
.directive('swFormFieldRevertHelper',SWFormFieldRevertHelper.Factory())
.directive('swFormFieldSearchSelect',SWFormFieldSearchSelect.Factory())
.directive('swFormFieldSelect',SWFormFieldSelect.Factory())
.directive('swFormFieldSingleEdit',SWFormFieldSingleEdit.Factory())
.directive('swFormFieldText',SWFormFieldText.Factory())
.directive('swFormFieldDate',SWFormFieldDate.Factory())
.directive('swFormFieldFile', SWFormFieldFile.Factory())
.directive('swFormRegistrar',SWFormRegistrar.Factory())
.directive('swfPropertyDisplay',SWFPropertyDisplay.Factory())
.directive('swPropertyDisplay',SWPropertyDisplay.Factory())

;
export{
	formmodule
}