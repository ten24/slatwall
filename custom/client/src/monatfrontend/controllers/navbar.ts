class MonatNavbarController {

	// @ngInject
	constructor(public observerService, public monatService, public ModalService, private rbkeyService) {}

	public $onInit = () => {

	}
	
	public saveEnrollment = ()=>{
		this.ModalService.showModal({
		      component: 'saveEnrollmentModal',
		      bodyClass: 'angular-modal-service-active',
			  bindings: {
			    title: this.rbkeyService.rbKey('frontend.enrollment.saveEnrollment'),
			  },
			  preClose: (modal) => {
				modal.element.modal('hide');
			},
		}).then( (modal) => {
			modal.element.modal(); //it's a bootstrap element, using '.modal()' to show it
		    modal.close.then( (confirm) => {
		    });
		}).catch((error) => {
			console.error("unable to open saveEnrollmentModal :",error);	
		});
    }
	
}

export { MonatNavbarController };