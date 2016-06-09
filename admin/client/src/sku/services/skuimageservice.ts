class SkuImageService {

    private observerKeys = {}; 

    constructor(public observerService){

    }

     public attachEvent = (imageFile,callback) =>{
        if(angular.isUndefined(this.observerKeys[imageFile])){
            this.observerKeys[imageFile] = {attached:true, eventName:'changeImage:' + imageFile, update:callback}; 
            this.observerService.attach(this.updateImage, this.observerKeys[imageFile].eventName);
        }//otherwise the event has been attached
    }

    public updateImage = (response) =>{
        console.log("nicerespit", response)
    }
    
    public notify = (imageFile) =>{
        this.observerService.notify(this.observerKeys[imageFile].eventName);
    }
}
export {
    SkuImageService
}