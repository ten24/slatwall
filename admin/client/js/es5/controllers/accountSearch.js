var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var AccountSearch = (function () {
        function AccountSearch(injector, $scope) {
            $scope.accounts = [];
            $scope.searchText = "";
            AccountSearch.injector = injector;
            AccountSearch.http = http = this.injector.get('$http');
            AccountSearch.http.get({
                url: '?slatAction=api:main.get&entityName=account',
                method: 'GET',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            }).success(function (data, status, headers, config) {
                console.log("SEARCH ACCOUNTS");
                console.log(data);
            }).error(function (data, status, headers, config) {
                console.log("SEARCH ACCOUNTS ERRORS");
                console.log(data);
            });
        }
        AccountSearch.prototype.search = function () {
        };
        AccountSearch.prototype.searchFilter = function () {
        };
        return AccountSearch;
    })();
    slatwalladmin.AccountSearch = AccountSearch;
    angular.module('slatwalladmin').controller('accountSearch', AccountSearch);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../controllers/accountSearch.js.map