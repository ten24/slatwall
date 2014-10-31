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
component extends="BaseResource" taffy_uri="/{entityNameOrServiceName}/{idOrFilterOrServiceMethod}/" {

	public any function get(string entityNameOrServiceName="", string idOrFilterOrServiceMethod="") {
		// Make sure this isn't trying to Invoke A service Method
		if( right(arguments.entityNameOrServiceName, 7) == "service") {
			return representationOf( "Directly invoking service methods can only be access with a 'post' method." ).withStatus(405);
		}
		
		var serviceName = getEntityService(arguments.entityNameOrServiceName);
		
		// Are they looking for a list?
		if( isSimpleValue(arguments.idOrFilterOrServiceMethod) && (arguments.idOrFilterOrServiceMethod == "list" || arguments.idOrFilterOrServiceMethod == "smartList")) {
			if(arguments.idOrFilterOrServiceMethod == "list") {
				
				var results = evaluate("getService( serviceName ).list#arguments.entityNameOrServiceName#()");
				return representationOf( results ).withStatus(200);
				
			} else {
				
				var results = {};
				var smartList = evaluate("getService( serviceName ).get#arguments.entityNameOrServiceName#SmartList(data=arguments)");
				
				results.currentPage = smartList.getCurrentPage();
				results.totalPages = smartList.getTotalPages();
				results.pageRecordsStart =  smartList.getPageRecordsStart();
				results.pageRecordsEnd = smartList.getPageRecordsEnd();
				results.recordsCount = smartList.getRecordsCount();
				
				results.pageRecords = smartList.getPageRecords();
				
				return representationOf(results).withStatus(200);
				
			}
		} else {
			
			try {
				var entity = evaluate("getService( serviceName ).get#arguments.entityNameOrServiceName#(arguments.idOrFilterOrServiceMethod)");	
			} catch(any e){
				return representationOf("No entity found with the name of: #arguments.entityNameOrServiceName#").withStatus(404);
			}
			
			if( !isNull(entity) ){
				
				// Check for Property Identifiers List
				if( structKeyExists(arguments, "propertyIdentifiers") ) {
					var results = {};
					for(var i=1; i<=listLen(arguments.propertyIdentifiers); i++) {
						var pid = listGetAt(arguments.propertyIdentifiers, i);
						results[ pid ] = entity.getValueByPropertyIdentifier(pid);
					}
					
					return representationOf(results).withStatus(200);
					
				}
				
				// By Default just return the entity
				return representationOf(entity).withStatus(200);
			}
		}
		
		return representationOf("No #arguments.entityNameOrServiceName# found with ID or Filter: #arguments.idOrFilterOrServiceMethod#").withStatus(404);
	}
	
	public any function put(string entityNameOrServiceName="", string idOrFilterOrServiceMethod="") {
		// Make sure this isn't trying to Invoke A service Method
		if( right(arguments.entityNameOrServiceName, 7) == "service") {
			return representationOf( "Directly invoking service methods can only be access with a 'post' method." ).withStatus(405);
		}
		
		var serviceName = getEntityService(arguments.entityNameOrServiceName);
		try {
			var entity = evaluate("getService( serviceName ).get#arguments.entityNameOrServiceName#(arguments.idOrFilterOrServiceMethod)");	
		} catch(any e){
			return representationOf("No entity found with the name of: #arguments.entityNameOrServiceName#").withStatus(404);
		}
		
		if(!isNull(entity)) {
			entity.populate(arguments);
			return representationOf(entity).withStatus(200);
		} else {
			return representationOf("No #arguments.entityNameOrServiceName# found with ID or Filter: #arguments.idOrFilterOrServiceMethod#").withStatus(404);
		}
	}
	
	public any function post(string entityNameOrServiceName="", string idOrFilterOrServiceMethod="") {
		
		// Invoke A service Method
		if( right(arguments.entityNameOrServiceName, 7) == "service") {
			var args = duplicate(arguments);
			structDelete(args, "entityNameOrServiceName");
			structDelete(args, "idOrFilterOrServiceMethod");
			
			try {
				var service = getService( arguments.entityNameOrServiceName );
			} catch(any e) {
				return representationOf("No Service found with the name: #arguments.entityNameOrServiceName#").withStatus(404);
			}
			
			/*try {*/
				var result = service.invokeMethod(methodName=arguments.idOrFilterOrServiceMethod, methodArguments=args);
				return representationOf( result ).withStatus(200);
	/*		} catch (any e) {
				return representationOf("There was an error in the #arguments.entityNameOrServiceName# invoking the method: #arguments.idOrFilterOrServiceMethod#").withStatus(500);
			}*/
			
		}
		
		// If not a service call then create the new entity
		var serviceName = getEntityService(arguments.entityNameOrServiceName);
		try {
			var entity = evaluate("getService( serviceName ).get#arguments.entityNameOrServiceName#(arguments.idOrFilterOrServiceMethod)");	
		} catch(any e){
			return representationOf("No entity found with the name of: #arguments.entityNameOrServiceName#").withStatus(404);
		}
		
		if(!isNull(entity)) {
			entity.populate(arguments);
			entity = evaluate("getService( serviceName ).save#arguments.entityNameOrServiceName#( entity )");
			return representationOf(entity).withStatus(201);			
		}
		
		return representationOf("No #arguments.entityNameOrServiceName# found with ID or Filter: #arguments.idOrFilterOrServiceMethod#").withStatus(404);
	}
	
	public any function delete(string entityNameOrServiceName="", string idOrFilterOrServiceMethod="") {
		// Make sure this isn't trying to Invoke A service Method
		if( right(arguments.entityNameOrServiceName, 7) == "service") {
			return representationOf( "Directly invoking service methods can only be access with a 'post' method." ).withStatus(405);
		}
		
		var serviceName = getEntityService(arguments.entityNameOrServiceName);
		try {
			var entity = evaluate("getService( serviceName ).get#arguments.entityNameOrServiceName#(arguments.idOrFilterOrServiceMethod)");	
		} catch(any e){
			return representationOf("No entity found with the name of: #arguments.entityNameOrServiceName#").withStatus(404);
		}
		
		if(!isNull(entity)) {
			var deleteResponse = evaluate("getService( serviceName ).delete#arguments.entityNameOrServiceName#( entity )");
			return representationOf( deleteResponse ).withStatus(200);
		}
		
		return representationOf("No #arguments.entityNameOrServiceName# found with ID or Filter: #arguments.idOrFilterOrServiceMethod#").withStatus(404);
	}
	
	
	/********************** PRIVATE HELPER METHODS *************************/
	
	private string function getEntityService(required string entityName) {
		if ( left(arguments.entityName, 7) == "account" ) {
			return "accountService";
				
		} else if ( left(arguments.entityName, 7) == "address" ) {
			return "addressService";
			
		} else if ( left(arguments.entityName, 9) == "attribute" ) {
			return "attributeService";
		
		} else if ( left(arguments.entityName, 5) == "brand" ) {
			return "brandService";

		} else if ( left(arguments.entityName, 11) == "fulfillment" ) {
			return "fulfillmentService";

		} else if ( left(arguments.entityName, 5) == "order" ) {
			return "orderService";
		
		} else if ( left(arguments.entityName, 6) == "option" ) {
			return "optionService";
		
		} else if ( left(arguments.entityName, 7) == "payment" || listFindNoCase("creditCardTransaction", arguments.entityName)  )  {
			return "paymentService";
			
		} else if ( left(arguments.entityName, 7) == "product" ) {
			return "productService";
			
		} else if ( left(arguments.entityName, 9) == "promotion" )  {
			return "promotionService";
			
		} else if ( left(arguments.entityName, 3) == "sku" || listFindNoCase("alternateSkuCode", arguments.entityName) )  {
			return "skuService";
		}
		
		return "baseService";
	}
	
}
