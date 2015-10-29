module slatwalladmin { 
	'use strict'; 
	
	export class swGiftCardOverviewController { 
		
		public giftCard
		
		constructor(){ 
			
		}		
	}
	
	export class GiftCardOverview implements ng.IDirective { 
		
		public static $inject = ["partialsPath"];
		
		public restrict:string; 
		public templateUrl:string;
		public scope = {}; 
		public bindToController = {
			giftCard:"=?"
		}; 
		public controller = swGiftCardOverviewController; 
		public controllerAs = "swGiftCardOverview"
			
		constructor(private partialsPath){ 
			this.templateUrl = partialsPath + "/entity/giftcard/overview.html";
			this.restrict = "EA";	
		}
		
	}
	
	angular.module('slatwalladmin')
	.directive('swGiftCardOverview',["partialsPath", 
		(partialsPath) => 
			new GiftCardOverview(partialsPath)
	])
	.controller('MyController', ['$scope', function ($scope) {
        $scope.textToCopy = 'I can copy by clicking!';
 
        $scope.success = function () {
            console.log('Copied!');
        };
 
        $scope.fail = function (err) {
            console.error('Error!', err);
        };
    }]);
}
