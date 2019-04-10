
class SWCriteria {
	public static Factory() {
		var directive = (
			collectionPartialsPath,
			hibachiPathBuilder
		) => new SWCriteria(
			collectionPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'collectionPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	//@ngInject
	constructor(
		collectionPartialsPath,
		hibachiPathBuilder
	) {
		return {
			restrict: 'E',
			scope: {
				filterItem: "=",
				selectedFilterProperty: "=",
				filterPropertiesList: "=",
				selectedFilterPropertyChanged: "&",
				comparisonType: "=",
				collectionConfig: "="
			},
			templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criteria.html',
			link: function (scope, element, attrs) {
			}
		};
	}
}
export {
	SWCriteria
}


