/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWColumnSorter{
	
	public template = require("./columnsorter.html");
	public restrict = 'AE';
	public scope ={
		column:"=",
	};
	
	
	public static Factory(){
		return /** @ngInject; */ (observerService) => new this(observerService);
	}
	
    //@ngInject
	public constructor(private observerService){}
	
	public link : ng.IDirectiveLinkFn = (scope, element,attrs) => {
        var orderBy:any = {
            "propertyIdentifier": scope.column.propertyIdentifier,
        }

        scope.sortAsc = () => {
            orderBy.direction = 'Asc';
            this.observerService.notify('sortByColumn',orderBy);
        }
        
        scope.sortDesc = () => {
            orderBy.direction = 'Desc';
            this.observerService.notify('sortByColumn',orderBy);
        }
	}
}

export{
	SWColumnSorter
}
