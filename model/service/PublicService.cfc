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
component extends="HibachiService" accessors="true" output="false" hint="Contains all public but secured API scope process methods"
{
	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="userUtility" type="any";
	property name="paymentService" type="any";
	property name="subscriptionService" type="any";
	variables.publicGetContexts = [];
	variables.publicPostContexts = [];
	variables.publicPutContexts = [];
	
	ArrayAppend(variables.publicGetContexts, {Name="Account", Description="Returns the account associated with the authentication token."});
	ArrayAppend(variables.publicGetContexts, {Name="SubscriptionUsage", Description="Returns the subscription usage associated with the authentication token."});
	ArrayAppend(variables.publicGetContexts, {Name="Order", Description="Returns the order usage associated with the authentication token."});
	
	ArrayAppend(variables.publicPostContexts, {Name="Account", Description="Returns the account associated with the authentication token."});
	ArrayAppend(variables.publicPostContexts, {Name="SubscriptionUsage", Description="Returns the subscription usage associated with the authentication token."});
	ArrayAppend(variables.publicPostContexts, {Name="Order", Description="Returns the order usage associated with the authentication token."});
	
	ArrayAppend(variables.publicPutContexts, {Name="Account", Description="Returns the account associated with the authentication token."});
	ArrayAppend(variables.publicPutContexts, {Name="SubscriptionUsage", Description="Returns the subscription usage associated with the authentication token."});
	ArrayAppend(variables.publicPutContexts, {Name="Order", Description="Returns the order usage associated with the authentication token."});
	
	ArrayAppend(variables.publicPostContexts, {Name="Login", Description="Logs in a user associated with the authentication token."});
	ArrayAppend(variables.publicPostContexts, {Name="Logout", Description="Logs out a user associated with the authentication token."});
	
	/**
	 * Returns a JSON list of all public methods available to this request.
	 */
	any function getPublicGetContexts(struct rc) {
		arguments.rc.apiResponse.content["Response"] = serializeJson(variables.publicGetContexts);
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	any function getPublicPostContexts(struct rc) {
		arguments.rc.apiResponse.content["Response"] = serializeJson(variables.publicPostContexts);
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	any function getPublicPutContexts(struct rc) {
		arguments.rc.apiResponse.content["Response"] = serializeJson(variables.publicPutContexts);
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	
	//GET Methods
	any function getAccount(struct rc){
		var url = "#arguments.rc.$.slatwall.getUrl()#";
		arguments.rc.url = url;
		var query = "#CGI.QUERY_STRING#";
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for GET Account";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	any function getSubscriptionUsage(struct rc){
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for GET Subscription Usage";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	any function getOrder(struct rc){
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for GET Order";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	
	//POST Methods
	any function setAccount(struct rc){
		var url = "#arguments.rc.$.slatwall.getUrl()#";
		arguments.rc.url = url;
		var query = "#CGI.QUERY_STRING#";
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for SET Account";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	any function setSubscriptionUsage(struct rc){
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for SET Subscription Usage";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	any function setOrder(struct rc){
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for SET Order";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	
	//PUT Methods
	any function createAccount(struct rc){
		var url = "#arguments.rc.$.slatwall.getUrl()#";
		arguments.rc.url = url;
		var query = "#CGI.QUERY_STRING#";
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for PUT Account";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	any function createSubscriptionUsage(struct rc){
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for PUT Subscription Usage";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	any function createOrder(struct rc){
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for PUT Order";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}
	
	//OTHER
	any function login(struct rc){
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for Login";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}	
	any function logout(struct rc){
		arguments.rc.apiResponse.content["message"] = "Public Request: Authentication Required for Logout";
		this.setStatusMsg(arguments.rc);
		return arguments.rc;
	}	
	
	any function setStatusMsg(struct rc){
		arguments.rc.headers.contentType = "application/json";
		arguments.rc.apiResponse.content.success = true;
		var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
		response.setStatus(200);
	}
}