class MonatCheckoutController {

	// @ngInject
	constructor(
		public publicService,
		public observerService,
		public $rootScope
	) {}

	public $onInit = () => {
		this.observerService.attach( this.closeNewAddressForm, 'addNewAccountAddressSuccess')
	}
	
	private closeNewAddressForm = () => {
		this.publicService.addBillingAddressOpen = false;
	}
}

export { MonatCheckoutController };