/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWImageDetailModalLauncherController{
    
    public skuId:string; 
    public skuCode:string; 
    public sku:any;
    public name:string; 
    public baseName:string = "j-image-detail"; 
    public imageFileName:string; 
    public imagePath:string; 
    public imageFile:string; 
    public productProductId:string; 
    public customImageNameFlag:boolean;
    public imageFileUpdateEvent:string; 
    public collectionConfig; 
    
    //@ngInject
    constructor(
        private observerService, 
        private formService,
        private collectionConfigService,
        private utilityService,
        private $hibachi,
        private $http
    ){
        this.name = this.baseName + this.utilityService.createID(18);
        var skuData = { 
            skuID:this.skuId,
            skuCode:this.skuCode, 
            imageFileName:this.imageFileName,
            imagePath:this.imagePath, 
            imageFile:this.imageFile
        }
        this.sku = this.$hibachi.populateEntity("Sku",skuData); 
        this.imageFileUpdateEvent = "file:"+this.imagePath;
        this.observerService.attach(this.updateImage, this.imageFileUpdateEvent, this.skuId);
    }    

    public updateImage = (rawImage) => {
        if(angular.isDefined(rawImage)){
            this.sku.data.imagePath = rawImage;
        }   
    }
    
    public saveAction = () => {

        var data = new FormData(); 
        data.append('slatAction', "admin:entity.processProduct");
        data.append('processContext',"uploadDefaultImage");
        data.append('sRedirectAction',"admin:entity.detailProduct");
        data.append('preprocessDisplayedFlag',1); 
        data.append('ajaxRequest', 1); 
        
        data.append('productID', this.sku.data.product_productID);
        
        if(this.customImageNameFlag){
            data.append('imageFile', this.imageFileName);
        } else {
            data.append('imageFile', this.sku.data.imageFile);
        }
        data.append('uploadFile', this.sku.data.uploadFile);
        
        var savePromise = this.$http.post(
                "/?s=1",
                data,
                {
                    transformRequest: angular.identity,
                    headers: {'Content-Type': undefined}
                });
    
        return savePromise;
    }

    public cancelAction = () =>{
        this.observerService.notify(this.imageFileUpdateEvent, this.imagePath);
    }
}

class SWImageDetailModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        skuCode:"@",
        imagePath:"@", 
        imageFile:"@", 
        imageFileName:"@"
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
