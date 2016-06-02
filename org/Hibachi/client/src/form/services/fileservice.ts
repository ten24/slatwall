class FileService {
    private fileReader;
    //@ngInject
    constructor(){
      
    }
    
    uploadFile = (file:any,object:any,property:string) => {
        var fileReader = new FileReader(); 
        fileReader.readAsDataURL(file);
        fileReader.onload = (result)=>{
            object.data[property] = fileReader.result;
        };
    }
}
export {
    FileService
}