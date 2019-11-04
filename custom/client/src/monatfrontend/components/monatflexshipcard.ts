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
	constructor(public observerService, public ModalService, public publicService) {}

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
