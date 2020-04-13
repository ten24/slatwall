class MonatForgotPasswordController {

	// @ngInject
	constructor(public observerService, public monatService) {}

	public $onInit = () => {
		this.observerService.attach(() => {
			window.location.href = document.getElementById('myAccountUrl').getAttribute('href');
		}, 'resetPasswordSuccess' );

	}
	
}

export { MonatForgotPasswordController };