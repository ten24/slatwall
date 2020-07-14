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

	public restrict: string = 'E';
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
	
	public template = require('./monat-modal-confirm-message.html');

	public static Factory() {
		return () => new this();
	}
	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatConfirmMessageModel
};