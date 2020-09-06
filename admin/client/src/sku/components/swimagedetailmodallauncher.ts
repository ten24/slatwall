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
    public imagePathToUse:string; 
    public imageFile:string;
    public productProductId:string;
    public customImageNameFlag:boolean;
    public imageFileUpdateEvent:string;
    public otherSkusWithSameImageOptions:any;
    public otherSkusWithSameImageCollectionConfig:any;
    public imageOptionsAttachedToSku:any;
    public imageOptions=[];
    public skusAffectedCount:number;
    public numberOfSkusWithImageFile:number=0;
    
    public swPricingManager;
    public swListingDisplay;

    //@ngInject
    constructor(
        private observerService,
        private formService,
        private fileService, 
        private collectionConfigService,
        private utilityService,
        private $hibachi,
        private $http,
        private $element
    ){
        this.$element = $element;
        this.name = this.baseName + this.utilityService.createID(18);
        this.imagePath;
        fileService.imageExists(this.imagePath).then(
            ()=>{
                this.imagePathToUse = this.imagePath + "?version="+Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5); 
            },
            ()=>{
                this.imagePathToUse = 'assets/images/image-placeholder.jpg';
            }
        ).finally(
            ()=>{

                var skuData = {
                    skuID:this.skuId,
                    skuCode:this.skuCode,
                    imageFileName:this.imageFileName,
                    imagePath:this.imagePathToUse,
                    imageFile:this.imageFile
                }
                this.sku = this.$hibachi.populateEntity("Sku",skuData);
                this.imageFileUpdateEvent = "file:"+this.imagePath;
                this.observerService.attach(this.updateImage, this.imageFileUpdateEvent, this.skuId);
                this.fetchImageOptionData();
            }
        )

        
    }

    private fetchImageOptionData = () =>{
        this.imageOptionsAttachedToSku = this.collectionConfigService.newCollectionConfig("Option");
        this.imageOptionsAttachedToSku.addDisplayProperty('optionGroup.optionGroupName,optionName,optionCode,optionID');
        this.imageOptionsAttachedToSku.addFilter('skus.skuID', this.skuId, "=");
        this.imageOptionsAttachedToSku.addFilter('optionGroup.imageGroupFlag', true, "=");
        this.imageOptionsAttachedToSku.setAllRecords(true);
        this.imageOptionsAttachedToSku.getEntity().then(
            (data)=>{
                angular.forEach(data.records,(value,key)=>{
                    this.imageOptions.push(this.$hibachi.populateEntity("Option", value));
                });
            },
            (reason)=>{
                throw("Could not calculate affected skus in SWImageDetailModalLauncher because of: " + reason);
            }
        );
        this.otherSkusWithSameImageCollectionConfig = this.collectionConfigService.newCollectionConfig("Sku");
        this.otherSkusWithSameImageCollectionConfig.addFilter("imageFile",this.imageFile,"=");
        this.otherSkusWithSameImageCollectionConfig.setAllRecords(true);
        this.otherSkusWithSameImageCollectionConfig.getEntity().then(
            (data)=>{
                this.skusAffectedCount = data.records.length;
            },
            (reason)=>{
                throw("Could not calculate affected skus in SWImageDetailModalLauncher because of: "+ reason);
            }
        );
    }

    public updateImage = (rawImage) => {
        console.log('update');
    }

    public saveAction = () => {

        var data = new FormData();
        data.append('slatAction', "admin:entity.processProduct");
        data.append('processContext',"uploadDefaultImage");
        data.append('sRedirectAction',"admin:entity.detailProduct");
        data.append('preprocessDisplayedFlag',"1");
        data.append('ajaxRequest', "1");

        data.append('productID', this.swPricingManager.productId);
        
        if(this.sku.data.imageFile){
            data.append('imageFile', this.sku.data.imageFile);
        } else if(this.imageFileName){
            data.append('imageFile', this.imageFileName);
        } 
       
        const inputs = $('input[type=file]');
        for(var input of <any>inputs){
            var classes = $(input).attr('class').split(' ');
            if(input.files[0] && classes.indexOf(this.skuCode) > -1){
                data.append('uploadFile', input.files[0]);
                break;
            }
        }
        
        var savePromise = this.$http.post(
            "/?s=1",
            data,
            {
                transformRequest: angular.identity,
                headers: {'Content-Type': undefined}
            }
        ).then(()=>{
            this.sku.data.imagePath = this.imageFileName.split('?')[0] + "?version="+Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5);
            this.observerService.notifyById('swPaginationAction',this.swListingDisplay.tableID,{type:'setCurrentPage',payload:this.swListingDisplay.collectionConfig.currentPage});

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
    public require = {swPricingManager:'?^swPricingManager',swListingDisplay:"?^swListingDisplay"};
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