/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
/*collection service is used to maintain the state of the ui*/
module slatwalladmin{
   
    
    export class Pagination{
      
        public pageShow:number=10;
        public currentPage:number = 1;
        public pageStart:number = 0;
        public pageEnd:number = 0;
        public recordsCount:number = 0;
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
        public getCollection;
        
        public static $inject = [
        ]; 
        constructor(
            private uuid:string
        ){
            this.uuid = uuid;
            this.selectedPageShowOption = this.pageShowOptions[0];
        }  
            
        public getSelectedPageShowOption = () =>{
            return this.selectedPageShowOption;   
        }
        
        public pageShowOptionChanged = (pageShowOption) => {
        	this.setPageShow(pageShowOption.value);
        	this.setCurrentPage(1);
            this.getCollection();
        }
        
        public getTotalPages=():number =>{
            return this.totalPages;
        }
        public setTotalPages=(totalPages:number):void =>{
            this.totalPages = totalPages;
        }
        public getPageStart=():number =>{
            return this.pageStart;
        }
        public setPageStart=(pageStart:number):void =>{
            this.pageStart = pageStart;
        }
        public getPageEnd=():number =>{
            return this.pageEnd;
        }
        public setPageEnd=(pageEnd:number):void =>{
            this.pageEnd = pageEnd;
        }
        public getRecordsCount=():number =>{
            return this.recordsCount;
        }
        public setRecordsCount=(recordsCount:number):void =>{
            this.recordsCount = recordsCount;
        }
        public getPageShowOptions=() =>{
            return this.pageShowOptions;
        }
        public setPageShowOptions=(pageShowOptions) =>{
            this.pageShowOptions = pageShowOptions;
        }
        public getPageShow=():number =>{
            return this.pageShow;
        }
        public setPageShow=(pageShow:any):void =>{
            this.pageShow = pageShow;
        }
        public getCurrentPage=():number =>{
            return this.currentPage;
        }
        public setCurrentPage=(currentPage:number):void =>{
            this.currentPage = currentPage;
            this.getCollection();
        }
        public previousPage=():void =>{
            if(!this.hasPrevious()){
                this.currentPage = this.getCurrentPage() - 1;
            }
            this.getCollection();
        }
        public nextPage=():void =>{
            if(!this.hasNext()){
                this.currentPage = this.getCurrentPage() + 1;
            }
            this.getCollection();
        }
        public hasPrevious=():boolean =>{
            return !!(this.getPageStart() <= 1);
        }
        public hasNext=():boolean =>{
            return !!(this.getPageEnd() === this.getRecordsCount());
        }
        public showPreviousJump=():boolean =>{
        	if(angular.isDefined(this.getCurrentPage()) && this.getCurrentPage() > 3){
    			this.totalPagesArray = [];
        		for(var i = 0; i < this.getTotalPages(); i++){
        			if(this.getCurrentPage() < 7 && this.getCurrentPage() > 3 ){
        				if(i !== 0){
        					this.totalPagesArray.push(i+1);
        				}
        			} else {
        				this.totalPagesArray.push(i+1);
        			}
        		}
    			return true;
    		}else{
    			return false;
    		}
        }
        public showNextJump=():boolean =>{
            return !!(
                this.getCurrentPage() < this.getTotalPages() - 3
                && this.getTotalPages() > 6
            );
        }
        public previousJump=():void =>{
            this.setCurrentPage(this.currentPage - 3);
        }
        public nextJump=():void =>{
            this.setCurrentPage(this.getCurrentPage() + 3);
        }
        public showPageNumber = (pageNumber:number):boolean =>{
            if(this.getCurrentPage() >= this.getTotalPages() - 3){
                if(pageNumber > this.getTotalPages() - 6){
                    return true;
                }
            }
            
            if(this.getCurrentPage() <= 3){
                if(pageNumber < 6){
                    return true;
                }
            }else{
                var bottomRange = this.getCurrentPage() - 2;
                var topRange = this.getCurrentPage() + 2;
                if(pageNumber > bottomRange && pageNumber < topRange ){
                    return true;
                }
            }
            return false;
        }
        public setPageRecordsInfo = (recordsCount:number,pageStart:number,pageEnd:number,totalPages:number):void =>{
            this.setRecordsCount(recordsCount);
            if(this.getRecordsCount() === 0 ){
                this.setPageStart(0); 
            } else{
                this.setPageStart(pageStart);
            }
            this.setPageEnd(pageEnd);
            this.setTotalPages(totalPages);
            
            this.totalPagesArray = [];
            for(var i = 0; i < this.getTotalPages(); i++){
                this.totalPagesArray.push(i+1);
            }
        }
        
        
    }
    
    export class PaginationService extends BaseService{
        public static $inject = [
            'utilityService'
        ]; 
        
        private paginations = {};
        
        constructor(
            private utilityService
        ){
            super();
        }
        
        public createPagination = (collection,getCollection):Pagination =>{
            var uuid= this.utilityService.createID(10);
            this.paginations[uuid] = new Pagination(uuid,collection,getCollection);
            return this.paginations[uuid];
        }
        
        public getPagination=(uuid):Pagination =>{
            if(!uuid) return;
            return this.paginations[uuid];
        }
    }
    angular.module('slatwalladmin').service('paginationService', PaginationService);    
}

