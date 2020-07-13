class MonatDatePicker {
	public _timeoutPromise;
	public restrict = 'A';
	public require = 'ngModel';

	public scope = {
		options: '<?',
		startDayOfTheMonth: '<?', // integer value for the first eligible day of every month, will default to 1 if not set
		endDayOfTheMonth: '<?', // integer value for the last eligible day of every month, will default to 31 if not set
		startDate: '=?', //The first eligible date a user can select, bound as a timestamp value ie: 2020-11-01 00:00:00, will default to now() if not set
		maxDate:'=?', //The final eligible date a user can select, bound as a timestamp value ie: 2020-11-01 00:00:00
		dayOffset: '@?' //The amount of days to increase max date, will default to 0 if not set
	};

	constructor() { }

	public link: ng.IDirectiveLinkFn = (
		$scope,
		element: ng.IAugmentedJQuery,
		attrs: ng.IAttributes,
		modelCtrl: ng.INgModelController,
	) => {
		if (!$scope.options) {
			$scope.options = {
				autoclose: true,
				format: 'mm/dd/yyyy',
				setDate: new Date(),
			};
		}

        if($scope.maxDate) {
        	let daysToIncrease = $scope.dayOffset ? +$scope.dayOffset : 0;
            let date = new Date($scope.maxDate);
        	date.setDate(date.getDate()+daysToIncrease);
    		$scope.maxDateAdjusted=new Date(date.getFullYear(), date.getMonth(), date.getDate());
        }
        
		if (!$scope.startDayOfTheMonth) {
			$scope.startDayOfTheMonth = 1;
		}

		if (!$scope.endDayOfTheMonth) {
			$scope.endDayOfTheMonth = 31;
		}

		if ($scope.startDateString) {
			$scope.startDate = Date.parse($scope.startDateString);
		}

		if (!$scope.startDate) {
			$scope.startDate = Date.now();
		}

		$scope.startDateClone = new Date($scope.startDate); //clone it to not affect ng-model
		$scope.options.value = $scope.startDateClone; //setting as initial value
		
		$scope.options.disableDates = function(date) {
			let dayOfMonth = date.getDate();
			let dateToCompare = date;
			
			if (typeof dateToCompare !== 'number') {
				dateToCompare = dateToCompare.getTime();
			}
			
			let condition1 = $scope.endDayOfTheMonth ? dayOfMonth <= $scope.endDayOfTheMonth : true;
			let condition2  = $scope.startDayOfTheMonth ? dayOfMonth >= $scope.startDayOfTheMonth : true;
			let condition3 = $scope.startDateClone ? dateToCompare >= $scope.startDateClone.getTime() : true;
			let condition4 = $scope.maxDateAdjusted ? dateToCompare <= $scope.maxDateAdjusted.getTime() : true;
		
			return (condition1 && condition2 && condition3 && condition4);
		};
	
		$(element).datepicker($scope.options);
	};

	public static Factory() {
		var directive = () => new MonatDatePicker();
		directive.$inject = [];
		return directive;
	}
}

export { MonatDatePicker };
