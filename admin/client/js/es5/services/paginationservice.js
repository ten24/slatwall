'use strict';
angular.module('slatwalladmin')
    .factory('paginationService', ['utilityService',
    function (utilityService) {
        var paginations = {};
        var paginationService = {
            createPagination: function () {
                var uuid = utilityService.createID(10);
                paginations[uuid] = {
                    _pageShow: 10,
                    _currentPage: 1,
                    _pageStart: 0,
                    _pageEnd: 0,
                    _recordsCount: 0,
                    _totalPages: 0,
                    _pageShowOptions: [
                        { display: 10, value: 10 },
                        { display: 20, value: 20 },
                        { display: 50, value: 50 },
                        { display: 250, value: 250 },
                        { display: "Auto", value: "Auto" }
                    ]
                };
                return uuid;
            },
            getPagination: function (uuid) {
                if (!uuid)
                    return;
                return paginations[uuid];
            },
            getTotalPages: function (uuid) {
                if (!uuid)
                    return;
                return paginations[uuid]._totalPages;
            },
            setTotalPages: function (uuid, totalPages) {
                if (!uuid)
                    return;
                paginations[uuid]._totalPages = totalPages;
            },
            getPageStart: function (uuid) {
                if (!uuid)
                    return;
                return paginations[uuid]._pageStart;
            },
            setPageStart: function (uuid, pageStart) {
                if (!uuid)
                    return;
                paginations[uuid]._pageStart = pageStart;
            },
            getPageEnd: function (uuid) {
                return paginations[uuid]._pageEnd;
            },
            setPageEnd: function (uuid, pageEnd) {
                if (!uuid)
                    return;
                paginations[uuid]._pageEnd = pageEnd;
            },
            getRecordsCount: function (uuid) {
                if (!uuid)
                    return;
                return paginations[uuid]._recordsCount;
            },
            setRecordsCount: function (uuid, recordsCount) {
                if (!uuid)
                    return;
                paginations[uuid]._recordsCount = recordsCount;
            },
            getPageShowOptions: function (uuid) {
                if (!uuid)
                    return;
                return paginations[uuid]._pageShowOptions;
            },
            setPageShowOptions: function (uuid, pageShowOptions) {
                if (!uuid)
                    return;
                paginations[uuid]._pageShowOptions = pageShowOptions;
            },
            getPageShow: function (uuid) {
                if (!uuid)
                    return;
                return paginations[uuid]._pageShow;
            },
            setPageShow: function (uuid, pageShow) {
                if (!uuid)
                    return;
                paginations[uuid]._pageShow = pageShow;
            },
            getCurrentPage: function (uuid) {
                if (!uuid)
                    return;
                return paginations[uuid]._currentPage;
            },
            setCurrentPage: function (uuid, currentPage) {
                if (!uuid)
                    return;
                paginations[uuid]._currentPage = currentPage;
            },
            previousPage: function (uuid) {
                if (uuid && !this.hasPrevious(uuid)) {
                    paginations[uuid]._currentPage = this.getCurrentPage(uuid) - 1;
                }
            },
            nextPage: function (uuid) {
                if (uuid && !this.hasNext(uuid)) {
                    paginations[uuid]._currentPage = this.getCurrentPage(uuid) + 1;
                }
            },
            hasPrevious: function (uuid) {
                return !!(uuid && paginationService.getPageStart(uuid) <= 1);
            },
            hasNext: function (uuid) {
                return !!(uuid && paginationService.getPageEnd(uuid) === paginationService.getRecordsCount(uuid));
            }
        };
        return paginationService;
    }
]);

//# sourceMappingURL=../services/paginationservice.js.map