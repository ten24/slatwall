import { PublicService } from "@Monat/monatfrontend.module";
import { MonatService } from "@Monat/services/monatservice";
import { ObserverService } from "@Hibachi/core/core.module";
import { OrderTemplateService, WishlistItemLight } from "@Monat/services/ordertemplateservice";

class MonatSearchController {
	
	public productList: Array<any> = [];
	public loading: boolean = false;
	public keyword: string = '';
	public recordsCount: any;
	public priceGroupCode;
	public argumentsObject: any;
	public wishlistItems: string[];
	public pageRecordsShow: number=40;

	// @ngInject
	constructor(
		public $location,
		public monatService         : MonatService,
		public publicService        : PublicService,
		public observerService      : ObserverService,
		public orderTemplateService : OrderTemplateService
	) {
		if ( 'undefined' !== typeof this.$location.search().keyword ) {
			this.getProductsByKeyword( this.$location.search().keyword );
		}
		this.observerService.attach(this.getWishlistItems,'getAccountSuccess');
	}
	
	public getWishlistItems = () => {
	    
		if(!this.publicService.account?.accountID){
			return;
		}
		
	    this.orderTemplateService.getAccountWishlistItemIDs().then( wishlistItems => {
            this.wishlistItems = [];
            wishlistItems.forEach( item => this.wishlistItems.push(item.skuID) );
        });
	}

	public getProductsByKeyword = keyword => {
		this.argumentsObject = {keyword: keyword} // defining the arguments object to be passed into pagination directive
		this.loading = true;
		this.keyword = keyword;
		let priceGroupCode = this.priceGroupCode;
		let pageRecordsShow=40;
		this.publicService.doAction( 'getProductsByKeyword', { keyword: keyword, priceGroupCode: priceGroupCode,pageRecordsShow:pageRecordsShow } ).then(data => {
			this.observerService.notify('PromiseComplete');
			this.recordsCount = data.recordsCount;
			this.productList = data.productList;
			this.loading = false;
		})

	}
	
}

export { MonatSearchController };