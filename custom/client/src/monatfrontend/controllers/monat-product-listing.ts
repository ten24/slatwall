class MonatProductListingController {
    public loading:boolean;
    public accountData:any;
    public priceGroupCode:number;
    public currencyCode:string;
    public categoryID:string = '';
    public contentID:string = '';
    public cmsContentID:string = '';  
    public argumentsObject:any = {};
    public productList:any;
    public productListLoading:boolean
    
	// @ngInject
	constructor(
		public publicService,
		public observerService,
		public $rootScope
	) {}

	public $onInit = () => {
	    this.getAccount();
	}
	
    public getAccount = () => {
        this.loading = true;
        
        this.publicService.getAccount(true).then((response)=>{
            this.accountData = response;
            this.priceGroupCode = this.accountData.priceGroups.length ? this.accountData.priceGroups[0].priceGroupCode : 2;
            this.loading = false;
            this.argumentsObject['priceGroupCode'] = this.priceGroupCode;
            this.argumentsObject['currencyCode'] = this.currencyCode;
            
            if(this.contentID.length){
                this.argumentsObject['contentID'] = this.contentID;  
            }else if(this.categoryID.length){
                this.argumentsObject['categoryID'] = this.categoryID;  
            }else if(this.cmsContentID.length){
                this.argumentsObject['cmsContentID'] = this.cmsContentID;  
            }
            
            this.productListLoading = true;
            this.publicService.doAction('getProductsByCategoryOrContentID', this.argumentsObject).then(result => {
                this.productList = result.productList;
                this.productListLoading = false;
            })
        })
    }
}

export {  MonatProductListingController };