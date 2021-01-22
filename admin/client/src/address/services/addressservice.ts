/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
export class AddressService { 


    //@ngInject
    constructor(public $hibachi,
                public requestService
    ){

    }
    
    
    public getStateCodeOptionsByCountryCode = (countryCode:string) => {
    
        var queryString = 'entityName=State&f:countryCode=' + 
	    				   countryCode + 
	    				  '&allRecords=true&propertyIdentifiers=stateCode,stateName';
	    
	    var processUrl = this.$hibachi.buildUrl('api:main.get',queryString);
		
		var adminRequest = this.requestService.newAdminRequest(processUrl);
		
		return adminRequest.promise;
    }
}