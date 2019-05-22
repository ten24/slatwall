/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
declare var hibachiConfig:any;

class SWVerifyAddressDialogController{
    
    public suggestedAddress:any; //addresses returned by integration that user can choose from
    public copy:string;
    public accountAddressID:string;

    //@ngInject
    constructor(public $timeout,
                public $rootScope,
                public $http,
                public $hibachi,
                public collectionConfigService,
                public observerService){
                    
        this.observerService.attach(this.init,"shippingAddressSelected");
        this.copy = "We Could Not Verify This Address. Please Select:";
    }
    
    //init 
    private init = (data) =>{
        this.accountAddressID = data['accountAddressID'] || data['accountAddress.accountAddressID'];
        if(!this.accountAddressID){
            return;
        }
        this.verifyAddress({accountAddressID:this.accountAddressID}).then((response:any)=>{
            
            if(response.verifyAddress.suggestedAddress){
                this.suggestedAddress = response.verifyAddress.suggestedAddress;
            } else {
                this.suggestedAddress = null;
            }
            
            if(!response.verifyAddress.success){
                this.showModal();
            }
            
        });
    }
    
    private showModal = ()=>{
        $('#VerifyAddressDialog').modal('show');
    }
    
    private selectSuggestedAddress = ()=>{
        return this.$rootScope.slatwall.doAction('addEditAccountAddress',this.suggestedAddress);
    }
    
    //mocking call to integration. Important to inject the data's account address iD into the response object for tracking
    private verifyAddress = (data)=>{
        return this.$rootScope.slatwall.doAction("verifyAddress",{accountAddressID:data.accountAddressID}).then(response=>{
            if(response.verifyAddress.suggestedAddress){
                response.verifyAddress.suggestedAddress['accountAddressID'] = data.accountAddressID;
            }
            return response;
        });
    }
    
    private cancel = ()=>{
        this.$rootScope.slatwall.deleteAccountAddress(this.accountAddressID);
        this.suggestedAddress = null;
        this.accountAddressID= null;
    }
}

class SWVerifyAddressDialog implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude = false;
    public bindToController={
    };
    public controller=SWVerifyAddressDialogController
    public controllerAs="SWVerifyAddressDialog";
    public templatePath: string = "";
    public templateUrl: string = "";
    public $compile;
    public path: string;

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,hibachiPathBuilder
        ) => new SWVerifyAddressDialog(corePartialsPath,hibachiPathBuilder);
        directive.$inject = ['$compile','hibachiPathBuilder'];
        return directive;

    }

    //@ngInject
    constructor($compile,hibachiPathBuilder){
        if(!hibachiConfig){
            hibachiConfig = {};    
        }
        
        if (!hibachiConfig.customPartialsPath) {
            hibachiConfig.customPartialsPath = '/Slatwall/custom/client/src/form/';
        }

        this.templatePath = hibachiConfig.customPartialsPath;
        this.templateUrl = hibachiConfig.customPartialsPath + 'swverifyaddressdialog.html';
        this.$compile = $compile;
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWVerifyAddressDialog
}