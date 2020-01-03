export class OnlyForYouController {
	public products: any = {};
	public loading: boolean = true;

	// @ngInject
	constructor(
		public publicService,
		public $location
	) {
		this.getPromotionSkus();
		
	}
	
	private getPromotionSkus = () => {
		
		if ( 'undefined' === typeof this.$location.search().orderTemplateId ) {
			return;
		}
		
		let data = {
			orderTemplateId: this.$location.search().orderTemplateId,
			pageRecordsShow: 20,
		}
		
		this.publicService.doAction( 'getOrderTemplatePromotionProducts', data )
			.then( result => {
				this.products = result.orderTemplatePromotionProducts;
			})
			.finally( result => {
				this.loading = false;
			} )
	}
	
}