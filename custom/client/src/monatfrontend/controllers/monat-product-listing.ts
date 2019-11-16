class MonatProductListingController {
    public loading:boolean;
    public accountData:any;
    public cmsContentID:string = '';  
    public argumentsObject:any = {};
    public productList:any;
    public categoryFilterFlag:boolean;
    
	// @ngInject
	constructor(
		public publicService,
		public observerService,
		public $rootScope
	) {}

	public $postLink = () => {
	    this.getProducts();
	}
	
    public getProducts = () => {
        this.loading = true;
        if(this.cmsContentID.length && this.categoryFilterFlag) this.argumentsObject['cmsContentID'] = this.cmsContentID;  

        this.publicService.doAction('getProductsByCategoryOrContentID', this.argumentsObject).then(result => {
            this.productList = result.productList;
            this.loading = false;
        })
    }
}



export {  MonatProductListingController };