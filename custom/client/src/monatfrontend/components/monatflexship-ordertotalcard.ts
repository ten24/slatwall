
class MonatFlexshipOrderTotalCardController {
    
    //@ngInject
    constructor() {
    }
    public $onInit = () => {};
}

class MonatFlexshipOrderTotalCard {
	
	public restrict = 'EA'
	
	public scope = {};
	public bindToController = {
	    orderTemplate:'='
	};
	
	public controller = MonatFlexshipOrderTotalCardController;
	public controllerAs = "monatFlexshipOrderTotalCard";

	public template = require('./monatflexship-ordertotalcard.html');

	public static Factory() {
		return () => new this();
	}
}

export {
	MonatFlexshipOrderTotalCard
};

