/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

/**
* Form Controller handles the logic for this directive.
*/
import {SWPropertyDisplayController} from "./swpropertydisplay";
import {SWFPropertyDisplayController} from "./swfpropertydisplay";
import {SWFormController} from "./swform";

class SWErrorDisplayController {
    public swPropertyDisplay:SWPropertyDisplayController;
    public swfPropertyDisplay:SWFPropertyDisplayController;
    public swForm:SWFormController;
    public property:string;
    public propertyIdentifier:string;
    public name:string;
    //@ngInject
   constructor(public $injector){
       this.$injector = $injector;
   }
   public $onInit(){
       var bindToControllerProps = this.$injector.get('swErrorDisplayDirective')[0].bindToController;
		for(var i in bindToControllerProps){

			if(!this[i] && i !== 'name'){
                
				if(!this[i] && this.swPropertyDisplay && this.swPropertyDisplay[i]){
					this[i] = this.swPropertyDisplay[i]
				}else if(!this[i] && this.swfPropertyDisplay && this.swfPropertyDisplay[i]){
					this[i] = this.swfPropertyDisplay[i]
				}else if(!this[i] && this.swForm && this.swForm[i]){
					this[i] = this.swForm[i];
				}
			}
		}

        this.property = this.property || this.propertyIdentifier;
        this.propertyIdentifier = this.propertyIdentifier || this.property;
        if(!this.name && this.property){
            this.name = this.property;
        }
   }
}

class SWErrorDisplay implements ng.IDirective {
    public templateUrl:string;
    public require={
        swForm:"^?swForm",
        form:"^?form",
        swPropertyDisplay:"^?swPropertyDisplay",
        swfPropertyDisplay:"^?swfPropertyDisplay"
    }
    public restrict="E";
    public controller = SWErrorDisplayController;
    public controllerAs = "swErrorDisplay";
    public scope = {};
    public bindToController={
        form:"=?",
        name:"@?",
        property:"@?",
        propertyIdentifier:"@?",
        errorClass:"@?"
    }

    // @ngInject
    constructor( public coreFormPartialsPath, public hibachiPathBuilder) {
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "errordisplay.html";
    }

    public static Factory(){
		var directive = (
		 	coreFormPartialsPath,
				hibachiPathBuilder
		)=>new SWErrorDisplay(
			coreFormPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'coreFormPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
}
export{
    SWErrorDisplay,
    SWErrorDisplayController
}
