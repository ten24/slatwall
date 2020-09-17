/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.integrationServices.BaseImporterService" persistent="false" accessors="true" output="false"{
	
	property name="integrationService";
	property name="erpOneIntegrationCFC";
	property name="hibachiCacheService";
	
	public any function getIntegration(){
	    if( !structKeyExists( variables, 'integration') ){
	        variables.integration = this.getIntegrationByIntegrationPackage('erpone');
	    }
        return variables.integration;
    }
    
    public any function getGrantToken(){
		if( !this.getHibachiCacheService().hasCachedValue('grantToken') ){
			createAndSetGrantToken();
		}
		return getHibachiCacheService().getCachedValue('grantToken');
    }
    
    public any function getAccessToken(){
		if(!getHibachiCacheService().hasCachedValue('accessToken')){
			createAndSetAccessToken(grantToken);
		}
		return getHibachiCacheService().getCachedValue('accessToken');
    }
    
    public any function createAndSetGrantToken(){
		var httpRequest = this.createHttpRequest('distone/rest/service/authorize/grant');
		// Authentication headers
    	if(!this.setting("devMode")){
    		httpRequest.addParam( type='formfield', name='client', value= this.setting('prodClient'));
    		httpRequest.addParam( type='formfield', name='company', value= this.setting("prodCompany"));
			httpRequest.addParam( type='formfield', name='username', value=this.setting("prodUsername"));
    		httpRequest.addParam( type='formfield', name='password', value=this.setting("prodPassword"));
		}
		else{
			httpRequest.addParam( type='formfield', name='client', value= this.setting('devClient'));
	    	httpRequest.addParam( type='formfield', name='company', value= this.setting("devCompany"));
	    	httpRequest.addParam( type='formfield', name='username', value=this.setting("devUsername"));
	    	httpRequest.addParam( type='formfield', name='password', value=this.setting("devPassword"));
		}
		var rawRequest = httpRequest.send().getPrefix();
		var response = {};
		try{
			if(IsJson(rawRequest.fileContent)) {
			response = DeSerializeJson(rawRequest.fileContent);
			getHibachiCacheService().setCachedValue('grantToken',response.grant_token,DateAdd("n",60,now()));
			this.createAndSetAccessToken();
			} 
		}
		catch ( any e ){
			throw("Invalid Grant Token" & e.Message);
		}
    }
    
    public any function createAndSetAccessToken(){
    	var grantToken = this.getGrantToken();
    	var httpRequest = this.createHttpRequest('distone/rest/service/authorize/access');
		
		// Authentication headers
		if(!this.setting("devMode")){
    		httpRequest.addParam( type='formfield', name='client', value= this.setting('prodClient'));
    		httpRequest.addParam( type='formfield', name='company', value= this.setting("prodCompany"));
    		httpRequest.addParam( type='formfield', name='grant_token', value=grantToken );
		}
		else{
			httpRequest.addParam( type='formfield', name='client', value= this.setting('devClient'));
	    	httpRequest.addParam( type='formfield', name='company', value= this.setting("devCompany"));
	    	httpRequest.addParam( type='formfield', name='grant_token', value=grantToken );
		}
		
		var rawRequest = httpRequest.send().getPrefix();
		var response = {};
		try{
			if( IsJson(rawRequest.fileContent) ) {
			response = DeSerializeJson(rawRequest.fileContent);
			getHibachiCacheService().setCachedValue('accessToken',response.access_token,DateAdd("n",60,now()));
			}
		} 
		catch ( any e ){
			throw("Invalid Grant Token" & e.Message);
		}
    }
    public any function createHttpRequest(required string endPointUrl, string requestType="POST"){
    	if(!this.setting("devMode")){
			var requestURL = this.setting("prodGatewayURL") & arguments.endPointUrl;
		}
		else{
			var requestURL = this.setting("devGatewayURL") & arguments.endPointUrl;
		}
		var httpRequest = new http();
		httpRequest.setMethod(arguments.requestType);
		httpRequest.setCharset("utf-8");
		httpRequest.setUrl(requestURL);
    	httpRequest.addParam( type='header', name='Content-Type', value='application/x-www-form-urlencoded');
    	return httpRequest;
    }
    public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
    	return this.getErpOneIntegrationCFC().setting( argumentCollection=arguments );
	}
}
