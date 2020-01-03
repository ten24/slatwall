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
		
		e.target.src = this.getMissingImagePath( e.target );
		
		this.firstTry = true;
	}
	
	private getMissingImagePath = ( e ) => {
		
		let width = this.$element[0].getAttribute('data-width');
		let height = this.$element[0].getAttribute('data-height');
		
		let missingImagePath = hibachiConfig.missingImagePath
		
		// Get resized missing image path if width and height are declared.
		if ( null !== width && null !== height ) {
			let matches = missingImagePath.match( /(\.[a-zA-Z]{3,4})$/ );
			
			console.log( matches );
			
			if ( matches.length > 1 ) {
				let fileEnding  = `_${width}w_${height}h`;
					fileEnding += matches[1];
				
				missingImagePath = missingImagePath.replace( matches[1], fileEnding );
				console.log( missingImagePath );
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
