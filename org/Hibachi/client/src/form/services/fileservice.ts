class FileService {

    private fileStates={};
    private fileReader;
    
    //@ngInject
    constructor(public $q, public observerService){
      
    }

    public imageExists = (src) =>{

        var deferred = this.$q.defer();

        var image = new Image();
        image.onerror = function() {
            deferred.reject();
        };
        image.onload = function() {
            deferred.resolve();
        };
        image.src = src;

        return deferred.promise;
    }
    
    public uploadFile = (file:any,object:any,property:string) => {
        var deferred = this.$q.defer();
        var promise = deferred.promise; 
        var fileReader = new FileReader(); 
        fileReader.readAsDataURL(file);
        fileReader.onload = (result)=>{
            object.data[property] = fileReader.result;
            deferred.resolve(fileReader.result); 
        };
        fileReader.onerror = (result)=>{
            deferred.reject();    
            throw("fileservice couldn't read the file");
        }
        return promise; 
    }
}
export {
    FileService
}