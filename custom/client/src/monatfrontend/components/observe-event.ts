class ObserveEventController {
	public event: string;
	public eventCalled: boolean = false;
	public timeout: number;

	// @ngInject
	constructor( public observerService, public $timeout ) {}
	
	public $onInit = () => {
		this.observerService.attach( this.handleEventCalled, this.event );
	}
	
	public handleEventCalled = () => {
		this.eventCalled = true;
		
		if ( angular.isDefined( this.timeout ) ) {
			this.$timeout(() => {
				this.eventCalled = false;
			}, +this.timeout );
		}
	}
}

class ObserveEvent {
	public restrict: string = 'A';
	public templateUrl: string;
	public scope: any = true;

	public bindToController: any = {
		event: '@',
		timeout: '@?'
	};

	public controller = ObserveEventController;
	public controllerAs = 'observeEvent';

	public static Factory() {
		var directive = () => new this();
        directive.$inject = [];
        return directive;
	}
}

export { ObserveEvent };
