class MonatConfirmMessageController {
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

class MonatConfirmMessageModel {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    title:'<?',
	    bodyText:'<?',
	    buttonText:'<?',
	    close:'=' //injected by angularModalService
	};
	public controller=MonatConfirmMessageController;
	public controllerAs="monatConfirmMessageModel";

	public static Factory(){
        var directive:any = (
		    monatFrontendBasePath,
			$hibachi,
			rbkeyService,
			requestService
        ) => new MonatConfirmMessageModel(
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
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monat-modal-confirm-message.html";
		this.restrict = "E";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatConfirmMessageModel
};