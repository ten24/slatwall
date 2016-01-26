/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWSaveAndFinishController{
    
   public entity; 
   public redirectUrl; 
   public redirectAction; 
   public redirectQueryString;
   public finish;
   public openNewDialog;
   public partial;
   public rbKey;
   public saving = false;
    
   //@ngInject
   constructor(public $hibachi, public dialogService, public alertService, public $log){
       if(!angular.isFunction(this.entity.$$save)){
           throw("Your entity does not have the $$save function.");
       }
       this.initialSetup();
   } 
   
   public initialSetup = () =>{
       if(!angular.isDefined(this.finish)){
           this.openNewDialog = false; 
       } else { 
           this.openNewDialog = (this.finish.toLowerCase() == 'true') ? false : true;
       }
       if(this.openNewDialog){
           this.rbKey = 'admin.define.saveandnew';
       } else { 
           this.rbKey = 'admin.define.saveandfinish';
       }
   }
   
   public save = () => {
       this.saving = true;
       var savePromise =  this.entity.$$save() 
       
       savePromise.then((data)=>{
            this.dialogService.removeCurrentDialog(); 
            if(this.openNewDialog && angular.isDefined(this.partial)){
                this.dialogService.addPageDialog(this.partial);
            } else { 
                    if(angular.isDefined(this.redirectUrl)){
                        window.location = this.redirectUrl;
                    } else if(angular.isDefined(this.redirectAction)) { 
                        if(angular.isUndefined(this.redirectQueryString)){
                            this.redirectQueryString = "";
                        }
                        window.location = this.$hibachi.buildURL(this.redirectAction, this.redirectQueryString);
                    } else { 
                        this.$log.debug("You did not specify a redirect for swSaveAndFinish");
                    }
            }
       }).catch((data)=>{
           var alert = this.alertService.newAlert();
           alert.msg = data; 
           alert.type = "error"; 
           alert.fade = true; 
           console.log("ALERT???",alert)
           this.alertService.addAlert(alert);
       }).finally(()=>{
           this.saving = false;
       });
   }
}


class SWSaveAndFinish{
   
   public restrict = "EA";
   public scope = {};
   public templateUrl;
   public controller = SWSaveAndFinishController;
   public controllerAs = "swSaveAndFinish"; 
   public bindToController = {  
       entity:"=",
       redirectUrl:"@?",
       redirectAction:"@?",
       redirectQueryString:"@?",
       finish:"@?",
       partial:"@?"
   }
   //@ngInject
   constructor(private hibachiPartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(hibachiPartialsPath) + "saveandfinish.html";
   }
   
   public static Factory(){
		var directive:ng.IDirectiveFactory = (
			hibachiPartialsPath,hibachiPathBuilder
		)=> new SWSaveAndFinish(
            hibachiPartialsPath,hibachiPathBuilder
		);
		directive.$inject = ["hibachiPartialsPath","hibachiPathBuilder"];
		return directive;
	}
}

export{ 
    SWSaveAndFinishController,
    SWSaveAndFinish    
}
