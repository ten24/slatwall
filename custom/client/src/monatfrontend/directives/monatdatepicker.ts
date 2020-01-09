class MonatDatePicker {
	public _timeoutPromise;
	public restrict = 'A';
	public require = 'ngModel';

	public scope = {
		options: '<?',
		startDate: '=?',
		endDate: '=?',
		maxDate:'=?',
		minDate:'=?'
	};

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
				maxDate :'+15 d'
			};
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

		if ($scope.endDateString) {
			$scope.endDate = Date.parse($scope.endDateString);
		}

		if (!$scope.startDate) {
			$scope.startDate = Date.now();
		}

		$(element).datepicker($scope.options);
		console.log($scope);
	};

	public static Factory() {
		var directive = () => new MonatDatePicker();
		directive.$inject = [];
		return directive;
	}
}

export { MonatDatePicker };
