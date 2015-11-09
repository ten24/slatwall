var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
/*collection service is used to maintain the state of the ui*/
var slatwalladmin;
(function (slatwalladmin) {
    var Pagination = (function () {
        function Pagination(uuid) {
            var _this = this;
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
            this.getSelectedPageShowOption = function () {
                return _this.selectedPageShowOption;
            };
            this.pageShowOptionChanged = function (pageShowOption) {
                _this.setPageShow(pageShowOption.value);
                _this.setCurrentPage(1);
            };
            this.getTotalPages = function () {
                return _this.totalPages;
            };
            this.setTotalPages = function (totalPages) {
                _this.totalPages = totalPages;
            };
            this.getPageStart = function () {
                return _this.pageStart;
            };
            this.setPageStart = function (pageStart) {
                _this.pageStart = pageStart;
            };
            this.getPageEnd = function () {
                return _this.pageEnd;
            };
            this.setPageEnd = function (pageEnd) {
                _this.pageEnd = pageEnd;
            };
            this.getRecordsCount = function () {
                return _this.recordsCount;
            };
            this.setRecordsCount = function (recordsCount) {
                _this.recordsCount = recordsCount;
            };
            this.getPageShowOptions = function () {
                return _this.pageShowOptions;
            };
            this.setPageShowOptions = function (pageShowOptions) {
                _this.pageShowOptions = pageShowOptions;
            };
            this.getPageShow = function () {
                return _this.pageShow;
            };
            this.setPageShow = function (pageShow) {
                _this.pageShow = pageShow;
            };
            this.getCurrentPage = function () {
                return _this.currentPage;
            };
            this.setCurrentPage = function (currentPage) {
                _this.currentPage = currentPage;
                _this.getCollection();
            };
            this.previousPage = function () {
                if (_this.getCurrentPage() == 1)
                    return;
                _this.setCurrentPage(_this.getCurrentPage() - 1);
            };
            this.nextPage = function () {
                if (_this.getCurrentPage() < _this.getTotalPages()) {
                    _this.currentPage = _this.getCurrentPage() + 1;
                    _this.getCollection();
                }
            };
            this.hasPrevious = function () {
                return (_this.getPageStart() <= 1);
            };
            this.hasNext = function () {
                return (_this.getPageEnd() === _this.getRecordsCount());
            };
            this.showPreviousJump = function () {
                return (angular.isDefined(_this.getCurrentPage()) && _this.getCurrentPage() > 3);
            };
            this.showNextJump = function () {
                return !!(_this.getCurrentPage() < _this.getTotalPages() - 3 && _this.getTotalPages() > 6);
            };
            this.previousJump = function () {
                _this.setCurrentPage(_this.currentPage - 3);
            };
            this.nextJump = function () {
                _this.setCurrentPage(_this.getCurrentPage() + 3);
            };
            this.showPageNumber = function (pageNumber) {
                if (_this.getCurrentPage() >= _this.getTotalPages() - 3) {
                    if (pageNumber > _this.getTotalPages() - 6) {
                        return true;
                    }
                }
                if (_this.getCurrentPage() <= 3) {
                    if (pageNumber < 6) {
                        return true;
                    }
                }
                else {
                    var bottomRange = _this.getCurrentPage() - 2;
                    var topRange = _this.getCurrentPage() + 2;
                    if (pageNumber > bottomRange && pageNumber < topRange) {
                        return true;
                    }
                }
                return false;
            };
            this.setPageRecordsInfo = function (collection) {
                _this.setRecordsCount(collection.recordsCount);
                if (_this.getRecordsCount() === 0) {
                    _this.setPageStart(0);
                }
                else {
                    _this.setPageStart(collection.pageRecordsStart);
                }
                _this.setPageEnd(collection.pageRecordsEnd);
                _this.setTotalPages(collection.totalPages);
                _this.totalPagesArray = [];
                if (angular.isUndefined(_this.getCurrentPage()) || _this.getCurrentPage() < 5) {
                    var start = 1;
                    var end = (_this.getTotalPages() <= 10) ? _this.getTotalPages() : 10;
                }
                else {
                    var start = (!_this.showNextJump()) ? _this.getTotalPages() - 4 : _this.getCurrentPage() - 3;
                    var end = (_this.showNextJump()) ? _this.getCurrentPage() + 5 : _this.getTotalPages() + 1;
                }
                for (var i = start; i < end; i++) {
                    _this.totalPagesArray.push(i);
                }
            };
            this.uuid = uuid;
            this.selectedPageShowOption = this.pageShowOptions[0];
        }
        Pagination.$inject = [];
        return Pagination;
    })();
    slatwalladmin.Pagination = Pagination;
    var PaginationService = (function (_super) {
        __extends(PaginationService, _super);
        function PaginationService(utilityService) {
            var _this = this;
            _super.call(this);
            this.utilityService = utilityService;
            this.paginations = {};
            this.createPagination = function () {
                var uuid = _this.utilityService.createID(10);
                _this.paginations[uuid] = new Pagination(uuid);
                return _this.paginations[uuid];
            };
            this.getPagination = function (uuid) {
                if (!uuid)
                    return;
                return _this.paginations[uuid];
            };
        }
        PaginationService.$inject = [
            'utilityService'
        ];
        return PaginationService;
    })(slatwalladmin.BaseService);
    slatwalladmin.PaginationService = PaginationService;
    angular.module('slatwalladmin').service('paginationService', PaginationService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=paginationservice.js.map
