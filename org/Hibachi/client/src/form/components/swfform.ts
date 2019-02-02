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
    public sAction;
    public fAction;
    public successfulActions:any;
    public failureActions:any;
    public loading:boolean;
    public errors:any;
    public fileFlag:boolean = false;
    public errorToDisplay:string; //very first error returned from call
    public uploadProgressPercentage:any = 0;
    
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
        for(var key in this.form){
            if(key.indexOf('$')==-1){
                formData[key]=this.form[key].$modelValue||this.form[key].$viewValue;
            }
        }
        return formData;
    }
    
    private calculateFileUploadProgress = (xhr)=>{
        xhr.upload.addEventListener("progress",(event)=>{
            if (event.lengthComputable) {
                this.$timeout(()=>{
                    var uploadProgressPercentage = event.loaded / event.total;
                    this.uploadProgressPercentage = Math.floor(uploadProgressPercentage * 100);
                });
            }
       }, false);
    }
    
    public getFileFromFormData = (formData)=>{
        //currently supports just one file input
        let file;
        for(let key in formData){
            if(formData[key]["size"]){ //the size attribute indicates it's a file, this can be improved
                file = {
                    "fileName":formData[key].name,
                    [key]:formData[key], //the key needs to be the name of the property that we are updating
                    "propertyName":key
                };  
            }
        }
        return file;
    }
    
    public submitForm = ()=>{
        if(this.form.$valid){
            this.loading = true;
            let formData = this.getFormData();
            if(this.fileFlag){
                let file = this.getFileFromFormData(formData);
                return this.uploadFile(this.method,file).then(result=>{
                    return this.processResult(result);
                });
            }
            return this.$rootScope.slatwall.doAction(this.method,formData).then( (result) =>{
                return this.processResult(result);
            });
            
        }else{
            this.form.$setSubmitted(true);
            return new Promise((resolve,reject)=>[]);
        }
    }
    
   public uploadFile = (action, data) =>{ //promisified version of public service's uploadFile
    return new Promise((resolve, reject)=>{
            let url = this.$rootScope.slatwall.appConfig.baseURL;
            //check if the caller is defining a path to hit, otherwise use the public scope.
            if (action.indexOf(":") !== -1){
                url = url + action; //any path
            }else{
                url = this.$rootScope.slatwall.baseActionPath + action;//public path
            }
            let formData = new FormData();
    
            formData.append("fileName", data.fileName);
            formData.append(data.propertyName, data[data.propertyName]);
            formData.append("returnJsonObjects","cart,account");
            var xhr = new XMLHttpRequest();
            xhr.open('POST', url, true);
            
            this.calculateFileUploadProgress(xhr);
        
            xhr.onload = (result)=>{
                var response = JSON.parse(xhr.response);
                if (xhr.status === 200) {
                   this.$rootScope.slatwall.processAction(response, null);
                   this.successfulActions = response.successfulActions;
                   this.failureActions = response.failureActions;
                   resolve(response);
                } else {
                    reject(response);
                }
            };
            xhr.send(formData);
        });
    }
    
    public processResult = (result)=>{
        if(!result) return result;
        this.$timeout(()=>{
        this.loading = false;
        this.successfulActions = result.successfulActions;
        this.failureActions = result.failureActions;
        this.errors = result.errors;
        if(result.errors && Object.keys(result.errors).length){
            this.errorToDisplay = result.errors[Object.keys(result.errors)[0]][0]; //getting first key in object and first error in array
        }
        if(result.successfulActions.length)
        {
            //if we have an array of actions and they're all complete, or if we have just one successful action
            if(this.sRedirectUrl){
                this.$rootScope.slatwall.redirectExact(this.sRedirectUrl);
            }
            if(this.sAction){
                this.sAction();
            }
            this.form.$setSubmitted(false);
            this.form.$setPristine(true);
        }
        if (result.errors) {
            if(this.fRedirectUrl){
                this.$rootScope.slatwall.redirectExact(this.fRedirectUrl);
            }
            if(this.fAction){
                this.fAction();
            }
        }
        });
        return result;
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
        sAction:"=?",
        fAction:"=?",
        fileFlag:"@?"
    };
    public controller       = SWFFormController;
    public controllerAs     = "swfForm";
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
        var directive = () => new SWFForm();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    SWFForm,
    SWFFormController
}