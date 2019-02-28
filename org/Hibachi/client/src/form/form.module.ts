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
import {FormShareService} from "./services/formshareservice";

//directives

//  components

//form
import {SWInput, SwInput} from "./components/swinput";
import {SWFFormField} from "./components/swfformfield";
import {SWForm} from "./components/swform";
import {SwForm} from "./components/swform_upgraded";
import {SWFForm} from "./components/swfform";
import {SWFFileInput} from "./components/swffileinput";
import {SWFormField} from "./components/swformfield";
import {SwFormField} from "./components/swformfield_upgraded";
import {SWFormFieldFile} from "./components/swformfieldfile";
import {SWFormFieldJson} from "./components/swformfieldjson";
import {SWFormFieldSearchSelect} from "./components/swformfieldsearchselect";
import {SWFormRegistrar} from "./components/swformregistrar";
import {SWErrorDisplay, SwErrorDisplay} from "./components/swerrordisplay";
import {SWAddressForm} from "./components/swaddressform";
import {SWPropertyDisplay} from "./components/swpropertydisplay";
import {SwPropertyDisplay} from "./components/swpropertydisplay_upgraded";
import {SWFPropertyDisplay} from "./components/swfpropertydisplay";
import {SWFormSubscriber} from "./components/swformsubscriber";

import {SwWorkflowBasic} from "../workflow/components/swworkflowbasic_upgraded";

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
        FileService,
        FormShareService
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
        SwForm,
        SwWorkflowBasic,
        SwPropertyDisplay,
        SwFormField
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
.directive('swFormUpgrade', downgradeComponent({ component: SwForm }) as angular.IDirectiveFactory )
.directive('swWorkflowBasicUpgrade', downgradeComponent({ component: SwWorkflowBasic }) as angular.IDirectiveFactory )
.directive('swfForm',SWFForm.Factory())
.directive('swfFileInput',SWFFileInput.Factory())
.directive('swFormField',SWFormField.Factory())
.directive('swFormFieldUpgraded', downgradeComponent({ component: SwFormField }) as angular.IDirectiveFactory )
.directive('swFormFieldFile',SWFormFieldFile.Factory())
.directive('swFormFieldJson',SWFormFieldJson.Factory())
.directive('swFormFieldSearchSelect',SWFormFieldSearchSelect.Factory())
.directive('swFormRegistrar',SWFormRegistrar.Factory())
.directive('swfPropertyDisplay',SWFPropertyDisplay.Factory(SWFPropertyDisplay,"swfpropertydisplay.html"))
.directive('swPropertyDisplay',SWPropertyDisplay.Factory(SWPropertyDisplay,"propertydisplay.html"))
.directive('swPropertyDisplayUpgraded', downgradeComponent({ component: SwPropertyDisplay }) as angular.IDirectiveFactory )
.directive('swErrorDisplay',SWErrorDisplay.Factory())
.directive('swAddressForm',SWAddressForm.Factory())
.directive('swFormSubscriber',SWFormSubscriber.Factory());

export{
	formmodule
}