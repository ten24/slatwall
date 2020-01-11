export class OnlyForYouController {
	public products: any = {};
	public loading: boolean = true;
	public orderTemplateID;

	// @ngInject
	constructor(
		public publicService,
		public $location,
		public $window,
		public orderTemplateService,
		public monatAlertService
	) {
		this.getPromotionSkus();
	}
	
	private getPromotionSkus = () => {
		
		if ( 'undefined' === typeof this.$location.search().orderTemplateId ) {
			return;
		}
		
		this.orderTemplateID = this.$location.search().orderTemplateId;
		
		
		
		let data = {
			orderTemplateId: this.orderTemplateID,
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
	
	
	public addToFlexship = (skuID) => {
		this.loading = true;
		
		this.orderTemplateService.addOrderTemplateItem( skuID, this.orderTemplateID, 1, true )
		.then((data) => {
			this.monatAlertService.success("Product added to Flexship successfully");
			this.$window.location.href = '/my-account/flexships/';
		})
		.catch( (error) => {
            this.monatAlertService.showErrorsFromResponse(error);
		})
		.finally(() => {
			this.loading = false;
		});
	};
	
}