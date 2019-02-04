
import { Component, Input, OnInit } from '@angular/core';
import { $Hibachi } from '../../core/services/hibachiservice';

@Component({
    selector    : 'sw-form-upgraded',
    templateUrl : '/org/Hibachi/client/src/form/components/form_upgraded.html'
})
export class SwForm implements OnInit {
    
    @Input() public object : any;
    @Input() public name : string; // Workflow.basic.html
    public context:string;
    public entityName:string;
    public isDirty: boolean;
    public isProcessForm:boolean|string;
    
    constructor(
        private $hibachi: $Hibachi
    ) {
        
    }
    
    ngOnInit() {
        debugger;
        if(angular.isUndefined(this.isDirty)){
            this.isDirty = false;
        }        
        
        //object can be either an instance or a string that will become an instance
        if(typeof this.object === 'string'){
            var objectNameArray = this.object.split('_');
            this.entityName = objectNameArray[0];
            //if the object name array has two parts then we can infer that it is a process object
            if(objectNameArray.length > 1){
                this.context = this.context || objectNameArray[1];
                this.isProcessForm = true;
            }else{
                this.context = this.context || 'save';
                this.isProcessForm = false;
            }
            //convert the string to an object
            setTimeout( ()=> {

                this.object = this.$hibachi['new'+this.object]();
            });
        }else{
            if(this.object && this.object.metaData){
                this.isProcessForm = this.object.metaData.isProcessObject;
                this.entityName = this.object.metaData.className.split('_')[0];
                if(this.isProcessForm){
                    this.context = this.context || this.object.metaData.className.split('_')[1];
                }else{
                    this.context = this.context || 'save';
                }
            }
        }
        
        this.context = this.context || this.name;
    }

    public isObject=()=>{
        return (angular.isObject(this.object));
    }
    
}