class FileService {
    private fileReader;
    //@ngInject
    constructor(private $q){
      
    }
    
    uploadFile = (file:any,object:any,property:string) => {
        var deferred = this.$q.defer();
        var promise = deferred.promise; 
        var fileReader = new FileReader(); 
        fileReader.readAsDataURL(file);
        fileReader.onload = (result)=>{
            object.data[property] = fileReader.result;
            deferred.resolve(); 
        };
        fileReader.onerror = (result)=>{
            deferred.reject();    
        }
        return promise; 
    }
}
export {
    FileService
}