
class MonatFlexshipOrderItemController {
    public orderItem;
    
    //@ngInject
    constructor() {
    }
    public $onInit = () => {};
}

class MonatFlexshipOrderItem {
	
	public restrict = 'EA'
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
}

export {
	MonatFlexshipOrderItem
};

