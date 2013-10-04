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
component extends="HibachiService" persistent="false" accessors="true" output="false" {
	
	property name="commentService";
	property name="settingService";
	
	
	public any function getEventRegistrations(string orderItemIDList="") {
		var smartList = this.getEventRegistrationSmartList();
		smartList.joinRelatedProperty("SlatwallEventRegistration", "orderItem", "left", true) ;
		smartList.joinRelatedProperty("SlatwallOrderItem", "sku", "left", true) ;
		if(len(arguments.orderItemIDList)) {
			smartList.addInFilter('orderItem.orderItemID', '#arguments.orderItemIDList#');
		}
		smartList.addOrder("orderitem.sku.skuCode|ASC");
		return smartList;
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public any function updateStockLocation(required string fromLocationID, required string toLocationID) {
		getStockDAO().updateStockLocation( argumentCollection=arguments );
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processEventRegistration_approve(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstApproved") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_attend(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstAttended") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_register(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstRegistered") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_waitlist(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstWaitListed") );
		
		return arguments.eventRegistration;
	
	}
	
	public any function processEventRegistration_pend(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstPending") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_cancel(required any eventRegistration, struct data={}) {
		
		// We need to update the quantity of the original orderItem
		// var newQuantity = arguments.eventRegistration.getOrderItem().getQuantity() - 1
		// arguments.eventRegistration.getOrderItem( newQuantity )
		// We'll prob need to add option in admin to refund credit for cancelation
		
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstCancelled") );
		
		return arguments.eventRegistration;
	}

	
	/*public any function processEventRegistration_updateStatus(required any eventRegistration, struct data) {
		param name="arguments.data.updateItems" default="false";
		
		// Get the original eventRegistration status code
		var originalEventRegistrationStatus = arguments.eventRegistration.geteventRegistrationStatusType().getSystemCode();
		
		// Save new code
		arguments.eventRegistration.seteventRegistrationStatusType(  getSettingService().getTypeBySystemCode(arguments.eventRegistration.getEventRegistrationStatusType().getSystemCode() ) );
		
		return arguments.eventRegistration;
	}*/
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveLocation(required any location, required struct data) {
		
		arguments.location = super.save(arguments.location, arguments.data);
		
		if(!location.hasErrors()){
			
			// We need to persist the state here, so that we can have the locationID in the database
			getHibachiDAO().flushORMSession();
			
			// If this location has any stocks then we need to update them
			if( arrayLen(arguments.location.getStocks()) ) {
				updateStockLocation( fromLocationID=arguments.location.getParentLocation().getlocationID(), toLocationID=arguments.location.getlocationID());
			}
		} 
		
		return arguments.location;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
}

