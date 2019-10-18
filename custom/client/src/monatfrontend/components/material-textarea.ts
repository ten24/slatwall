class MaterialTextareaController {
	public textarea;
	public rows;

	// @ngInject
	constructor(
		public $element	
	) {}
	
	public $onInit = () => {
		this.$element[0].rows = '1';

		this.$element[0].oninput = ( event ) => {
			event.target.style.height = 'auto';
			event.target.style.height = event.target.scrollHeight + 7 + 'px';
		}
	}
}

class MaterialTextarea {
	public restrict: string = 'A';
	public templateUrl: string;
	public scope: any = {};

	public bindToController: any = {};

	public controller = MaterialTextareaController;
	public controllerAs = 'materialTextarea';

	public static Factory() {
		var directive = () => new this();
        directive.$inject = [];
        return directive;
	}
}

export {MaterialTextarea };
