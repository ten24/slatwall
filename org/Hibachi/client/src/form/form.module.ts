/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//module
import {coremodule} from "../core/core.module";
import {CoreModule} from "../core/core.module";

import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {UpgradeModule,downgradeInjectable, downgradeComponent} from '@angular/upgrade/static';

//services
import {FileService} from "./services/fileservice"; 

//directives

//  components

//form
import {SWInput, SwInput} from "./components/swinput";
import {SWFFormField} from "./components/swfformfield";
import {SWForm,SwForm} from "./components/swform";
import {SWFForm} from "./components/swfform";
import {SWFFileInput} from "./components/swffileinput";
import {SWFormField, SwFormField} from "./components/swformfield";
import {SWFormFieldFile} from "./components/swformfieldfile";
import {SWFormFieldJson} from "./components/swformfieldjson";
import {SWFormFieldSearchSelect} from "./components/swformfieldsearchselect";
import {SWFormRegistrar} from "./components/swformregistrar";
import {SWErrorDisplay, SwErrorDisplay} from "./components/swerrordisplay";
import {SWAddressForm} from "./components/swaddressform";
import {SWPropertyDisplay, SwPropertyDisplay} from "./components/swpropertydisplay";
import {SWFPropertyDisplay} from "./components/swfpropertydisplay";
import {SWFormSubscriber} from "./components/swformsubscriber";

import {SwWorkflowBasic} from "../workflow/components/swworkflowbasic";

@NgModule({
    declarations: [
        SwForm,
        SwErrorDisplay,
        SwWorkflowBasic,
        SwPropertyDisplay,
        SwFormField,
        SwInput
    ],
    providers: [
        FileService
    ],  
    imports: [
        CommonModule,
        UpgradeModule,
        ReactiveFormsModule,
        FormsModule,
        CoreModule
    ],
    exports: [
    
    ],
    entryComponents: [
        SwForm
    ]  
})

export class FormModule{
    constructor() {
        
    }    
}


var formmodule = angular.module('hibachi.form',['angularjs-datetime-picker',coremodule.name]).config(()=>{

})
.constant('coreFormPartialsPath','form/components/')

.service('fileService',downgradeInjectable(FileService))
//directives
.directive('swInput',SWInput.Factory())
.directive('swfFormField',SWFFormField.Factory())
.directive('swForm',SWForm.Factory())
.directive('swFormUpgraded', downgradeComponent({ component: SwForm }) as angular.IDirectiveFactory )
.directive('swfForm',SWFForm.Factory())
.directive('swfFileInput',SWFFileInput.Factory())
.directive('swFormField',SWFormField.Factory())
.directive('swFormFieldFile',SWFormFieldFile.Factory())
.directive('swFormFieldJson',SWFormFieldJson.Factory())
.directive('swFormFieldSearchSelect',SWFormFieldSearchSelect.Factory())
.directive('swFormRegistrar',SWFormRegistrar.Factory())
.directive('swfPropertyDisplay',SWFPropertyDisplay.Factory(SWFPropertyDisplay,"swfpropertydisplay.html"))
.directive('swPropertyDisplay',SWPropertyDisplay.Factory(SWPropertyDisplay,"propertydisplay.html"))
.directive('swErrorDisplay',SWErrorDisplay.Factory())
.directive('swAddressForm',SWAddressForm.Factory())
.directive('swFormSubscriber',SWFormSubscriber.Factory());

export{
	formmodule
}