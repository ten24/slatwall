/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWHref{
	public static Factory(){
		return () => new SWHref();
	}
	
    // 	@ngInject;
	constructor(

	){
		return {
			restrict: 'A',
			scope:{
				swHref:"@"
			},
			link: function(scope, element,attrs){
				/*convert link to use hashbang*/
				var hrefValue = attrs.swHref;
				hrefValue = '?ng#!'+hrefValue;
				element.attr('href',hrefValue);
			}
		};
	}
}
export{
	SWHref
}

