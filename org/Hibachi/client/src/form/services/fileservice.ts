class FileService {

    private fileStates={};
    private fileReader;
    
    //@ngInject
    constructor(private $q, private observerService){
      
    }
    
    public uploadFile = (file:any,object:any,property:string) => {
        var deferred = this.$q.defer();
        var promise = deferred.promise; 
        var fileReader = new FileReader(); 
        fileReader.readAsDataURL(file);
        fileReader.onload = (result)=>{
            //object.data[property] = fileReader.result;
            deferred.resolve(fileReader.result); 
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