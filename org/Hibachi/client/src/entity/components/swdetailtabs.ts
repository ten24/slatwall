class SWDetailTabs {
	public static Factory() {
		var directive = (
			coreEntityPartialsPath,
			hibachiPathBuilder
		) => new SWDetailTabs(
			coreEntityPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'coreEntityPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	//@ngInject
	constructor(
		coreEntityPartialsPath,
		hibachiPathBuilder
	) {
		return {
			restrict: 'E',
			templateUrl: hibachiPathBuilder.buildPartialsPath(coreEntityPartialsPath) + 'detailtabs.html',
			link: function (scope, element, attr) {

			}
		};
	}
}
export {
	SWDetailTabs
}