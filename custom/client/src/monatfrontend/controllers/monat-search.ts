class MonatSearchController {
	
	public productList: Array<any> = [];
	public loading: boolean = false;

	// @ngInject
	constructor(
		public publicService,
		public monatService,
		public $location
	) {}

	public $onInit = () => {
		if ( 'undefined' !== typeof this.$location.search().keyword ) {
			let keyword = this.$location.search().keyword;
			this.getProductsByKeyword( keyword );
		}
	}
	
	public getProductsByKeyword = keyword => {
		
		this.loading = true;
		
		this.publicService.getAccount().then(data => {
			let priceGroupCode = "2";
			if ( this.publicService.account.priceGroups.length ) {
				priceGroupCode = this.publicService.account.priceGroups[0].priceGroupCode;
			}
			
			this.publicService.doAction( 'getProductsByKeyword', { keyword: keyword, priceGroupCode: priceGroupCode } ).then(data => {
				this.productList = data.productList;
				
				this.loading = false;
			})
		})
	}
	
}

export { MonatSearchController };