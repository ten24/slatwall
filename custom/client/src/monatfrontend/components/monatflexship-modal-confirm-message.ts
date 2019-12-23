class MonatFlexshipConfirmMessageController {
	public orderTemplate:any; 
	public loading;
	public close; // injected from angularModalService
	public title :string = "Confirm";
	public bodyText :string = "Are you sure?";
	public buttonText :string  = "Confirm";
	
	//@ngInject
    constructor() {}

    public closeModal = (confirm: boolean = false) => {
     	this.close(confirm); 
    };
}

class MonatFlexshipConfirmMessageModel {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    title:'<?',
	    bodyText:'<?',
	    buttonText:'<?',
	    close:'=' //injected by angularModalService
	};
	public controller=MonatFlexshipConfirmMessageController;
	public controllerAs="monatFlexshipConfirmMessageModel";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatFlexshipConfirmMessageModel(
			monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        );
        directive.$inject = [
			'monatFrontendBasePath',
			'$hibachi',
			'rbkeyService',
			'requestService'
        ];
        return directive;
    }

	constructor(private monatFrontendBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatflexship-modal-confirm-message.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipConfirmMessageModel
};