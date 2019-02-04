
import { Component, Input, OnInit } from '@angular/core';
import { UtilityService } from '../../core/services/utilityservice';
import { $Hibachi } from '../../core/services/hibachiservice';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
    selector : 'sw-workflow-basic-upgraded',
    templateUrl : '/org/Hibachi/client/src/workflow/components/workflowbasic_upgraded.html'    
})
export class SwWorkflowBasic implements OnInit {
    
    @Input() public object;
    //public object;
    @Input() public name : string;
    @Input() public context:string;
    public value;
    public options;
    public selectType;
    public optionsArguments;
    public propertyIdentifier;
    public form: FormGroup;
    public selectedRadioFormName;
    public selected;
    public radioOptions;
        
    constructor(
        private formBuilder: FormBuilder,
        private utilityService : UtilityService,
        private $hibachi : $Hibachi
    ) {
        
    }
    
    ngOnInit() {
        console.log(this.object);
        debugger;
        //this.value = this.utilityService.getPropertyValue(this.object,this.propertyIdentifier);
        //this.object = { ...this.object_original };
//        this.value = this.utilityService.getPropertyValue(this.object,"workflowName");
//
//        this.form = this.formBuilder.group({
//            "workflowName": [this.value, Validators.required]
//        });
        
        this.form = this.formBuilder.group({
            // empty form object    
        });
        
        this.selectStrategy();
        this.yesnoStrategy();
    }

    public selectStrategy = ()=>{
        //this is specific to the admin because it implies loading of options via api
        if(angular.isDefined(this.object.metaData) && angular.isDefined(this.object.metaData["workflowObject"]) && angular.isDefined(this.object.metaData["workflowObject"].fieldtype)){
            this.selectType = 'object';
        }else{
            this.selectType = 'string';
        }
        this.getOptions();
    }

    public getOptions = ()=>{
        this.propertyIdentifier = 'workflowObject';
        if(angular.isUndefined(this.options)){
            
            if(!this.optionsArguments || !this.optionsArguments.hasOwnProperty('propertyIdentifier')){
                this.optionsArguments={
                    'propertyIdentifier':this.propertyIdentifier
                };
            }

            var optionsPromise = this.$hibachi.getPropertyDisplayOptions(this.object.metaData.className,
                this.optionsArguments
            );
            optionsPromise.then((value)=>{
                this.options = value.data;
                
                if(this.selectType === 'object'
                ){

                    if(angular.isUndefined(this.object.data[this.propertyIdentifier])){
                        this.object.data[this.propertyIdentifier] = this.$hibachi['new'+this.object.metaData[this.propertyIdentifier].cfc]();
                    }

                    if(this.object.data[this.propertyIdentifier].$$getID() === ''){
                        this.object.data['selected'+this.propertyIdentifier] = this.options[0];
                        this.object.data[this.propertyIdentifier] = this.$hibachi['new'+this.object.metaData[this.propertyIdentifier].cfc]();
                        this.object.data[this.propertyIdentifier]['data'][this.object.data[this.propertyIdentifier].$$getIDName()] = this.options[0].value;
                    }else{
                        var found = false;
                        for(var i in this.options){
                            if(angular.isObject(this.options[i].value)){
                                if(this.options[i].value === this.object.data[this.propertyIdentifier]){
                                    this.object.data['selected'+this.propertyIdentifier] = this.options[i];
                                    this.object.data[this.propertyIdentifier] = this.options[i].value;
                                    found = true;
                                    break;
                                }
                            }else{
                                if(this.options[i].value === this.object.data[this.propertyIdentifier].$$getID()){
                                    this.object.data['selected'+this.propertyIdentifier] = this.options[i];
                                    this.object.data[this.propertyIdentifier]['data'][this.object.data[this.propertyIdentifier].$$getIDName()] = this.options[i].value;
                                    found = true;
                                    break;
                                }
                            }
                            if(!found){
                                this.object.data['selected'+this.propertyIdentifier] = this.options[0];
                            }
                        }

                    }
                } else if(this.selectType === 'string'){
                    if(this.object.data[this.propertyIdentifier] !== null){
                        for(var i in this.options){
                            if(this.options[i].value === this.object.data[this.propertyIdentifier]){
                                this.object.data['selected'+this.propertyIdentifier] = this.options[i];
                                this.object.data[this.propertyIdentifier] = this.options[i].value;
                                
                            }
                        }

                    } else{

                        this.object.data['selected'+this.propertyIdentifier] = this.options[0];
                        this.object.data[this.propertyIdentifier] = this.options[0].value;
                    }

                }

            });
        }

    }
    
    public yesnoStrategy = ()=>{
        //format value

        this.selectedRadioFormName = this.utilityService.createID(26);
//        this.object.data[this.propertyIdentifier] = (
//            this.object.data[this.propertyIdentifier]
//            && this.object.data[this.propertyIdentifier].length
//            && this.object.data[this.propertyIdentifier].toLowerCase().trim() === 'yes'
//        ) || this.object.data[this.propertyIdentifier] == 1 ? 1 : 0;

        
        this.object.data['activeFlag'] = (
            this.object.data['activeFlag']
            && this.object.data['activeFlag'].length
            && this.object.data['activeFlag'].toLowerCase().trim() === 'yes'
        ) || this.object.data['activeFlag'] == 1 ? 1 : 0;
        this.radioOptions = [
            {
                name:'Yes',
                value:1
            },
            {
                name:'No',
                value:0
            }
        ];

        if(angular.isDefined(this.object.data['activeFlag'])){

            for(var i in this.radioOptions){
                if(this.radioOptions[i].value === this.object.data['activeFlag']){
                    this.selected = this.radioOptions[i];
                    this.object.data['activeFlag'] = this.radioOptions[i].value;
                }
            }
        }else{
            this.selected = this.radioOptions[0];
            this.object.data['activeFlag'] = this.radioOptions[0].value;
        }

//        this.$timeout(()=>{
//            this.form[this.propertyIdentifier].$dirty = this.isDirty;
//        });
    }
}