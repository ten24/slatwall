class MonatSearchController {
	
	public productList: Array<any> = [];
	public loading: boolean = false;
	public keyword: string = '';
	public recordsCount: any;
	public priceGroupCode;
	public argumentsObject: any;

	// @ngInject
	constructor(
		public publicService,
		public monatService,
		public $location,
		public observerService
	) {
		if ( 'undefined' !== typeof this.$location.search().keyword ) {
			this.getProductsByKeyword( this.$location.search().keyword );
		}
	}

	public getProductsByKeyword = keyword => {
		this.argumentsObject = {keyword: keyword} // defining the arguments object to be passed into pagination directive
		this.loading = true;
		this.keyword = keyword;
		let priceGroupCode = this.priceGroupCode;
		this.publicService.doAction( 'getProductsByKeyword', { keyword: keyword, priceGroupCode: priceGroupCode } ).then(data => {
			this.observerService.notify('PromiseComplete');
			this.recordsCount = data.recordsCount;
			this.productList = data.productList;
			this.loading = false;
		})

	}
	
}

export { MonatSearchController };