/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

/**
* Form Controller handles the logic for this directive.
*/
class SWFFormController {
    public form:any;
    public ngModel:any;
    public method:string;
    public sRedirectUrl:string;
    public fRedirectUrl:string
    
    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
        public $timeout,
        public $hibachi,
        public $element,
        public validationService,
        public hibachiValidationService
    ){

    }

    public $onInit=()=>{
    }
    
    
    public submitForm = ()=>{
        //example of entityName Account_Login
        if(this.form.$valid){
            this.$rootScope.slatwall.doAction(this.method,this.ngModel.$modelValue).then( (result) =>{
                if(!result) return;
                if(result.successfulActions.length)
                {
                    //if we have an array of actions and they're all complete, or if we have just one successful action
                    if(this.sRedirectUrl){
                        this.$rootScope.slatwall.redirectExact(this.sRedirectUrl);
                    }
                }
                if (result.errors) {
                    if(this.fRedirectUrl){
                        this.$rootScope.slatwall.redirectExact(this.fRedirectUrl);
                    }
                }
            });
        }else{
            this.form.$setSubmitted(true);
        }
        
    }

   
}

class SWFForm  {
    
    
    public require          = {
        form:'?^form',
        ngModel:'?^ngModel'    
    };
    public priority=1000;
    public restrict         = "A";
    //needs to have false scope to not interfere with form controller
    public scope            = true;
   /**
    * Binds all of our variables to the controller so we can access using this
    */
    public bindToController = {
        method:"@?",
        sRedirectUrl:"@?",
        fRedirectUrl:"@?",
    };
    public controller       = SWFFormController;
    public controllerAs     = "swfForm";
    // @ngInject
    constructor( ) {
    }
    /**
        * Sets the context of this form
        */
    public link:ng.IDirectiveLinkFn = (scope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController) =>
    {
    }

    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var directive = (
        ) => new SWFForm(
        );
        directive.$inject = [];
        return directive;
    }
    
}
export{
    SWFForm,
    SWFFormController
}