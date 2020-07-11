
class MonatFlexshipOrderTotalCardController {
    
    //@ngInject
    constructor() {
    }
    public $onInit = () => {};
}

class MonatFlexshipOrderTotalCard {
	
	public restrict = 'EA'
	public restrict:string;
	public templateUrl:string;
	
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
	public link = (scope, element, attrs) =>{

	}

}

export {
	MonatFlexshipOrderTotalCard
};

