class SWDatePicker {
	public _timeoutPromise;
	public restrict = 'A';
	public require = 'ngModel';
	public scope = {
		options: '<?',
		startDayOfTheMonth: '<?',
		endDayOfTheMonth: '<?',
		startDate: '=?',
		startDateString: '@?',
		endDate: '=?',
		endDateString: '@?',
	};

    // @ngInject;
	constructor() {}

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

		if (!$scope.startDayOfTheMonth) {
			$scope.startDayOfTheMonth = 1;
		}

		if (!$scope.endDayOfTheMonth) {
			$scope.endDayOfTheMonth = 31;
		}

		if ($scope.startDateString) {
			$scope.startDate = Date.parse($scope.startDateString).getTime();
		}

		if ($scope.endDateString) {
			$scope.endDate = Date.parse($scope.endDateString).getTime();
		}

		if (!$scope.startDate) {
			$scope.startDate = Date.now();
		}

		if (typeof $scope.startDate !== 'number') {
			$scope.startDate = $scope.startDate.getTime();
		}

		if ($scope.endDate && typeof $scope.endDate !== 'number') {
			$scope.endDate = $scope.endDate.getTime();
		}

		if (!$scope.endDate) {
			$scope.options.beforeShowDay = function(date) {
				var dayOfMonth = date.getDate();
				var dateToCompare = date;
				if (typeof dateToCompare !== 'number') {
					dateToCompare = dateToCompare.getTime();
				}

				return [
					dayOfMonth >= $scope.startDayOfTheMonth &&
						dayOfMonth <= $scope.endDayOfTheMonth &&
						dateToCompare >= $scope.startDate,
				];
			};
		} else {
			$scope.options.beforeShowDay = function(date) {
				var dayOfMonth = date.getDate();
				var dateToCompare = date;
				if (typeof dateToCompare !== 'number') {
					dateToCompare = dateToCompare.getTime();
				}

				return [
					dayOfMonth >= $scope.startDayOfTheMonth &&
						dayOfMonth <= $scope.endDayOfTheMonth &&
						dateToCompare >= $scope.startDate &&
						dateToCompare < $scope.endDate,
				];
			};
		}

		$(element).datepicker($scope.options);
		console.log($scope);
	};

	public static Factory() {
		return /** @ngInject; */ () => new SWDatePicker();

	}
}

export { SWDatePicker };
