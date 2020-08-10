/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSimplePropertyDisplayController {
   
    public edit:string;
    public title:string; 
    public object:any;
    public property:string; 
    public value:string;
    public displayType:string;
    public currencyFlag:string;
    public currencyCode:string;
    public refreshEvent:string;
    public default:string;
    public displayWidth:string;
    public formattedFlag:boolean=false;
    
    //@ngInject
    constructor(
        public $filter,
        public utilityService,
        public $injector,
        public observerService){
        
	}
	
	public $onInit = () =>{ 
	   
	    this.value = this.object[this.property];
	    
	    // First, check if it was passed in via the object instead of the attribute.
	    if (this.object && this.object.currencyCode && !this.currencyCode) {
	        this.currencyCode = this.object.currencyCode;
	    }
	    
	    //sets a default if there is no value and we have one...
	    if (!this.value && this.default){
	        this.value = this.default;
	    }
	    
	    //sets a default width for the value 
	    if (!this.displayWidth){
	        this.displayWidth="110";
	    }
	    //attach the refresh listener.
        if (this.refreshEvent){
	        this.observerService.attach(this.refresh, this.refreshEvent);
        }
        
	}
	
	public refresh = (payload) => {
	   
	    this.object = payload;
	    this.value = this.object[this.property];
	    this.formattedFlag = true; //this tells the view to not apply the currency filter because its already applied...

	}

}

class SWSimplePropertyDisplay implements ng.IDirective{

    public static $inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
    public templateUrl:string;
    public restrict = 'AE';
    public scope = {};

    public bindToController = {

        edit: "@?",
        property:"@?",
        title:"@?",
        object:"<?",
        displayType:"@?",
        currencyFlag:"@?",
        refreshEvent: "@?",
        displayWidth: "@?",
        currencyCode: "@?",
        default: "@?"
        
    };
    
    public controller=SWSimplePropertyDisplayController;
    public controllerAs="swSimplePropertyDisplay";

    public templateUrlPath = "simplepropertydisplay.html";

	//@ngInject
    constructor(
        public $compile,
		public scopeService,
        public coreFormPartialsPath,
        public hibachiPathBuilder,
        public swpropertyPartialPath

    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + swpropertyPartialPath;
    }

    public static Factory(swpropertyClass,swpropertyPartialPath?:string){

        var directive = (
            $compile,
            scopeService,
            coreFormPartialsPath,
            hibachiPathBuilder
        )=>new swpropertyClass(
            $compile,
			scopeService,
			coreFormPartialsPath,
            hibachiPathBuilder,
            //not an inejctable don't add to $inject. This is in the form.module Factory implementation
            swpropertyPartialPath
        );
        directive.$inject = ['$compile','scopeService','coreFormPartialsPath','hibachiPathBuilder'];

        return directive;
    }


    public link:ng.IDirectiveLinkFn = ($scope:any) =>{};
}
export{
    SWSimplePropertyDisplay,
    SWSimplePropertyDisplayController
}