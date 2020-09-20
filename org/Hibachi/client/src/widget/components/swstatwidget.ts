/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWStatWidgetController{
    constructor(
	    public $scope,
        public $http,
        public $hibachi,
    ){
		// console.log('hi')
		// let data = {
		// 	slatAction: 'admin:report.default',
		// 	reportDateTimeGroupBy: "hello there"
		// };
		
  //      $http({
  //  		url: "http://slatwalldevelop.local:8906/",
  //  		method: "POST",
		// 	data: data,
		// 	headers: {
		// 		"Content-Type": "JSON",
		// 		"X-Hibachi-AJAX": true,
		// 	}
			
		// }).then(function successCallback(response) {
		//         // this callback will be called asynchronously
		//         // when the response is available
		//         console.log(response);
		//     }, function errorCallback(response) {
		//         // called asynchronously if an error occurs
		//         // or server returns response with an error status.
		//         console.log(response);
		// });
    }
}

class SWStatWidget implements ng.IDirective {
	public restrict = "E";
	public controller = SWStatWidgetController;
	public templateUrl;
	public controllerAs = "swStatWidget";
	public scope = {};
	public bindToController = {
			propertyDisplay : "=?",
            propertyIdentifier: "@?",
            name : "@?",
            class: "@?",
            errorClass: "@?",
            type: "@?",
            title: "@?",
            metric: "@?",
            imgSrc: "@?",
            imgAlt: "@?",
            footerClass: "@?"
	};
	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, transcludeFn:ng.ITranscludeFunction) =>{

	}



	/**
		* Handles injecting the partials path into this class
		*/
	public static Factory(){
		var directive = (
		 	widgetPartialPath,
				hibachiPathBuilder
		)=>new SWStatWidget(
			widgetPartialPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'widgetPartialPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor (
		widgetPartialPath,
		hibachiPathBuilder
	) {
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(widgetPartialPath)+ 'statwidget.html';
	}
}

export{
	SWStatWidget
}
