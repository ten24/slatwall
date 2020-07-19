/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWEntityActionBarController{
    
    public backAction:string;
    
    public baseQueryString:string;
    
    public cancelEvent:string;
    public cancelAction:string;
    public cancelQueryString:string; 
    
    public showDelete:boolean;
    public deleteAction:string;
    public deleteQueryString:string;
    
    public edit:boolean;
    
    public editEvent:string;
    public editAction:string;
    public editQueryString:string;
    public entityActionDetails;

    public messages;
    
    public pageTitle:string; 
    public pageTitleRbKey:string; 
    
    public payload;
    
    public processCallers;
    public printProcessCallers;
    public swProcessCallers;
    public swPrintProcessCallers;
    
    public saveEvent:string;
    public saveAction:string;
    public saveQueryString:string;
    
    public type:string;

    
    //@ngInject
    constructor( private observerService,
                 private rbkeyService
    ){
        
    }
    
    public $onInit = () =>{
        
        if(this.edit == null){
            this.edit = false; 
        }
        
        if(this.showDelete == null){
            this.showDelete = true;
        }
        
        if(angular.isDefined(this.pageTitleRbKey)){
            this.pageTitle = this.rbkeyService.getRBKey(this.pageTitleRbKey);
        }
        
        if(this.entityActionDetails != null){
            this.backAction = this.entityActionDetails.backAction;
            this.cancelAction = this.entityActionDetails.cancelAction; 
            this.deleteAction = this.entityActionDetails.deleteAction;
            this.editAction = this.entityActionDetails.editAction;
            this.saveAction = this.entityActionDetails.saveAction;
        }
        
        this.cancelQueryString = this.cancelQueryString || '';
        this.deleteQueryString = this.deleteQueryString || '';
        this.editQueryString = this.editQueryString || '';
        this.saveQueryString = this.saveQueryString || '';
        
        if(this.baseQueryString != null){
            this.cancelQueryString = this.baseQueryString + this.cancelQueryString;
            this.editQueryString = this.baseQueryString + this.editQueryString;
            this.deleteQueryString = this.baseQueryString + this.deleteQueryString;
            this.saveQueryString = this.baseQueryString + this.saveQueryString;

            if(this.processCallers != null){
                for(var i=0; i<this.processCallers.length; i++){
                    this.processCallers[i].queryString = this.getQueryStringForProcessCaller(this.processCallers[i]);
                }
            }
            
            if(this.printProcessCallers){
                for(var i=0; i<this.printProcessCallers.length; i++){
                    this.printProcessCallers[i].queryString = this.getQueryStringForProcessCaller(this.printProcessCallers[i]);
                }
            }
        }

        this.swProcessCallers = this.processCallers;
        this.swPrintProcessCallers = this.printProcessCallers;
        
        if(this.editEvent != null){
            this.observerService.attach(this.toggleEditMode, this.editEvent);
        }
        
        if(this.cancelEvent != null){
            this.observerService.attach(this.toggleEditMode, this.cancelEvent); 
        }
        
        if(this.saveEvent != null){
            this.observerService.attach(this.toggleEditMode, this.saveEvent); 
        }
        
        this.payload = {
            'edit':this.edit
        };
        
        //there should only be one action bar on a page so no id
        this.observerService.notify('swEntityActionBar', this.payload)
    }
    
    public getQueryStringForProcessCaller = (processCaller)=>{
        if(processCaller.queryString != null){
            return this.baseQueryString + '&' + processCaller.queryString;
        } 
        return this.baseQueryString;
    }
    
    public toggleEditMode = () =>{
        this.edit = !this.edit;
        
        this.payload = {
            'edit':this.edit
        };
        
        this.observerService.notify('swEntityActionBar', this.payload)
    }

}

class SWEntityActionBar implements ng.IDirective{

    public restrict:string = 'E';
    public transclude = true;
    
    public scope = {};
    public bindToController={
        /*Core settings*/
        type:"@",
        object:"=",
        pageTitle:"@?",
        pageTitleRbKey:"@?",
        edit:"=",
        entityActionDetails:"<?",
        baseQueryString:"@?",
        messages:"<?",
        
        /*Action Callers (top buttons)*/
        showCancel:"=",
        showCreate:"=",
        showEdit:"=",
        showDelete:"=",

        /*Basic Action Caller Overrides*/
        createEvent:"@?",
        createModal:"=",
        createAction:"@",
        createQueryString:"@",

        backEvent:"@?",
        backAction:"@?",
        backQueryString:"@?",

        cancelEvent:"@?",
        cancelAction:"@?",
        cancelQueryString:"@?",

        deleteEvent:"@?", 
        deleteAction:"@?",
        deleteQueryString:"@?",
        
        editEvent:"@?",
        editAction:"@?",
        editQueryString:"@?",
        
        saveEvent:"@?",
        saveAction:"@?",
        saveQueryString:"@?",

        /*Process Specific Values*/
        processEvent:"@?",
        processAction:"@?",
        processContext:"@?",
        
        processCallers:"<?",
        printProcessCallers:"<?"

    };
    public controller=SWEntityActionBarController
    public controllerAs="swEntityActionBar";
    
    public template = require("./entityactionbar.html");

	public static Factory(){
		return /** @ngInject; */ () => new this();
	}
}
export{
    SWEntityActionBar
}


