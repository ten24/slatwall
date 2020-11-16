/// <reference path="../../../typings/tsd.d.ts" />
/// <reference path="../../../typings/hibachiTypescript.d.ts" />
/*collection service is used to maintain the state of the ui*/


class Pagination{

    public pageShow:number=10;
    public currentPage:number = 1;
    public pageStart:number = 0;
    public pageEnd:number = 0;
    public recordsCount:number = 0;
    public limitCountTotal:number = 0; //To be used to update the actual fetchcount instead of default 10
    public totalPages:number = 0;
    public totalPagesArray;
    public selectedPageShowOption;
    public pageShowOptions =  [
        {display:10,value:10},
        {display:20,value:20},
        {display:50,value:50},
        {display:250,value:250},
        {display:"Auto",value:"Auto"}
    ];
    public autoScrollPage = 1;
    public autoScrollDisabled = false;
    public notifyById = true;
    public getCollection;

    //@ngInject
    constructor(
        public observerService,
        private uuid:string
    ){
        this.uuid = uuid;
        this.selectedPageShowOption = this.pageShowOptions[0];
        this.observerService.attach(this.setPageRecordsInfo, 'swPaginationUpdate', this.uuid);
    }

    public getSelectedPageShowOption = () =>{
        return this.selectedPageShowOption;
    };

    public pageShowOptionChanged = (pageShowOption) => {
        this.setPageShow(pageShowOption.value);
        this.currentPage = 1;
        this.notify('swPaginationAction', {type:'setPageShow', payload:this.getPageShow()});
    };

    public getTotalPages=():number =>{
        return this.totalPages;
    };
    public setTotalPages=(totalPages:number):void =>{
        this.totalPages = totalPages;
    };
    public getPageStart=():number =>{
        return this.pageStart;
    };
    public setPageStart=(pageStart:number):void =>{
        this.pageStart = pageStart;
    };
    public getPageEnd=():number =>{
        return this.pageEnd;
    };
    public setPageEnd=(pageEnd:number):void =>{
        this.pageEnd = pageEnd;
    };
    public getRecordsCount=():number =>{
        return this.recordsCount;
    };
    public setRecordsCount=(recordsCount:number):void =>{
        this.recordsCount = recordsCount;
    };
    public getLimitCountTotal=():number =>{
        return this.limitCountTotal;
    };
    public setLimitCountTotal=(limitCountTotal:number):void =>{
        this.limitCountTotal = limitCountTotal;
    };
    public getPageShowOptions=() =>{
        return this.pageShowOptions;
    };
    public setPageShowOptions=(pageShowOptions) =>{
        this.pageShowOptions = pageShowOptions;
    };
    public getPageShow=():number =>{
        return this.pageShow;
    };
    public setPageShow=(pageShow:any):void =>{
        this.pageShow = pageShow;
    };
    public getCurrentPage=():number =>{
        return this.currentPage;
    };
    public setCurrentPage=(currentPage:number):void =>{
        this.currentPage = currentPage;
        //this.observerService.notifyById('swPaginationAction', this.uuid,{action:'pageChange', currentPage});
        this.notify('swPaginationAction', {type:'setCurrentPage', payload:this.getCurrentPage()});
    };
    public previousPage=():void =>{
        if(this.getCurrentPage() == 1) return;
        this.setCurrentPage(this.getCurrentPage() - 1);
    };
    public nextPage=():void =>{
        if(this.getCurrentPage() < this.getTotalPages()){
            this.setCurrentPage(this.getCurrentPage() + 1);
            this.notify('swPaginationAction', {type:'nextPage', payload:this.getCurrentPage()});
        }
    };
    public hasPrevious=():boolean =>{
        //With no actual recordsCount, need to check if previous page exists even if there's no data on current page. This enables user to go back to previous page if no results exist on current page, unloess its the very first page
        return (this.getPageStart() <= 1 && this.getPageEnd() !== 0);
        //this.getPageStart() checks if this isnt the first page itself
        //this.getPageEnd() !== 0 tells us if a previous page exists even if the current page has no records 
    };
    public hasNext=():boolean =>{
        //Same as above hasPrevious: Need to alter this to fetch anyways and then show appropriate message if no data exists on next fetch
        return (this.getPageEnd() === this.getRecordsCount());
    };
    public showPreviousJump=():boolean =>{
        return (angular.isDefined(this.getCurrentPage()) && this.getCurrentPage() > 4 && this.getTotalPages() > 6);
    };
    public showNextJump=():boolean =>{
        return !!(this.getCurrentPage() < this.getTotalPages() - 3 && this.getTotalPages() > 6);
    };
    public previousJump=():void =>{
        this.setCurrentPage(this.currentPage - 3);
    };
    public nextJump=():void =>{
        this.setCurrentPage(this.getCurrentPage() + 3);
    };
    public showPageNumber = (pageNumber:number):boolean =>{
        
        if(this.getCurrentPage() >= this.getTotalPages() - 3){
            if(pageNumber > this.getTotalPages() - 6){
                return true;
            }
        }

        if(this.getCurrentPage() <= 4) {
            if(pageNumber < 6 && pageNumber - this.getCurrentPage() <= 2) { // 
                return true;
            }
        }
        
        if(this.getCurrentPage() >= 5) {
            var bottomRange = this.getCurrentPage() - 2;
            var topRange = this.getCurrentPage() + 2;
            if(pageNumber > bottomRange && pageNumber < topRange ){
                return true;
            }
        }
        return false;
    };
    
    
    
    public setPageRecordsInfo = (collection):void =>{
        //Documentation: Partial transfer of pagination control to front-end. Needs to be further rewritten
        var pageRecordsCount = collection.pageRecordsCount,//actual results obtained - defaults to limit 10 unless otherwise specified by pageRecordsShow
        pageRecordsShow = collection.pageRecordsShow,
        recordsCount = collection.recordsCount, //arbitary fetch of recordsCount to get total records in db
        pageRecordsEnd = collection.pageRecordsEnd,
        limitCountTotal = collection.limitCountTotal;
        this.setLimitCountTotal(limitCountTotal);
        //Again, using the limitCountTotal to retain old functionality to work as before
        if(limitCountTotal === 0){
            this.setRecordsCount(recordsCount);
            this.setPageEnd(pageRecordsCount);
        }else{
            if ((pageRecordsCount < recordsCount) && (pageRecordsCount < pageRecordsShow)){
                    this.setPageEnd(pageRecordsCount);
            }else{
                    this.setPageEnd(pageRecordsEnd);
            }
            this.setRecordsCount((pageRecordsCount < pageRecordsShow) ? pageRecordsCount: recordsCount);
        }
        if(this.getRecordsCount() === 0 ){
            this.setPageStart(0);
        } else{
            this.setPageStart(collection.pageRecordsStart);
        }
        this.setTotalPages(collection.totalPages);
        this.currentPage=collection.currentPage;
        this.totalPagesArray = [];

        if(angular.isUndefined(this.getCurrentPage()) || this.getCurrentPage() < 5){
            var start = 1;
                var end = (this.getTotalPages() <= 10) ? this.getTotalPages()+1 : 10;
        }else{
            var start = (!this.showNextJump()) ? this.getTotalPages() - 4 :this.getCurrentPage() - 3;
            var end = (this.showNextJump()) ? this.getCurrentPage() + 5 : this.getTotalPages() + 1;
        }
        for(var i = start; i < end; i++){
            this.totalPagesArray.push(i);
        } 
    };

    public notify(event, parameters){
        if(this.notifyById === true){
            this.observerService.notifyById(event, this.uuid, parameters);
        }else{
            this.observerService.notify(event, parameters);
        }
    }


}

interface IPaginationService{
    createPagination(uuid?:string):Pagination;
    getPagination(uuid:string):Pagination;
}

class PaginationService implements IPaginationService{
    

    private paginations = {};
    //@ngInject
    constructor(
        private utilityService,
        public observerService
    ){

    }

    public createPagination = (id):Pagination =>{
        var uuid = this.utilityService.createID(10);
        if(angular.isDefined(id)){
            uuid = id;
        }
        this.paginations[uuid] = new Pagination(this.observerService,uuid);
        return this.paginations[uuid];
    };

    public getPagination=(uuid:string):Pagination =>{
        if(!uuid) return;
        return this.paginations[uuid];
    };
}
export{
    PaginationService,
    Pagination,
    IPaginationService
}