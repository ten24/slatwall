/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSiteAndCurrencySelectController{
    
    public site; 
    public currencyCode; 
    
    public siteAndCurrencyOptions; 
    public currencyCodeOptions = [];
    
    //@ngInject
    constructor(
        private $hibachi
    ){
       this.site = this.siteAndCurrencyOptions[0];
    }    
    
    public $ngOnInit = () =>{
        
    }
    
    public updateSite = () =>{
        console.log('getSiteCurrencyCodeOptions', this.site);
        this.currencyCodeOptions = this.site.eligibleCurrencyCodes.split(',');
        if(this.currencyCodeOptions.length === 1){
            this.currencyCode = this.currencyCodeOptions[0];
        }
    }
}

class SWSiteAndCurrencySelect implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
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
