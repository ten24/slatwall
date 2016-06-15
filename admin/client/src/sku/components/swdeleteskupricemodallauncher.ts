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
    }    
    
    public delete = () => {
        var deletePromise = this.skuPrice.$$delete();
        deletePromise.then(
            (response)=>{

            },
            (reason)=>{
                //error callback
            }
        );
        return deletePromise; 
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
    public controllerAs="swDeleteSkuPriceModalLauncher";
   
   
    public static Factory(){
        var directive = (
            $hibachi,
            scopeService, 
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWDeleteSkuPriceModalLauncher(
            $hibachi, 
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'scopeService',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        private $hibachi, 
        private scopeService,
		private skuPartialsPath,
	    private slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"deleteskupricemodallauncher.html";
    }
    
    public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                //have to do our setup here because there is no direct way to pass the pageRecord into this transcluded directive
                var currentScope = this.scopeService.locateParentScope($scope, "pageRecord");
                if(angular.isDefined(currentScope.pageRecord)){ 
                    $scope.swDeleteSkuPriceModalLauncher.pageRecord = currentScope.pageRecord; 
                    if(angular.isDefined(currentScope.pageRecord.skuPriceID) && currentScope.pageRecord.skuPriceID.length){    
                        var skuPriceData = {
                            skuPriceID:currentScope.pageRecord.skuPriceID,
                        }
                        $scope.swDeleteSkuPriceModalLauncher.skuPrice = this.$hibachi.populateEntity('SkuPrice',skuPriceData);
                    }
                } else{ 
                    throw("swDeleteSkuPriceModalLauncher was unable to find the pageRecord that it needs!");
                } 
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
