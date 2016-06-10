/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDeleteSkuPriceModalLauncherController{
    
    public pageRecord:any; 
    public sku:any;
    public skuId:string; 
    public skuPrice:any; 
    public baseName:string="j-delete-sku-item-"; 
    public uniqueName:string; 
    
    //@ngInject
    constructor(
        private $hibachi,
        private utilityService
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
        this.initData(); 
    }    
    
    public initData = () =>{
        //these are populated in the link function initially
        this.skuPrice = this.$hibachi.newEntity('SkuPrice'); 
        this.skuPrice.$$setSku(this.sku);
    }
    
    public save = () => {
        var savePromise = this.skuPrice.$$save();
        savePromise.then(
            (response)=>{
               this.initData(); 
            },
            (reason)=>{
                //error callback
            }
        );
        return savePromise; 
    }
}

class SWDeleteSkuPriceModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        pageRecord:"=?"
    };
    public controller = SWDeleteSkuPriceModalLauncherController;
    public controllerAs="swAddSkuPriceModalLauncher";
   
   
    public static Factory(){
        var directive = (
            $hibachi,
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWDeleteSkuPriceModalLauncher(
            $hibachi, 
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        private $hibachi, 
		private skuPartialsPath,
	    private slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"deleteskupricemodal.html";
    }
    
    public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {

            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {

            }
        };
    }
}
export{
    SWDeleteSkuPriceModalLauncher,
    SWDeleteSkuPriceModalLauncherController
}
