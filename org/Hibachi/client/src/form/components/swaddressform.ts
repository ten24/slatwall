/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//Displays an address form. Pass in an address object to bind to.
declare var hibachiConfig:any;

class SWAddressFormController {
    public slatwallScope:any;
    public slatwall:any;
    public action:any;
    public customPartial:any;
    public fieldList:string;
    public showAddressBookSelect:boolean = false;
    public showCountrySelect:boolean = true;
    public showSubmitButton:boolean = true;
    public showCloseButton:boolean = true;
    public address:any;
    public addressName:string;
    public param:string = "?slataction=";
    public showAlerts:string = "true";
    public eventListeners:any;
    public submitOnEnter:boolean;
    public stateOptions:any;

    //@ngInject
    constructor(
        private $scope,
        private $log,
        private observerService,
        private $rootScope) {
        //if exists, just name it slatwall.
        if (angular.isDefined(this.slatwallScope)){
            this.slatwall = this.slatwallScope;
        }
        if (this.fieldList == undefined) {
            this.fieldList = "countryCode,name,company,streetAddress,street2Address,locality,city,stateCode,postalCode";
        }
        if (this.showAddressBookSelect == undefined) {
            this.showAddressBookSelect = false;
        }
        if (this.showCountrySelect == undefined) {
            this.showCountrySelect = true;
        }
        if (this.action == undefined) {
            this.showSubmitButton = false;
        }
        if($rootScope.slatwall && !$scope.slatwall){
            $scope.slatwall = $rootScope.slatwall;
        }
        let addressName = this.addressName;
        if(this.address){
            this.address.getData = () => {
                let formData = this.address || {};
                let form = this.address.forms[addressName];
                for(let key in form){
                    let val = form[key];
                    if(typeof val === 'object' && val.hasOwnProperty('$modelValue')){
                        if(val.$modelValue){
                            val = val.$modelValue;
                        }else if(val.$viewValue){
                            val = val.$viewValue;
                        }else{
                            val="";
                        }

                        if(angular.isString(val)){
                            formData[key] = val;
                        }
                        if(val.$modelValue){
                            formData[key] = val.$modelValue;
                        }else if(val.$viewValue){
                            formData[key] = val.$viewValue;
                        }
                    }
                }

                return formData || "";
            }
        }
        if(!this.eventListeners){
            this.eventListeners = {};
        }
        if(this.submitOnEnter){
            this.eventListeners.keyup = this.submitKeyCheck;
        }

       if(this.eventListeners){
            for(var key in this.eventListeners){
                observerService.attach(this.eventListeners[key], key)
            }
        }
    }

    public getAction = () => {
        if (!angular.isDefined(this.action)){
            this.action="addAddress";
        }

        if (this.action.indexOf(":") != -1 && this.action.indexOf(this.param) == -1){
            this.action = this.param + this.action;

        }
        return this.action;
    }

    public hasField = (field) => {
        if (this.fieldList.indexOf(field) != -1) {
            return true;
        }
        return false;
    }

    public submitKeyCheck = (event) => {
        if(event.form.$name == this.addressName &&
            event.event.keyCode == 13){
            event.swForm.submit(event.swForm.action);
        }
    }

} 

class SWAddressForm implements ng.IComponentOptions {

    public bindings:any;
    public transclude = true;
    public controller:any=SWAddressFormController;
    public controllerAs:string='SwAddressForm';
    public template:string;
    public bindToController = {
        action: '@',
        actionText: '@',
        context:'@',
        customPartial:'@',
        slatwallScope: '=',
        address: "=",
        id: "@?",
        fieldNamePrefix: "@",
        fieldList: "@",
        fieldClass: "@",
        fulfillmentIndex:"@",
        tabIndex: "@",
        addressName: "@",
        showAddressBookSelect: "@",
        showCountrySelect: "@",
        showSubmitButton: "@",
        showCloseButton: "@",
        showAlerts: "@",
        eventListeners:"=?",
        submitOnEnter:"@",
        stateOptions:"=?"
    };
    public scope={};
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var directive = (
            coreFormPartialsPath,
            hibachiPathBuilder
        ) => new SWAddressForm(
            coreFormPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = ['coreFormPartialsPath','hibachiPathBuilder'];
        return directive;
    }

    public templateUrl = (elem,attrs) =>{
        if(attrs.customPartial){
            if(attrs.customPartial === "true"){
                return hibachiConfig.customPartialsPath + "addressform.html";
            }else{
                return hibachiConfig.customPartialsPath + attrs.customPartial;
            }
        }
        else{
            return this.hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "addressform.html";
        }
    }

    // @ngInject
    constructor( public coreFormPartialsPath, public hibachiPathBuilder) {

    }

}
export {SWAddressFormController, SWAddressForm};