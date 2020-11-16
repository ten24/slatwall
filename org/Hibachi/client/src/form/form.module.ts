/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//module
import {coremodule} from "../core/core.module";
//services
import {FileService} from "./services/fileservice"; 
//directives
//  components
//form
import {SWInput} from "./components/swinput";
import {SWFFormField} from "./components/swfformfield";
import {SWForm} from "./components/swform";
import {SWFForm} from "./components/swfform";
import {SWFSelect} from "./components/swfselect";
import {SWFFileInput} from "./components/swffileinput";
import {SWFormField} from "./components/swformfield";
import {SWFormFieldFile} from "./components/swformfieldfile";
import {SWFormFieldJson} from "./components/swformfieldjson";
import {SWFormFieldSearchSelect} from "./components/swformfieldsearchselect";
import {SWFormRegistrar} from "./components/swformregistrar";
import {SWErrorDisplay} from "./components/swerrordisplay";
import {SWAddressForm} from "./components/swaddressform";
import {SWIsolateChildForm} from "./components/swisolatechildform";
import {SWPropertyDisplay} from "./components/swpropertydisplay";
import {SWFPropertyDisplay} from "./components/swfpropertydisplay";
import {SWSimplePropertyDisplay} from "./components/swsimplepropertydisplay";
import {SWFormSubscriber} from "./components/swformsubscriber";
import {SWVerifyAddressDialog} from "./components/swverifyaddressdialog";
import {SWCollectionConfigAsProperty} from "./components/swcollectionconfigasproperty";

var formmodule = angular.module('hibachi.form',['angularjs-datetime-picker',coremodule.name]).config(()=>{

})
.constant('coreFormPartialsPath','form/components/')

.service('fileService',FileService)
//directives
.directive('swInput',SWInput.Factory())
.directive('swfFormField',SWFFormField.Factory())
.directive('swForm',SWForm.Factory())
.directive('swfForm',SWFForm.Factory())
.directive('swfSelect',SWFSelect.Factory())
.directive('swfFileInput',SWFFileInput.Factory())
.directive('swFormField',SWFormField.Factory())
.directive('swFormFieldFile',SWFormFieldFile.Factory())
.directive('swFormFieldJson',SWFormFieldJson.Factory())
.directive('swFormFieldSearchSelect',SWFormFieldSearchSelect.Factory())
.directive('swFormRegistrar',SWFormRegistrar.Factory())
.directive('swfPropertyDisplay',SWFPropertyDisplay.Factory(SWFPropertyDisplay,"swfpropertydisplay.html"))
.directive('swPropertyDisplay',SWPropertyDisplay.Factory(SWPropertyDisplay,"propertydisplay.html"))
.directive('swSimplePropertyDisplay',SWSimplePropertyDisplay.Factory(SWSimplePropertyDisplay,"simplepropertydisplay.html"))
.directive('swErrorDisplay',SWErrorDisplay.Factory())
.directive('swIsolateChildForm', SWIsolateChildForm.Factory())
.directive('swAddressForm',SWAddressForm.Factory())
.directive('swCollectionConfigAsProperty',SWCollectionConfigAsProperty.Factory())
.directive('swVerifyAddressDialog',SWVerifyAddressDialog.Factory())
.directive('swFormSubscriber',SWFormSubscriber.Factory());

export{
	formmodule
}