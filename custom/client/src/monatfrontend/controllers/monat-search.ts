class MonatSearchController {
	
	public productList: Array<any> = [];
	public loading: boolean = false;
	public keyword: string = '';
	public recordsCount:any;

	// @ngInject
	constructor(
		public publicService,
		public monatService,
		public $location,
		public observerService
	) {}

	public $onInit = () => {
		if ( 'undefined' !== typeof this.$location.search().keyword ) {
			this.getProductsByKeyword( this.$location.search().keyword );
		}
	}
	
	public getProductsByKeyword = keyword => {
		
		this.loading = true;
		this.keyword = keyword;
		
		this.publicService.getAccount().then(data => {
			let priceGroupCode = "2";
			if ( this.publicService.account.priceGroups.length ) {
				priceGroupCode = this.publicService.account.priceGroups[0].priceGroupCode;
			}
			
			this.publicService.doAction( 'getProductsByKeyword', { keyword: keyword, priceGroupCode: priceGroupCode } ).then(data => {
				this.observerService.notify('PromiseComplete');
				this.recordsCount = data.recordsCount;
				this.productList = data.productList;
				this.loading = false;
			})
		})
	}
	
}

export { MonatSearchController };