declare var hibachiConfig;

class MonatFlexshipCardController {
	
	public restrict = 'EA'
	public dayOfMonthFormatted: string;

	public orderTemplate: any;
	public userCanEditOFYProductFlag = false;
	public showAddOFYProductCallout = false;
	
	public urlSitePrefix: string;

	public daysToEditFlexship:any;
	public editFlexshipUntilDate:any;

	//@ngInject
	constructor(
		public observerService, 
		public orderTemplateService, 
		public $window, 
		public ModalService, 
		public monatAlertService,
		public rbkeyService,
		public monatService,
		public publicService
	) {}

	public $onInit = () => {
		this.urlSitePrefix = ( hibachiConfig.cmsSiteID === 'default' ) ? '' : `${hibachiConfig.cmsSiteID}/`;
		this.observerService.attach(
			this.updateOrderTemplate,
			'orderTemplateUpdated' + this.orderTemplate.orderTemplateID,
		);
		this.showAddOFYProductCallout = this.getCanSelectOFY();
	};
	
	public $onDestroy = () => {
		this.observerService.detachById('orderTemplateUpdated' + this.orderTemplate.orderTemplateID);
	};
	
	
	public getCanSelectOFY = ():boolean =>{
		if(this.orderTemplate.scheduleOrderNextPlaceDateTime){
			
			let nextScheduledOrderDate = new Date(Date.parse(this.orderTemplate.scheduleOrderNextPlaceDateTime));
			
			this.editFlexshipUntilDate = new Date(nextScheduledOrderDate.getTime());
			this.editFlexshipUntilDate.setDate(nextScheduledOrderDate.getDate() - this.daysToEditFlexship);  
			
			//user can add/edit OFY, until one 1-day before next-scheduled-order-date;
			let addEditOFYUntilDate = new Date(nextScheduledOrderDate.getTime());
			let today = new Date();
			
			addEditOFYUntilDate.setDate(addEditOFYUntilDate.getDate() - 1);
			this.userCanEditOFYProductFlag = ( today <= addEditOFYUntilDate );

			//we'll show add OFY callout, if next-scheduled-order-date is within current-month
			return ( today <= addEditOFYUntilDate && today.getMonth() <= nextScheduledOrderDate.getMonth() );
			
		}
	}
	
	public updateOrderTemplate = (orderTemplate?) => {
		this.orderTemplate = orderTemplate;
		this.showAddOFYProductCallout = this.getCanSelectOFY();
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

	public showFlexshipScheduleModal = () => {
		this.ModalService.showModal({
			component: 'monatFlexshipScheduleModal',
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
			console.error('unable to open model: monatFlexshipScheduleModal', error);
		});
	};

	//TODO refactorout to fexship listing, observerservice can be used to do that, or a whole new MonalModalService
	public showFlexshipEditPaymentMethodModal = () => {
		this.ModalService.showModal({
			component: 'monatFlexshipPaymentMethodModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				orderTemplate: this.orderTemplate
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
				orderTemplate: this.orderTemplate
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
					
					this.monatAlertService.success(
							this.rbkeyService.rbKey('alert.flexship.activationSuccessful')
						);
						
						this.monatService.redirectToProperSite(
							`/flexship-confirmation/?type=flexship&orderTemplateId=${this.orderTemplate.orderTemplateID}`
							);
				} else {
					throw(data);
				}
			})
			.catch( (error) => {
				console.error(error);
	            this.monatAlertService.showErrorsFromResponse(error);
			});
	}

	public goToProductListingPage() {

		this.publicService.doAction('setCurrentFlexshipOnHibachiScope', {orderTemplateID: this.orderTemplate.orderTemplateID}).then(res=>{
			this.monatService.redirectToProperSite(	'/flexship-flow');
		});
	}
	
	public goToOFYProductListingPage() {
		this.monatService.redirectToProperSite(
							`/shop/only-for-you/?type=flexship&orderTemplateId=${this.orderTemplate.orderTemplateID}`
						);
	}
	
	public showDeleteOrderTemplateModal = () => {
		this.ModalService.showModal({
			component: 'MonatFlexshipDeleteModal',
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

class MonatFlexshipCard {
	public restrict: string;
	public templateUrl: string;
	public scope = {};
	public bindToController = {
		orderTemplate: '<',
		daysToEditFlexship:'@?',
	};
	public controller = MonatFlexshipCardController;
	public controllerAs = 'monatFlexshipCard';

	public template = require('./monatflexshipcard.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) => {};
}

export { MonatFlexshipCard };
