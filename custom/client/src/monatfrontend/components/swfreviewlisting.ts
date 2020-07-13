class SWFReviewListingController{
    public reviewList:Array<Object>;
    public productReviewCollection:any;
    public productId:string;
    public pageRecordsShow:number;
    public numPages:number;
    public currentPage:number;
    public pageNumberArray:Array<Object>;
    public pageCache:Object={};

    //@ngInject
	constructor( public $hibachi,
				 public $scope,
				 public requestService
	){
		this.pageRecordsShow=5;
		this.getProductReviewCollectionList(true);
		this.currentPage = 1;
	}
	
	public $onInit = () =>{
	}
	
	private getProductReviewCollectionList = (getRecordsCount?:boolean)=>{
		var data = {
			currentPage:this.currentPage,
			pageRecordsShow:this.pageRecordsShow,
			productId:this.productId,
			getRecordsCount:false
		}
		if(getRecordsCount){
			data.getRecordsCount = true;
		}
		this.updatePageRecords(data);
	}
	
	private updatePageRecords = (data:{currentPage,pageRecordsShow,productId,getRecordsCount})=>{
	    if(data.currentPage && this.pageCache[data.currentPage]){
	        this.reviewList = this.pageCache[data.currentPage];
	    }
		var productReviewRequest = this.requestService.newPublicRequest('?slatAction=monat:public.getProductReviews',data);
	    productReviewRequest.promise.then(result=>{
	    	if(result['pageRecords']){
	    		for(let i=0; i<result['pageRecords'].length;i++){
	    		    let review = result['pageRecords'][i];
	    		    let date = new Date(review.createdDateTime);
	    		    review.createdDateTime = date.toDateString();
	    		}
	    		this.reviewList = result['pageRecords'];
	    		if(data.currentPage){
	    		    this.pageCache[data.currentPage] = this.reviewList;
	    		}
	    	}
	    	if(result['recordsCount']){
	    		this.numPages = Math.ceil(result['recordsCount'] / this.pageRecordsShow);
	            this.pageNumberArray = this.getPageNumberArray();
	    	}
	    });
	    this.pageNumberArray = this.getPageNumberArray();
	}
	
	public getPage = (pageNumber:number)=>{
		this.currentPage = pageNumber;
		this.getProductReviewCollectionList();
	}
	
	public nextPage = () =>{
		if(!this.currentPageIsMax()){
			this.currentPage += 1;
			this.getProductReviewCollectionList();
		}
	}
	
	public previousPage = () =>{
		if(!this.currentPageIsMin()){
			this.currentPage -= 1;
			this.getProductReviewCollectionList();
		}
	}
	
	public currentPageIsMax = ()=>{
		return this.currentPage >= this.numPages;
	}
	
	public currentPageIsMin = ()=>{
		return this.currentPage <= 1;
	}
	
	public getWholeStarCount = (rating)=>{
		return Math.floor(rating);
	}
	public getHalfStarCount = (rating):number=>{
		return ((rating % 1) >= .5) ? 1 : 0;
	}
	public getEmptyStarCount = (rating)=>{
	    return Math.floor(5-rating);
	}
	public getPageNumberArray = ()=>{
	    let pageArray = [];
	    let firstLabel = '...';
	    let lastLabel = ''
	    let start = this.currentPage - 3;
	    let end = this.currentPage + 3;
	    while(start < 1){
	        start++;
	        end++;
	        if(firstLabel != '1'){
	            firstLabel = '1';
	        }
	    }
	    if(end < this.numPages){
	        lastLabel = '...';
	    }else{
	        while(end > this.numPages){
	            end--;
	        }
	    }
	    for(let i = start; i <= end; i++){
	        let label = i.toString();
	        if(i == start){
	            label = firstLabel;
	        }
	        if(i == end && lastLabel.length){
	            label = lastLabel;
	        }
	        pageArray.push({name:label,value:i});
	    }
	    return pageArray;
	}
}

class SWFReviewListing {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
	    productId:'@'
	};
	public controller=SWFReviewListingController;
	public controllerAs="swfReviewListing";
	
	public template = require('./reviewlisting.html');

	public static Factory() {
		return () => new this();
	}

}

export {
	SWFReviewListing
};

