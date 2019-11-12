export class MonatModalService {
    private cancellationReasonTypeOptions;

    //@ngInject
	constructor( public orderTemplateService, public $window, public publicService, public ModalService){
	    
	}
	
	
	public getCancellationReasonTypeOptions = () => {
	    //todo
	    return this.cancellationReasonTypeOptions;
	}
	
	
	
	//TODO refactorout to fexship listing, observerservice can be used to do that, or a whole new MonalModalService
	public showCancelFlexshipModal = (orderTemplate) => {
		this.ModalService.showModal({
			component: 'monatFlexshipCancelModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				orderTemplate: orderTemplate,
				cancellationReasonTypeOptions: this.getCancellationReasonTypeOptions(),
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	};

	//TODO refactorout to fexship listing, observerservice can be used to do that, or a whole new MonalModalService
	public showDelayOrSkipFlexshipModal = () => {
		this.ModalService.showModal({
			component: 'monatFlexshipChangeOrSkipOrderModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				orderTemplate: this.orderTemplate,
				scheduleDateChangeReasonTypeOptions: this.scheduleDateChangeReasonTypeOptions,
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
			.then((modal) => {
				//it's a bootstrap element, use 'modal' to show it
				modal.element.modal();
				modal.close.then((result) => {});
			})
			.catch((error) => {
				console.error('unable to open model :', error);
			});
	};

	//TODO refactorout to fexship listing, observerservice can be used to do that, or a whole new MonalModalService
	public showFlexshipEditPaymentMethodModal = () => {
		this.ModalService.showModal({
			component: 'monatFlexshipPaymentMethodModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				orderTemplate: this.orderTemplate,
				accountAddresses: this.accountAddresses,
				accountPaymentMethods: this.accountPaymentMethods,
				stateCodeOptions: this.stateCodeOptions,
				expirationMonthOptions: this.expirationMonthOptions,
				expirationYearOptions: this.expirationYearOptions,
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
			.then((modal) => {
				//it's a bootstrap element, use 'modal' to show it
				modal.element.modal();
				modal.close.then((result) => {});
			})
			.catch((error) => {
				console.error('unable to open model :', error);
			});
	};

	//TODO refactorout to fexship listing, observerservice can be used to do that, or a whole new MonalModalService
	public showFlexshipEditShippingMethodModal = () => {
		this.ModalService.showModal({
			component: 'monatFlexshipShippingMethodModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				orderTemplate: this.orderTemplate,
				accountAddresses: this.accountAddresses,
				shippingMethodOptions: this.shippingMethodOptions,
				stateCodeOptions: this.stateCodeOptions,
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
			.then((modal) => {
				//it's a bootstrap element, use 'modal' to show it
				modal.element.modal();
				modal.close.then((result) => {});
			})
			.catch((error) => {
				console.error('unable to open model :', error);
			});
	};

	public showFlexshipEditFrequencyMethodModal = () => {
		this.ModalService.showModal({
			component: 'monatFlexshipFrequencyModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				orderTemplate: this.orderTemplate,

			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
			.then((modal) => {
				//it's a bootstrap element, use 'modal' to show it
				modal.element.modal();
				modal.close.then((result) => {});
			})
			.catch((error) => {
				console.error('unable to open model :', error);
			});
	};

}
