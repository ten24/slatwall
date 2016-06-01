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
                this.imageFileName = response.records[0].imageFileName; 
                this.imagePath = response.records[0].imagePath; 
                this.sku = this.$hibachi.populateEntity("Sku",response.records[0]); 
                console.log("imagesku",this.sku);
            },
            (reason)=>{
                
            }
       );
    }    
    
    public saveAction = () => {
        var data = {
            slatAction:"admin:entity.processProduct",
            processContext:"uploadDefaultImage", 
            productID:this.sku.product_productID, 
            preprocessDisplayedFlag:1,
            sRedirectAction:"admin:entity.detailproduct",
        };
        console.log("form???",this.sku)
        var savePromise = this.$http.post("/?s=1",data);
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
