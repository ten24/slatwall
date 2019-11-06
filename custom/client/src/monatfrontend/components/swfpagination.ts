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
    
	// @ngInject
	constructor(
		//inject modal service
		public orderTemplateService,
		public monatService,
        public observerService,
        public $scope,
        public publicService
	) { 
        this.observerService.attach(this.init,"PromiseComplete"); 

	}
	
	public init = () => {
        this.totalPages = Math.ceil(this.recordsCount / this.itemsPerPage);
        const holdingArray = [];
        for(var i = 0; i <= this.totalPages -1; i++){
            holdingArray.push(i);
        }
        this.totalPageArray = holdingArray;
	}
	
    public getNextPage = ( pageRecordsShow = 5, pageNumber = 1, direction:any = false) => {

        if(direction === 'prev'){
            if(this.pageTracker === 1){
                return pageNumber;
            }else{
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
        
        return this.publicService.doAction(this.action, {pageRecordsShow: this.itemsPerPage, currentPage: pageNumber}).then(result=>{
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
		recordsCount: '<?',
		action: '@?',
		itemsPerPage:'@?'
		productList:'='
		//create attribute with two way binding for product list
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
