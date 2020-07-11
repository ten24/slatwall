
interface Message {
	message: string,
	amount:number,
	qualifierProgress:number
}
class FlexshipPurchasePlusController {
	public messages:Message;
	
	//@ngInject
	constructor() {}

	public $onInit = () => {}
	
	
	
}

class FlexshipPurchasePlus {
	public restrict = 'E';
	public templateUrl: string;
	public controller = FlexshipPurchasePlusController;
	public controllerAs = 'flexshipPurchasePlus';
	public bindToController = {
		messages: '<'
	}
	public template = require('./flexshipPurchasePlus.html');

	public static Factory() {
		return () => new this();
	}
}

export { FlexshipPurchasePlus };
