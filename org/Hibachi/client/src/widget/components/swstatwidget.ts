/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWStatWidgetController{
    constructor(

    ){
        this.init();
    }

    public init = () =>{
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
