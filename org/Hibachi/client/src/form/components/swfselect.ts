/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

/**
* Form Controller handles the logic for this directive.
*/

class Option {
    public value:string;
    public name:string;
    
    constructor(value:string,name?:string){
        this.value = value;
        this.name = value; // we default name to be the same as value.
        if(name){ // if name was passed in, let's use that instead.
            this.name = name;
        }
    }
}

class SWFSelectController {
    // @ngInject
    constructor(
        public $rootScope,
        public $scope,
        public optionsMethod:string,
        public selectMethod:string,
        public selectParameterName:string,
        public loading:boolean,
        public successfulActions:any,
        public failureActions:any,
        public errors:any,
        public options:Option[],
    ){
        debugger;
    }
    
    public getOptions = ()=>{
        this.$rootScope.hibachiScope.doAction(this.optionsMethod).then(result=>{
            let options = [];
            for(const option of result){
                if(option.value && option.name){ // if we have a struct with value and name, use that
                    options.push(new Option(option.value,option.name));
                    continue;
                }
                // otherwise, it's a simple string, so let's use that
                options.push(new Option(option));
            }
        });
    }
    
    public select = (option)=>{
        
        this.loading = true;
        
        const params = {};
        params[this.selectParameterName] = option.value;
        
        this.$rootScope.hibachiScope.doAction(this.selectMethod,params).then(result=>{
            this.loading = false;
            this.successfulActions = result.successfulActions;
            this.failureActions = result.failureActions;
            this.errors = result.errors;
        });
    }
    
}

class SWFSelect  {
    
    
    public require          = {
        ngModel:'?^ngModel'    
    };
    public priority=1000;
    public restrict         = "A";
    public scope            = true;
   /**
    * Binds all of our variables to the controller so we can access using this
    */
    public bindToController = {
        optionsMethod:"@",
        selectMethod:"@",
        selectParameterName:"@",
    };
    public controller       = SWFSelectController;
    public controllerAs     = "swfSelect";
    // @ngInject
    constructor() {
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
        var directive = () => new SWFSelect();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    SWFSelect,
    SWFSelectController
}