module slatwalladmin {
    'use strict';

    interface IRequestConfig {
        url: string;
        method: string;
        data: string;
        headers: Object;
    }

    export class AccountSearch {
        private static injector: ng.auto.IInjectorService;

        constructor(injector: ng.auto.IInjectorService, $scope ){
          $scope.accounts = [];
          $scope.searchText = "";
          AccountSearch.injector = injector;
          AccountSearch.http = http = this.injector.get<ng.IHttpService>('$http');
          AccountSearch.http.get({
            url: '?slatAction=api:main.get&entityName=account',
            method: 'GET',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
          }).success(function(data, status, headers, config) {
            console.log("SEARCH ACCOUNTS");
            console.log(data);
          }).error(function(data, status, headers, config) {
            console.log("SEARCH ACCOUNTS ERRORS");
            console.log(data);
          });
        }

        search(){


        }

        searchFilter(){

        }

    }

    angular.module('slatwalladmin').controller('accountSearch', AccountSearch);
}
