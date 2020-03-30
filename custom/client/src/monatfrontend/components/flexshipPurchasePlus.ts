
interface Message {
	message: string,
	amount:number,
	qualifierProgress:number
}
class FlexshipPurchasePlusController {
	public messages:Message;
	
	//@ngInject
	constructor() {}

	public $onInit = () => {
		console.log(this.messages)
	}
	
	
	
}

class FlexshipPurchasePlus {
	public restrict = 'E';
	public templateUrl: string;
	public controller = FlexshipPurchasePlusController;
	public controllerAs = 'flexshipPurchasePlus';
	public bindToController = {
		messages: '<'
	}
	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/flexshipPurchasePlus.html';
	}
}

export { FlexshipPurchasePlus };
