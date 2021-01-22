/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSiteAndCurrencySelectController{
    
    public accountTypeaheadId;
    
    public site; 
    public currencyCode; 
    
    public siteAndCurrencyOptions; 
    public currencyCodeOptions = [];
    
    public disabled = false; 
    
    //@ngInject
    constructor(
        private $hibachi,
        private observerService
    ){
       this.site = this.siteAndCurrencyOptions[0];
    }    
    
    public $onInit = () =>{
        if(this.accountTypeaheadId != null){
            this.observerService.attach( this.updateSite, 'typeahead_add_item', this.accountTypeaheadId);
        }
    }
    
    public updateSite = (data?) =>{
        
        if(data != null && data.accountCreatedSite_siteID != null){
            for(var i=0; i<this.siteAndCurrencyOptions.length; i++){
                if(this.siteAndCurrencyOptions[i].value ===  data.accountCreatedSite_siteID){
                    this.site = this.siteAndCurrencyOptions[i];
                    this.disabled = true; 
                    break;
                }
            }
        }
        if(this.site != null){
            this.currencyCodeOptions = this.site.eligibleCurrencyCodes.split(',');
            if(this.currencyCodeOptions.length === 1){
                this.currencyCode = this.currencyCodeOptions[0];
            }
        }
    }
}

class SWSiteAndCurrencySelect implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        accountTypeaheadId:'@?',
        siteAndCurrencyOptions:'<?'
    };
    public controller = SWSiteAndCurrencySelectController;
    public controllerAs="swSiteAndCurrencySelect";
   
    public static Factory(){
        var directive = (
            sitePartialsPath,
			slatwallPathBuilder
        )=> new SWSiteAndCurrencySelect(
            sitePartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            'sitePartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
		skuPartialsPath,
	    slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"siteandcurrencyselect.html";
    }
    
     public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs) => {
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            }
        };
    }
}
export{
    SWSiteAndCurrencySelect,
}
