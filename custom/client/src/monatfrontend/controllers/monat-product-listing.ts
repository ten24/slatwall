class MonatProductListingController {
    public loading:boolean;
    public accountData:any;
    public cmsContentID:string = '';  
    public argumentsObject:any = {};
    public productList:any;
    public cmsCategoryFilterFlag:boolean;
    public contentFilterFlag:boolean;
    public cmsContentFilterFlag:boolean;

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
        
        // CMS category ID is the only filter applied via ng-init and getting the CF category, due to content modules loop
        // All others are handled with headers, and only need the flag 
        
        if(this.cmsContentID.length && this.cmsContentFilterFlag) { 
            this.argumentsObject['cmsContentID'] = this.cmsContentID;  
            this.argumentsObject['cmsContentFilterFlag'] = true;  
        }

        if(this.contentFilterFlag) this.argumentsObject['contentFilterFlag'] = true;  
        if(this.cmsCategoryFilterFlag == true) this.argumentsObject['cmsCategoryFilterFlag'] = true;  

        this.publicService.doAction('getProductsByCategoryOrContentID', this.argumentsObject).then(result => {
            this.productList = result.productList;
            this.loading = false;
        })
    }
}
/*********************
    To use: 
    1. Declare as controller of a wrapper div
    2. ng-init a flag if you would like to filter on it 
        the corresponding ID is already being sent in the headers (with exception of cmsContentID for content-module loops, this will need an ng-init)
    3. ng-repeat using monat-product-card
    4. Use pagination directive if you would like to paginate
    
*******************/

export {  MonatProductListingController };