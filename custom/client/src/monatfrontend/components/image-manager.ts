declare var hibachiConfig

class ImageManagerController {
	public firstTry = false;
	// @ngInject
	constructor(
		public $element	
	) {}
	
	public $onInit = () => {
		this.$element[0].addEventListener('error', this.manageImage)
	}
	
	public manageImage = (e) => {
	
		if(this.firstTry){
			this.detachEvent(this.$element[0],'error');
		} 
		
		e.target.src = hibachiConfig.missingImagePath;
		this.firstTry = true;
	}
	
	public detachEvent = (el, event) => {
		el.removeEventListener(event, this.manageImage)
	}
}

class ImageManager {
	public restrict: string = 'A';
	public templateUrl: string;
	public scope: any = {};

	public bindToController: any = {};

	public controller = ImageManagerController;
	public controllerAs = 'imageManager';

	public static Factory() {
		var directive = () => new this();
        directive.$inject = [];
        return directive;
	}
}

export { ImageManager };
