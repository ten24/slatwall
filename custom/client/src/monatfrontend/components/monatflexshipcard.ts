class MonatFlexshipCardController {
	public dayOfMonthFormatted: string;

	public orderTemplate: any;

	public accountAddresses: any[];
	public accountPaymentMethods: any[];
	public shippingMethodOptions: any[];
	public stateCodeOptions: any[];
	public cancellationReasonTypeOptions: any[];
	public scheduleDateChangeReasonTypeOptions: any[];

	public expirationMonthOptions: any[];
	public expirationYearOptions: any[];
	public daysToEditFlexship:any;
	public editFlexshipUntilDate:any;
	//@ngInject
	constructor(public observerService, public orderTemplateService, public $window, public ModalService, public monatAlertService) {}

	public $onInit = () => {
		
		this.observerService.attach(
			this.updateOrderTemplate,
			'orderTemplateUpdated' + this.orderTemplate.orderTemplateID,
		);
		
		if(this.orderTemplate.scheduleOrderNextPlaceDateTime){
			let mostRecentFlexshipDeliveryDate = Date.parse(this.orderTemplate.scheduleOrderNextPlaceDateTime);
			this.editFlexshipUntilDate = new Date(mostRecentFlexshipDeliveryDate);
			this.editFlexshipUntilDate.setDate(this.editFlexshipUntilDate.getDate() - this.daysToEditFlexship);          
		}

	};

	public $onDestroy = () => {
		this.observerService.detachById('orderTemplateUpdated' + this.orderTemplate.orderTemplateID);
	};

	public updateOrderTemplate = (orderTemplate?) => {
		this.orderTemplate = orderTemplate;
	};

	//TODO refactorout to fexship listing, observerservice can be used to do that, or a whole new MonalModalService
	public showEditFlexshipNameModal = () => {
		this.ModalService.closeModals();
		this.ModalService.showModal({
			component: 'monatFlexshipNameModal',
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
	
	public showAddGiftCardModal = () => {
		this.ModalService.closeModals();
		this.ModalService.showModal({
			component: 'monatFlexshipAddGiftCardModal',
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
	
	
		//TODO refactorout to fexship listing, observerservice can be used to do that, or a whole new MonalModalService
	public showCancelFlexshipModal = () => {
		this.ModalService.showModal({
			component: 'monatFlexshipCancelModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				orderTemplate: this.orderTemplate,
				cancellationReasonTypeOptions: this.cancellationReasonTypeOptions,
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

	public activateFlexship() {
		// make api request
		this.orderTemplateService
			.activateOrderTemplate({
				orderTemplateID :	this.orderTemplate.orderTemplateID
			})
			.then( (data) => {
				if (data.orderTemplate) {
					this.orderTemplate = data.orderTemplate;
					this.observerService.notify(
						'orderTemplateUpdated' + data.orderTemplate.orderTemplateID,
						data.orderTemplate,
					);
					this.monatAlertService.success("Your flexship has been Activated successfully");
				} else {
					throw(data);
				}
			})
			.catch( (error) => {
				console.error(error);
	            this.monatAlertService.showErrorsFromResponse(error);
			});
	}

	public setAsCurrentFlexship() {
		// make api request
		this.orderTemplateService
			.setAsCurrentFlexship(this.orderTemplate.orderTemplateID)
			.then((data) => {
				if (
					data.successfulActions &&
					data.successfulActions.indexOf('public:setAsCurrentFlexship') > -1
				) {
					this.$window.location.href = `/shop/?type=flexship&orderTemplateId=${this.orderTemplate.orderTemplateID}`;
				} else {
					throw data;
				}
			})
			.catch((error) => {
				console.error('setAsCurrentFlexship :', error);
				// TODO: show alert
			});
	}
}

class MonatFlexshipCard {
	public restrict: string;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		orderTemplate: '<',
		accountAddresses: '<',
		accountPaymentMethods: '<',
		shippingMethodOptions: '<',
		stateCodeOptions: '<',
		cancellationReasonTypeOptions: '<',
		scheduleDateChangeReasonTypeOptions: '<',
		expirationMonthOptions: '<',
		expirationYearOptions: '<',
		daysToEditFlexship:'@?'
	};
	public controller = MonatFlexshipCardController;
	public controllerAs = 'monatFlexshipCard';

	public static Factory() {
		var directive: any = (monatFrontendBasePath, $hibachi, rbkeyService, requestService) =>
			new MonatFlexshipCard(monatFrontendBasePath, $hibachi, rbkeyService, requestService);
		directive.$inject = ['monatFrontendBasePath', '$hibachi', 'rbkeyService', 'requestService'];
		return directive;
	}

	constructor(
		private monatFrontendBasePath,
		private slatwallPathBuilder,
		private $hibachi,
		private rbkeyService,
	) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/monatflexshipcard.html';
		this.restrict = 'EA';
	}

	public link = (scope, element, attrs) => {};
}

export { MonatFlexshipCard };
