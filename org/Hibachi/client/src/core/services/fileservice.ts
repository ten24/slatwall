class FileService {
    //@ngInject
    constructor(private FileReader){
        
    }
    
    uploadFile = (file:any,property:string,object:any) => {
        this.FileReader.readAsDataUrl(file)
            .then((result)=>{
                //$scope.imageSrc = result;
                object.data[property] = result;
            });
    }
}
export {
    FileService
}