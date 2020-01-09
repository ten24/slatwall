declare var hibachiConfig

class ImageManagerController {
	public firstTry = false;
	public imgWidth: string;
	public imgHeight: string;
	
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
		
		e.target.src = this.getMissingImagePath();
		
		this.firstTry = true;
	}
	
	private getMissingImagePath = () => {
		
		let missingImagePath = hibachiConfig.missingImagePath
		
		// Get resized missing image path if width and height are declared.
		if ( this.imgWidth && this.imgHeight ) {
			let matches = missingImagePath.match( /(\.[a-zA-Z]{3,4})$/ );
			
			if ( matches.length > 1 ) {
				let fileEnding  = `_${this.imgWidth}w_${this.imgHeight}h`;
					fileEnding += matches[1];
				
				missingImagePath = missingImagePath.replace( matches[1], fileEnding );
			}
		}
		
		return missingImagePath;
	}
	
	public detachEvent = (el, event) => {
		el.removeEventListener(event, this.manageImage)
	}
}

class ImageManager {
	public restrict: string = 'A';
	public templateUrl: string;
	public scope: boolean = true;

	public bindToController: any = {
		imgWidth: '@?',
		imgHeight: '@?',
	};

	public controller = ImageManagerController;
	public controllerAs = 'imageManager';

	public static Factory() {
		var directive = () => new this();
        directive.$inject = [];
        return directive;
	}
}

export { ImageManager };
