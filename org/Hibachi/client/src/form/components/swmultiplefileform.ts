/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWMultipleFileFormController {

    public routeToUploadFile:string; 
    public routeToRemoveFile:string; 
    public files=[]; 
    public fileToUpload:any; 
    public uploading:boolean=false; 
    public removing:boolean=false;
    public uploadError:boolean=false; 
    public uploadSuccess:boolean=false; 
    public ajaxFileUpload:boolean;
    public showUploadedFiles:boolean;

	//@ngInject
	constructor (public fileService, public utilityService) {
        if(angular.isUndefined(this.ajaxFileUpload)){
            this.ajaxFileUpload=false; 
        }
         if(angular.isUndefined(this.showUploadedFiles)){
            this.showUploadedFiles=false; 
        }
        this.addFile();
	}

    public addFile = (fileName=this.utilityService.createID(32)) =>{
        var file = {fileName:fileName};
        this.files.push(file); 
    }

    public uploadFile = () =>{
        if(!this.fileToUpload || this.uploading || !this.ajaxFileUpload) return;
        
        this.uploading = true; 

    
        this.fileService.uploadFileWithRoute(this.fileToUpload, this.routeToUploadFile).then(
            (response)=>{
                this.addFile(response.fileName);
            },
            (reason)=>{
                throw("swmultiplefileform could not upload file because " + reason);
            }
        ).finally(()=>{
            this.uploading = false; 
        });
    }

    public removeFile = (index?,fileName?) =>{

        this.removing = true; 

        if(angular.isDefined(index) && this.files.length > 1){
            this.files.splice(index,1);
        }

        if(!this.ajaxFileUpload) return;

        this.fileService.removeFileWithRoute(fileName, this.routeToRemoveFile).then(
            (response)=>{
                for(var i=0; i<this.files.length; i++){
                    if(this.files[i].fileName == fileName){
                        this.files.splice(i, 1);
                    }
                }
            }, 
            (reason)=>{
                throw("swmultiplefileform could not remove file because " + reason);
            }
        ).finally(()=>{
            this.removing = false; 
        });
    }

}

class SWMultipleFileForm implements ng.IDirective {
	public restrict = 'E';
	public controller = SWMultipleFileFormController;
	public controllerAs = "swMultipleFileForm";
	public scope = true;
	public bindToController = {
        ajaxFileUpload: "=?",
        showUploadedFiles: "=?",
		routeToUploadFile: "@?",
        routeToRemoveFile: "@?"
	};

	//@ngInject
	public link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attr:ng.IAttributes, formController: ng.IFormController) => {

	}

	public templateUrl;
	public static Factory(){
		var directive = (
			coreFormPartialsPath,
			hibachiPathBuilder
		)=> new SWMultipleFileForm(
			coreFormPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'coreFormPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		coreFormPartialsPath,
		hibachiPathBuilder
	) {
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "multiplefileform.html";
	}
}
export{
	SWMultipleFileForm
}



