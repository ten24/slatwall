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
//directives
//  components

//form
import {SWInput} from "./components/swinput";
import {SWFFormField} from "./components/swfformfield";
import {SWForm} from "./components/swform";
import {SWFormField} from "./components/swformfield";
import {SWFormFieldJson} from "./components/swformfieldjson";
import {SWFormFieldRadio} from "./components/swformfieldradio";
import {SWFormFieldSearchSelect} from "./components/swformfieldsearchselect";
import {SWFormFieldSelect} from "./components/swformfieldselect";
import {SWFormRegistrar} from "./components/swformregistrar";
import {SWErrorDisplay} from "./components/swerrordisplay";

import {SWPropertyDisplay} from "./components/swpropertydisplay";
import {SWFPropertyDisplay} from "./components/swfpropertydisplay";
import {SWFormSubscriber} from "./components/swformsubscriber";

var formmodule = angular.module('hibachi.form',['angularjs-datetime-picker']).config(()=>{

})
.constant('coreFormPartialsPath','form/components/')


//directives
.directive('swInput',SWInput.Factory())
.directive('swfFormField',SWFFormField.Factory())
.directive('swForm',SWForm.Factory())
.directive('swFormField',SWFormField.Factory())
.directive('swFormFieldJson',SWFormFieldJson.Factory())
.directive('swFormFieldRadio',SWFormFieldRadio.Factory())
.directive('swFormFieldSearchSelect',SWFormFieldSearchSelect.Factory())
.directive('swFormFieldSelect',SWFormFieldSelect.Factory())
.directive('swFormRegistrar',SWFormRegistrar.Factory())
.directive('swfPropertyDisplay',SWFPropertyDisplay.Factory(SWFPropertyDisplay,"swfpropertydisplay.html"))
.directive('swPropertyDisplay',SWPropertyDisplay.Factory(SWPropertyDisplay,"propertydisplay.html"))
.directive('swErrorDisplay',SWErrorDisplay.Factory())
.directive('swFormSubscriber',SWFormSubscriber.Factory())

;
export{
	formmodule
}