class SWFPaginationController {
	public totalPages;
	public pageSize;
    public nextPage;
    public pageTracker:number = 1;
    public pageItems:any;
    public action:string;
    public itemsPerPage:number = 10;
    public recordsCount:number;
    public totalPageArray:Array<any>;
    public recordList:any;
    public argumentsObject:any;
    public beginPaginationAt:number;
    public displayPages:any;
    public elipsesNum;
    public hasNextPageSet:boolean = true;
    
	// @ngInject
	constructor(public observerService, public $scope,public publicService) { 
        this.observerService.attach(this.init,"PromiseComplete"); 
        if(this.beginPaginationAt){
            this.elipsesNum = this.beginPaginationAt;
        }else {
            this.elipsesNum = 10;
        }
	};
	
	public init = () => {
	    this.pageTracker = 1;
        this.totalPages = Math.ceil(this.recordsCount / this.itemsPerPage);
        let holdingArray = [];
        let holdingDisplayPagesArray = [];

        //create two arrays, one for the entire page list, and one for the display (ie: 1-10...)
        for(var i = 1; i <= this.totalPages; i++){
            holdingArray.push(i);
            if(i <= this.elipsesNum){
                holdingDisplayPagesArray.push(i);
            }
        }
        this.displayPages = holdingDisplayPagesArray;
        this.totalPageArray = holdingArray;
	}
	
    public getNextPage = ( pageNumber = 1, direction:any = false, newPages = false) => {
		let newPage = newPages;
		let lastDisplayPage = this.displayPages[this.displayPages.length -1];
		
        //direction logic
        if(direction === 'prev'){
            if(this.pageTracker === 1){ 
                return pageNumber;
            }else if(this.pageTracker == this.displayPages[0]) {
                newPage = true;
                pageNumber = this.pageTracker -1;
            }
            else{
                pageNumber = this.pageTracker -1;
            }
        }else if(direction === 'next'){
            if(this.pageTracker >= lastDisplayPage){
                newPage = true;
            }else{
                pageNumber = this.pageTracker +1;
            }
        }
        //END: direction logic

        //Ellipsis Logic
		if (newPage) {
			pageNumber = (direction == 'prev') ? this.displayPages[0] -1 : lastDisplayPage + 1;
			let manipulatePageNumber = pageNumber;
			this.displayPages = [];
			for(let i = 0; ; i++){
			   if( i >= this.elipsesNum || manipulatePageNumber > this.totalPages){ break; }
			   if(direction == 'prev'){
			      this.displayPages.unshift(manipulatePageNumber--); 
			   }else{
			       this.displayPages.push(manipulatePageNumber++);
			   }
			}
		}
        //END: Ellipsis Logic
        	   
        if(this.displayPages[this.displayPages.length-1] >= this.totalPageArray[this.totalPageArray.length-1]){
           this.hasNextPageSet = false;
        }else{
           this.hasNextPageSet = true;
        }

        this.argumentsObject['pageRecordsShow'] = this.itemsPerPage;
        this.argumentsObject['currentPage'] = pageNumber;
        this.publicService.paginationIsLoading = true;
        
        return this.publicService.doAction(this.action, this.argumentsObject).then(result=>{
            this.recordList = 
                (result.productList) 
                ? result.productList 
                :(result.pageRecords) 
                ? result.pageRecords 
                :result.ordersOnAccount.ordersOnAccount;
            
            this.pageTracker = pageNumber;
            this.publicService.paginationIsLoading = false;
            this.observerService.notify('paginationEvent');
        });
    }

	
}

class SWFPagination {
	public restrict: string = 'E';
	public templateUrl: string;
	public scope: boolean = true;

	public bindToController = {
		recordsCount: '<?', //total amount of records available from getRecordsCount call on backend
		action: '@?', //endpoint to be called
		itemsPerPage:'@?', //Number of items to display in a page
		recordList:'=', //Sets up two way binding so succeeding API responses overwrite the records with updated data
		argumentsObject:'<?', //optional object of arguments to pass in to the api call
		beginPaginationAt:'@?' //this is unneeded unless the user wants the ellipsis to begin following a number other than 11
	};

	public controller = SWFPaginationController;
	public controllerAs = 'paginationController';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/swfpagination.html';
	}
}

export { SWFPaginationController, SWFPagination };
