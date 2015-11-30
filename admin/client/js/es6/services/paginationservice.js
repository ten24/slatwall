/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
/*collection service is used to maintain the state of the ui*/
var slatwalladmin;
(function (slatwalladmin) {
    class Pagination {
        constructor(uuid) {
            this.uuid = uuid;
            this.pageShow = 10;
            this.currentPage = 1;
            this.pageStart = 0;
            this.pageEnd = 0;
            this.recordsCount = 0;
            this.totalPages = 0;
            this.pageShowOptions = [
                { display: 10, value: 10 },
                { display: 20, value: 20 },
                { display: 50, value: 50 },
                { display: 250, value: 250 },
                { display: "Auto", value: "Auto" }
            ];
            this.autoScrollPage = 1;
            this.autoScrollDisabled = false;
            this.getSelectedPageShowOption = () => {
                return this.selectedPageShowOption;
            };
            this.pageShowOptionChanged = (pageShowOption) => {
                this.setPageShow(pageShowOption.value);
                this.setCurrentPage(1);
            };
            this.getTotalPages = () => {
                return this.totalPages;
            };
            this.setTotalPages = (totalPages) => {
                this.totalPages = totalPages;
            };
            this.getPageStart = () => {
                return this.pageStart;
            };
            this.setPageStart = (pageStart) => {
                this.pageStart = pageStart;
            };
            this.getPageEnd = () => {
                return this.pageEnd;
            };
            this.setPageEnd = (pageEnd) => {
                this.pageEnd = pageEnd;
            };
            this.getRecordsCount = () => {
                return this.recordsCount;
            };
            this.setRecordsCount = (recordsCount) => {
                this.recordsCount = recordsCount;
            };
            this.getPageShowOptions = () => {
                return this.pageShowOptions;
            };
            this.setPageShowOptions = (pageShowOptions) => {
                this.pageShowOptions = pageShowOptions;
            };
            this.getPageShow = () => {
                return this.pageShow;
            };
            this.setPageShow = (pageShow) => {
                this.pageShow = pageShow;
            };
            this.getCurrentPage = () => {
                return this.currentPage;
            };
            this.setCurrentPage = (currentPage) => {
                this.currentPage = currentPage;
                this.getCollection();
            };
            this.previousPage = () => {
                if (this.getCurrentPage() == 1)
                    return;
                this.setCurrentPage(this.getCurrentPage() - 1);
            };
            this.nextPage = () => {
                if (this.getCurrentPage() < this.getTotalPages()) {
                    this.currentPage = this.getCurrentPage() + 1;
                    this.getCollection();
                }
            };
            this.hasPrevious = () => {
                return (this.getPageStart() <= 1);
            };
            this.hasNext = () => {
                return (this.getPageEnd() === this.getRecordsCount());
            };
            this.showPreviousJump = () => {
                return (angular.isDefined(this.getCurrentPage()) && this.getCurrentPage() > 3);
            };
            this.showNextJump = () => {
                return !!(this.getCurrentPage() < this.getTotalPages() - 3 && this.getTotalPages() > 6);
            };
            this.previousJump = () => {
                this.setCurrentPage(this.currentPage - 3);
            };
            this.nextJump = () => {
                this.setCurrentPage(this.getCurrentPage() + 3);
            };
            this.showPageNumber = (pageNumber) => {
                if (this.getCurrentPage() >= this.getTotalPages() - 3) {
                    if (pageNumber > this.getTotalPages() - 6) {
                        return true;
                    }
                }
                if (this.getCurrentPage() <= 3) {
                    if (pageNumber < 6) {
                        return true;
                    }
                }
                else {
                    var bottomRange = this.getCurrentPage() - 2;
                    var topRange = this.getCurrentPage() + 2;
                    if (pageNumber > bottomRange && pageNumber < topRange) {
                        return true;
                    }
                }
                return false;
            };
            this.setPageRecordsInfo = (collection) => {
                this.setRecordsCount(collection.recordsCount);
                if (this.getRecordsCount() === 0) {
                    this.setPageStart(0);
                }
                else {
                    this.setPageStart(collection.pageRecordsStart);
                }
                this.setPageEnd(collection.pageRecordsEnd);
                this.setTotalPages(collection.totalPages);
                this.totalPagesArray = [];
                if (angular.isUndefined(this.getCurrentPage()) || this.getCurrentPage() < 5) {
                    var start = 1;
                    var end = (this.getTotalPages() <= 10) ? this.getTotalPages() + 1 : 10;
                }
                else {
                    var start = (!this.showNextJump()) ? this.getTotalPages() - 4 : this.getCurrentPage() - 3;
                    var end = (this.showNextJump()) ? this.getCurrentPage() + 5 : this.getTotalPages() + 1;
                }
                for (var i = start; i < end; i++) {
                    this.totalPagesArray.push(i);
                }
            };
            this.uuid = uuid;
            this.selectedPageShowOption = this.pageShowOptions[0];
        }
    }
    Pagination.$inject = [];
    slatwalladmin.Pagination = Pagination;
    class PaginationService extends slatwalladmin.BaseService {
        constructor(utilityService) {
            super();
            this.utilityService = utilityService;
            this.paginations = {};
            this.createPagination = () => {
                var uuid = this.utilityService.createID(10);
                this.paginations[uuid] = new Pagination(uuid);
                return this.paginations[uuid];
            };
            this.getPagination = (uuid) => {
                if (!uuid)
                    return;
                return this.paginations[uuid];
            };
        }
    }
    PaginationService.$inject = [
        'utilityService'
    ];
    slatwalladmin.PaginationService = PaginationService;
    angular.module('slatwalladmin').service('paginationService', PaginationService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/paginationservice.js.map