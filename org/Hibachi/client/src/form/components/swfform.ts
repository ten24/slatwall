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
    public fRedirectUrl:string;
    public successfulActions:any;
    public failureActions:any;
    public loading:boolean;
    public errors:any;
    
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
    
    public getFormData = ()=>{
        var formData = {};
        console.log(this.form);
        for(var key in this.form){
            if(key.indexOf('$')==-1){
                formData[key]=this.form[key].$modelValue||this.form[key].$viewValue;
            }
        }
        console.log('test',formData,this.ngModel);
        return formData;
    }
    
    
    public submitForm = ()=>{
        //example of entityName Account_Login
        if(this.form.$valid){
            this.loading = true
            return this.$rootScope.slatwall.doAction(this.method,this.getFormData()).then( (result) =>{
                if(!result) return result;
                this.loading = false;
                this.successfulActions = result.successfulActions;
                this.failureActions = result.failureActions;
                this.errors = result.errors;
                if(result.successfulActions.length)
                {
                    //if we have an array of actions and they're all complete, or if we have just one successful action
                    if(this.sRedirectUrl){
                        this.$rootScope.slatwall.redirectExact(this.sRedirectUrl);
                    }
                    this.form.$setSubmitted(false);
                    this.form.$setPristine(true);
                }
                if (result.errors) {
                    if(this.fRedirectUrl){
                        this.$rootScope.slatwall.redirectExact(this.fRedirectUrl);
                    }
                }
                return result;
            });
        }else{
            this.form.$setSubmitted(true);
            return new Promise((resolve,reject)=>[]);
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