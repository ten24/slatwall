export class OnlyForYouController {

	// @ngInject
	constructor(
		public publicService,
		public $location
	) {
		this.getPromotionSkus();
		console.log( this.$location.search().ebhjwq );
		
	}
	
	private getPromotionSkus = () => {
		
		if ( 'undefined' === typeof this.$location.search().orderTemplateId ) {
			return;
		}
		
		let data = {
			orderTemplateId: this.$location.search().orderTemplateId
		}
		
		this.publicService.doAction( 'getOrderTemplatePromotionSkus', data )
			.then( result => {
				console.log( result );
			})
	}
	
}