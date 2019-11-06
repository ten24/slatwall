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
    public productList:any;
    public argumentsObject:any;
    public beginPaginationAt:number;
    public displayPages:any;
    public elipsesNum;
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
        this.totalPages = Math.ceil(this.recordsCount / this.itemsPerPage);
        const holdingArray = [];
        const holdingDisplayPagesArray = [];

        for(var i = 0; i <= this.totalPages -1; i++){
            holdingArray.push(i);
            if(i <= this.elipsesNum){
                holdingDisplayPagesArray.push(i);
            }
        }
        this.displayPages = holdingDisplayPagesArray;
        this.totalPageArray = holdingArray;
	}
	
    public getNextPage = ( pageNumber = 1, direction:any = false, newPages = false) => {
		let setNew;
		
		if (pageNumber === 1) {
			setNew = true;
		}
		
        //direction logic
        if(direction === 'prev'){
			setNew = false;
            if(this.pageTracker === 1){
                return pageNumber;
            }else if(this.pageTracker == this.displayPages[0]) {
                newPages = true;
            }
            else{
                pageNumber = this.pageTracker -1;
            }
        }else if(direction === 'next'){
            if(this.pageTracker >= this.totalPages.length){
                pageNumber = this.totalPages.length;
                return pageNumber;
            }else{
                pageNumber = this.pageTracker +1;
            }
        }
        //END: direction logic

        //Ellipses Logic
		if (newPages) {
		    debugger;
			pageNumber = (direction == 'prev') ? this.pageTracker -1 : this.displayPages.length;
			let manipulatePageNumber = pageNumber;
			this.displayPages = [];
			for(let i = 0; ; i++){
			   if( i >= this.elipsesNum || manipulatePageNumber >= this.totalPageArray.length){ break; }
			   if(direction == 'prev'){
			      this.displayPages.unshift(manipulatePageNumber--); 
			   }else{
			       this.displayPages.push(manipulatePageNumber++);
			   }
			}
			console.log(this.displayPages);
		}
        //END: Ellipses Logic

        this.argumentsObject['pageRecordsShow'] = this.itemsPerPage;
        this.argumentsObject['currentPage'] = pageNumber;
        
        return this.publicService.doAction(this.action, this.argumentsObject).then(result=>{
            this.productList = result.productList;
            this.pageTracker = pageNumber;
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
		productList:'=', //Sets up two way binding so concurrent API responses overwrite it
		argumentsObject:'<?', //optional object of arguments to pass in to the api call
		beginPaginationAt:'@?' //this can be left blank unless the user wants the "..." pagination to begin at a number other than 11
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
