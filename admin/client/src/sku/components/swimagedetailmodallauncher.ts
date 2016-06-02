/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWImageDetailModalLauncherController{
    
    public skuId:string; 
    public sku:any;
    public name:string; 
    public baseName:string = "j-image-detail"; 
    public imageFileName:string; 
    public imagePath:string; 
    public customImageNameFlag:boolean;
    public collectionConfig; 
    
    //@ngInject
    constructor(
        private collectionConfigService,
        private formService,
        private utilityService,
        private $hibachi,
        private $http
    ){
        this.name = this.baseName + this.utilityService.createID(18);
        this.collectionConfig = this.collectionConfigService.newCollectionConfig("Sku"); 
        this.collectionConfig.addFilter("skuID",this.skuId,"="); 
        this.collectionConfig.addDisplayProperty("skuID,skuCode,skuDefinition,imageFileName,imageFile,imagePath,product.productID");
        this.collectionConfig.setAllRecords(true); 
        this.collectionConfig.getEntity().then(
            (response)=>{
                if(angular.isDefined(response.records) && angular.isDefined(response.records[0])){
                    this.imageFileName = response.records[0].imageFileName; 
                    this.imagePath = response.records[0].imagePath; 
                    this.sku = this.$hibachi.populateEntity("Sku",response.records[0]); 
                }
            },
            (reason)=>{
                //something went wrong   
            }
       );
    }    
    
    public saveAction = () => {
        var data = {
            slatAction:"admin:entity.processProduct",
            processContext:"uploadDefaultImage", 
            productID:this.sku.data.product_productID, 
            preprocessDisplayedFlag:1,
            sRedirectAction:"admin:entity.detailproduct",
            imageFile:this.sku.imagePath
        };
        var savePromise = this.$http.post(
                "/?s=1",
                data,
                {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
        return savePromise;
    }
}

class SWImageDetailModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@"
    };
    public controller = SWImageDetailModalLauncherController;
    public controllerAs="swImageDetailModalLauncher";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWImageDetailModalLauncher(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"imagedetailmodallauncher.html";
    }
}
export{
    SWImageDetailModalLauncher,
    SWImageDetailModalLauncherController
}
