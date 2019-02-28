
import { Component, Input, OnInit } from '@angular/core';
import { FormControl } from '@angular/forms';
import { UtilityService } from '../../core/services/utilityservice';
import { MetaDataService } from '../../core/services/metadataservice';
import { FormShareService } from '../services/formshareservice';

@Component({
    selector : 'sw-property-display-upgraded' ,
    templateUrl : '/org/Hibachi/client/src/form/components/propertydisplay_upgraded.html'
})
export class SwPropertyDisplay implements OnInit  {
        
    @Input() public form;
    @Input() public object;
    @Input("propertyidentifier") public propertyIdentifier : string;
    @Input() public editable : boolean;
    @Input() public editing : boolean;
    @Input() public context: string;
    @Input() public name:string;
    @Input() public optionsArguments;
    @Input() public eagerLoadOptions;
    @Input() public isdirty;
    public value : string = '';
    public fieldType : string;
    public inListingDisplay : boolean;
    public isHidden : boolean;
    public showLabel: boolean;
    public title: string;
    public labelText: string;
    public hint : string;
    public showSave: boolean;
    public rowSaveEnabled: boolean;
    public edit: boolean;
    public errors;
    public edited:boolean;
    public errorName;
    public initialValue;
    public propertyDisplayID;
    
    constructor(
        private utilityService: UtilityService,
        private metaDataService: MetaDataService,
        private formShareService: FormShareService
    ) {
        
    }
    
    ngOnInit() {
        
        this.formShareService.form$.subscribe((form)  => {
            this.form = form;
            if(this.value === undefined) {
                this.value = '';    
            }

            this.form.addControl(this.propertyIdentifier, new FormControl(this.value));
        });        
        
        this.errors = {};
        this.edited = false;
        this.edit = this.edit || this.editing;
        this.editing = this.editing || this.edit;        

        this.errorName = this.errorName || this.name;
        this.initialValue = this.object[this.propertyIdentifier];
        this.propertyDisplayID = this.utilityService.createID(32);
        
        if( this.showSave === undefined  ){
            this.showSave = true;
        }        
        if(this.inListingDisplay === undefined) {
            this.inListingDisplay = false;    
        }
        
        if(this.rowSaveEnabled === undefined){
            this.rowSaveEnabled = this.inListingDisplay;
        }
                
        if(this.fieldType === undefined && this.object && this.object.metaData) {
            this.fieldType = this.metaDataService.getPropertyFieldType(this.object,this.propertyIdentifier);
        }
        
        if(this.editing === undefined){
            this.editing = false;
        }
        if(this.editable === undefined){
            this.editable = true;
        }
        if(this.isHidden === undefined){
            this.isHidden = false;
        }
        if(this.context === undefined) {
            this.context = '';    
        }
        
        if( this.fieldType !== 'hidden' &&
            this.inListingDisplay === undefined  ||
            !this.inListingDisplay
        ){
            this.showLabel = true;
        } else {
            this.showLabel = false;
        }        
        
        if( this.title === undefined && this.object && this.object.metaData){
            this.labelText = this.metaDataService.getPropertyTitle(this.object,this.propertyIdentifier);
        }
        
        this.labelText = this.labelText || this.title;
        this.title = this.title || this.labelText;

        this.fieldType                  = this.fieldType || "text" ;
        //this.class              = this.class|| "form-control";
        //this.fieldAttributes        = this.fieldAttributes || "";
        //this.label              = this.label || "true";
        this.labelText          = this.labelText || "";
        //this.labelClass         = this.labelClass || "";
        //this.name                   = this.name || "unnamed";
        //this.value              = this.value || this.initialValue;
        
        if(this.hint === undefined && this.object && this.object.metaData){
            this.hint = this.metaDataService.getPropertyHintByObjectAndPropertyIdentifier(this.object,this.propertyIdentifier);
        }
    }
    
}