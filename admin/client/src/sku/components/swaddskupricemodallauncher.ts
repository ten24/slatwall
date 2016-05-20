/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddSkuPriceModalLauncherController{
    
    public pageRecord:any; 
    public skuId:string; 
    public skuPrice:any; 
    public baseName:string="j-add-sku-item-"; 
    public uniqueName:string; 
    
    //@ngInject
    constructor(
        private $hibachi,
        private utilityService
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16);
        this.skuPrice = this.$hibachi.newEntity('SkuPrice'); 
        
    }    
    
    public save = () => {
        this.skuPrice.$$save().then(
            ()=>{
                //sucess callback
            },
            ()=>{
                //error callback
            }
        );
    }
    
    public cancel = () => {
        //wipe the sku price entity
    }
}

class SWAddSkuPriceModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        pageRecord:"="
    };
    public controller = SWAddSkuPriceModalLauncherController;
    public controllerAs="swAddSkuPriceModalLauncher";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWAddSkuPriceModalLauncher(
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
		skuPartialsPath,
	    slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"addskupricemodallauncher.html";
    }
    
    public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                var currentScope = $scope; 
                while(angular.isDefined(currentScope.$parent)){
                    currentScope = currentScope.$parent; 
                    if(angular.isDefined(currentScope.pageRecord)){
                        break; 
                    }
                }
                if(angular.isDefined(currentScope.pageRecord)){ 
                    console.log("found page record", currentScope.pageRecord);
                    $scope.swAddSkuPriceModalLauncher.pageRecord = currentScope.pageRecord; 
                    if(angular.isDefined(currentScope.pageRecord.skuID)){ 
                        $scope.swAddSkuPriceModalLauncher.skuId = currentScope.pageRecord.skuID;           
                    }
                } else{ 
                    throw("swAddSkuPriceModalLauncher was unable to find the pageRecord that it needs!");
                } 
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {

            }
        };
    }
}
export{
    SWAddSkuPriceModalLauncher,
    SWAddSkuPriceModalLauncherController
}
