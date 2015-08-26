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
            };
            this.previousPage = () => {
                if (!this.hasPrevious()) {
                    this.currentPage = this.getCurrentPage() - 1;
                }
            };
            this.nextPage = () => {
                if (!this.hasNext()) {
                    this.currentPage = this.getCurrentPage() + 1;
                }
            };
            this.hasPrevious = () => {
                return !!(this.getPageStart() <= 1);
            };
            this.hasNext = () => {
                return !!(this.getPageEnd() === this.getRecordsCount());
            };
            this.showPreviousJump = () => {
                console.log('shorPrev');
                console.log(this.getCurrentPage());
                if (angular.isDefined(this.getCurrentPage()) && this.getCurrentPage() > 3) {
                    this.totalPagesArray = [];
                    for (var i = 0; i < this.getTotalPages(); i++) {
                        if (this.getCurrentPage() < 7 && this.getCurrentPage() > 3) {
                            if (i !== 0) {
                                this.totalPagesArray.push(i + 1);
                            }
                        }
                        else {
                            this.totalPagesArray.push(i + 1);
                        }
                    }
                    return true;
                }
                else {
                    return false;
                }
            };
            this.showNextJump = () => {
                return !!(this.getCurrentPage() < this.getTotalPages() - 3
                    && this.getTotalPages() > 6);
            };
            this.previousJump = () => {
                this.setCurrentPage(this.currentPage - 3);
                this.currentPage -= 3;
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
            this.setPageRecordsInfo = (recordsCount, pageStart, pageEnd, totalPages) => {
                this.setRecordsCount(recordsCount);
                if (this.getRecordsCount() === 0) {
                    this.setPageStart(0);
                }
                else {
                    this.setPageStart(pageStart);
                }
                this.setPageEnd(pageEnd);
                this.setTotalPages(totalPages);
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