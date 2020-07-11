
class MonatFlexshipOrderItemController {
    public orderItem;
    
    //@ngInject
    constructor() {
    }
    public $onInit = () => {};
}

class MonatFlexshipOrderItem {
	
	public restrict = 'EA'
	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    orderItem:'<'
	};
	public controller=MonatFlexshipOrderItemController;
	public controllerAs="monatFlexshipOrderItem";
	
	public template = require('./monatflexship-orderitem.html');

	public static Factory() {
		return () => new this();
	}
	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipOrderItem
};

