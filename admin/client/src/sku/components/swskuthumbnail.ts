/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuThumbnailController{
   
    public skuData:any; 
    public image:any; 
    public imagePath:string;
    public imageOnly:boolean; 
   
    //@ngInject
    constructor(
        private fileService, 
        private $hibachi,
        private $http,
        private appConfig
    ){
        if(!angular.isDefined(this.skuData)){
            throw("You must provide a sku to the SWSkuThumbnailController");
        }

        fileService.imageExists(this.skuData.imagePath).then(
            ()=>{
                //Do nothing
            },
            ()=>{
                this.skuData.imagePath = this.appConfig.baseURL+'assets/images/image-placeholder.jpg';
            }
        ).finally(
            ()=>{
                if(angular.isDefined(this.skuData.imagePath)){
                    this.image = this.appConfig.baseURL+this.skuData.imagePath;
                }
            }
        )
    }   
}

class SWSkuThumbnail implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuData:"=",
        imageOnly:"=?",
        imagePath:"@?"
    };
    public controller = SWSkuThumbnailController;
    public controllerAs="swSkuThumbnail";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
            slatwallPathBuilder
        )=> new SWSkuThumbnail(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skuthumbnail.html";
    }
     
}
export{
    SWSkuThumbnail,
    SWSkuThumbnailController
}
