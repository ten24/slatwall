class FileService {
    //@ngInject
    constructor(FileReader){
        
    }
    
    uploadFile = (property:string,object:any) => {
        this.fileReader.readAsDataUrl($scope.file, $scope)
            .then((result)=>{
                //$scope.imageSrc = result;
                object.data[property] = result;
            });
    }
}
export {
    FileService
}