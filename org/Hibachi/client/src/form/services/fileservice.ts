class FileService {

    private fileStates={};
    private fileReader;
    
    //@ngInject
    constructor(public $q, public $http, public observerService){
      
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
    
    uploadFileWithRoute = (file, routeURI) =>{
        var formData = new FormData();
        formData.append('fileUpload', file);
        return this.$http.post(routeURI, formData, {
            transformRequest: angular.identity,
            headers: {'Content-Type': undefined}
        });
    };

    removeFileWithRoute = (fileName, routeURI) =>{
        var formData = "fileName="+fileName;
        return this.$http.post(routeURI, formData,{
            headers : {
                'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8;'
            }
        });
    };

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