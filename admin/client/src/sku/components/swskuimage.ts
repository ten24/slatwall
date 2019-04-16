/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuImageController{
   
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
    console.log('conf img',this.appConfig)
        fileService.imageExists(this.imagePath).then(
            ()=>{
                //Do nothing
            },
            ()=>{
                this.imagePath = this.appConfig.baseURL+'assets/images/image-placeholder.jpg';
            }
        ).finally(
            ()=>{
                if(angular.isDefined(this.imagePath)){
                    this.image = this.appConfig.baseURL+this.imagePath;
                }
            }
        )
    }   
}

class SWSkuImage implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        imagePath:"@?"
    };
    public controller = SWSkuImageController;
    public controllerAs="swSkuImage";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
            slatwallPathBuilder
        )=> new SWSkuImage(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skuimage.html";
    }
     
}
export{
    SWSkuImage,
    SWSkuImageController
}
