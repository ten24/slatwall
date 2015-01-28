'use strict';
//Thanks to AdamMettro
angular.module('slatwalladmin')
.directive('swLoading', ['$log','partialsPath',

function ($log,partialsPath) {
    return {
        restrict: 'A',
        transclude:true,
        templateUrl:partialsPath+'loading.html',
        scope:{
        	swLoading:'='
        },
        link: function (scope,attrs,element) {
        }
    };
}]);