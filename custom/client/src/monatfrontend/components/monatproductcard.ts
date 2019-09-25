class MonatProductCard {

	public restrict:string = 'EA';
	public templateUrl:string;
	public replace:boolean = true;
	public transclude:boolean = true;
	public scope ={
		productInfo: '=product',
		isWishlist: '=wishlist',
		isLoggedIn: '=loggedIn',
		loopIndex: '=currentLoopIndex'
	}
	
	public require = '^monatProductCard';

	public static Factory(){
		var directive:any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor( private monatFrontendBasePath ){
		this.templateUrl = monatFrontendBasePath + "/monatfrontend/components/monatproductcard.html";
	}
	
}

export {
	MonatProductCard
};

