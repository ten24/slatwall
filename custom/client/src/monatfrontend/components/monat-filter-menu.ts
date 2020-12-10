import { MonatService } from "@Monat/services/monatservice";

class MonatFilterMenuController{
	
	public showFilterMenu = false;
	public showMainFilterMenu = true;
	public filterCategory:string = "";
	public filterSubCategory:string = "";
	public productFilterTitle:string = "";
	public parentController;
	public headerHeight;
	public productFunction:string;
	
	public constructor(
		private monatService : MonatService,
	){};
	
	public $onInit = () => {
		this.productFunction = this.productFunction || 'getProductList';
	}
	
	public toggleFilterMenu = () => {
		this.setTopHeight();
		this.showFilterMenu = !this.showFilterMenu;
	}
	
	public toggleFilterSubCategory = (category) => {
		this.showMainFilterMenu = false;
		this.filterCategory = category;
	}
	
	public callProductFunction = (category, categoryType)=>{
		this.showFilterMenu = false;
		return this.parentController[this.productFunction](category,categoryType);
	}
	
	public clearFilter = () => {
		$('input[type="radio"]').prop('checked', false);
	}
	
	public setTopHeight = () => {
		this.headerHeight =	$('.site-header').outerHeight();
	}
	
}

class MonatFilterMenu {
	public restrict = 'E';
	public templateUrl: string;

	public scope = {};
		public bindToController = {
	    	parentController:'=',
	    	productFunction:'@'
		}
	public controller = MonatFilterMenuController;
	public controllerAs = 'monatFilterMenu';
	
	public template = require('./monat-filter-menu.html');
	
	public static Factory() {
		return () => new this();
	}

}

export { MonatFilterMenu };