class MonatProductReviewController {
	public newProductReview;
	public close; // injected from angularModalService
	public stars:Array<string> = ['','','','',''];
	public reviewerName;
	public productReview
	//@ngInject
	constructor(
		public observerService, 
		public rbkeyService, 
	) {
    	this.observerService.attach(() =>{
            this.closeModal();
        },
        "addProductReviewSuccess"); 
	}

	public $onInit = () => {
		console.log('init')
		this.newProductReview = this.productReview
        this.newProductReview['reviewerName'] = this.reviewerName;
    	this.newProductReview['rating'] = null;
    	this.newProductReview['review'] = null;
	};
	
    public setRating = (rating) => {
    	this.newProductReview['rating'] = rating;
        for(let i = 0; i <= rating - 1; i++) {
            this.stars[i] = "fas";
        };
    }

	public closeModal = () => {
		console.log('closing modal');
		this.close(null); // close, but give 100ms to animate
	}
}

class MonatProductReview {
	public restrict = 'E';
	public templateUrl: string;

	public scope = {};
	public bindToController = {
		productReview:'=',
		reviewerName:'<',
		close: '=', //injected by angularModalService
	};
	public controller = MonatProductReviewController;
	public controllerAs = 'monatProductReview';

	public template = require('./monat-product-review.html');

	public static Factory() {
		return () => new this();
	}
	public link = (scope, element, attrs) => {};
}

export { MonatProductReview };
