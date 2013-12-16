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
	
	
	public any function getEventRegistrationByOrderItem(required orderItem) {
		var smartList = this.getEventRegistrationSmartList();
		smartlist.addFilter("orderItem",arguments.orderItem);
		if(smartlist.getRecordsCount() > 0) {
			return smartlist.getRecords()[1].getOrderItem();
		} else {
			return "";
		}
	}
	
	public any function getEventRegistrations(string orderItemIDList="") {
		var smartList = this.getEventRegistrationSmartList();			
		smartList.joinRelatedProperty("SlatwallEventRegistration", "orderItem", "left", true) ;
		smartList.joinRelatedProperty("SlatwallOrderItem", "sku", "left", true) ;
		if(len(arguments.orderItemIDList)) {
			smartList.addInFilter('orderItem.orderItemID', '#arguments.orderItemIDList#');
		}
		//smartList.addOrder("orderitem.sku.skuCode|ASC");
		return smartList;
	}

	public any function getEventRegistrationSmartList(struct data={},orderBySkuCode=true) {
		arguments.entityName = "SlatwallEventRegistration";
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		if(arguments.orderBySkuCode) {
			smartList.addOrder("orderitem.sku.skuCode|ASC");
		}
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
	
	public any function processEventRegistration_approved(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstApproved") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_attended(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstAttended") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_registered(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstRegistered") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_waitlisted(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstWaitListed") );
		
		return arguments.eventRegistration;
	
	}
	
	public any function processEventRegistration_pending(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstPending") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_notplaced(required any eventRegistration, struct data={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstNotPlaced") );
		
		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_cancelled(required any eventRegistration, struct data={}) {
		
		// Change the status
		var regStatus = arguments.eventRegistration.geteventRegistrationStatusType().getSystemCode();
		//if(!)
		// Reduce the quantity of the original orderItem
		var newQuantity = arguments.eventRegistration.getOrderItem().getQuantity() - 1;
		var order = arguments.eventRegistration.getOrderItem().getOrder();
		arguments.eventRegistration.getOrderItem().setQuantity(newQuantity);
		
		// TODO: Add option in admin to refund credit for cancelation
		
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.data, "comment") && len(trim(arguments.data.comment))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.data);
		}
		
		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getSettingService().getTypeBySystemCode("erstCancelled") );
		// TODO Check for waitlisted registrants and change their registration type to "Pending Claim"
		 
		return arguments.eventRegistration;
		
	}

	// @hint Updates the eventRegistrationStatusType of a registrant
	public any function updateRegistrationStatus(required any eventRegistration, required any newEventRegistrationStatusType) {
		
		// Get the original eventRegistration status code
		var originalEventRegistrationStatus = arguments.eventRegistration.geteventRegistrationStatusType().getSystemCode();
		
		if(newEventRegistrationStatusType.geteventRegistrationStatusType().getSystemCode() == "erstCancelled") {
			flagNextWaitlistRegistrant(arguments.eventRegistration.getOrderItem().getSku());
		}
		
		// Save new code
		arguments.eventRegistration.seteventRegistrationStatusType( newEventRegistrationStatusType );
		
		return arguments.eventRegistration;
	}
	
	// @hint Changes next waitlisted registrant to pending claim for specified sku 
	public any function flagNextWaitlistRegistrant(required any sku) {
		var smartlist = getEventRegistrationSmartList({},false);
		smartList.joinRelatedProperty("SlatwallEventRegistration", "orderItem", "left", true) ;
		smartList.joinRelatedProperty("SlatwallOrderItem", "sku", "left", true) ;
		smartList.addInFilter('orderItem.sku.skuID', '#arguments.sku.getSkuID()#');
		smartList.addOrder("waitlistQueueDateTime|ASC");
		var registrants = smartlist.getRecords();
		for(registrant in registrants) {
			if(registrant.getEventRegistrationStatusType().getSystemCode() == "erstWaitListed") {
				registrant.setRegistrationStatusType(getSettingService().getTypeBySystemCode("erstPendingClaim"));
				registrant.save();
				break;
			}
		}
	}
	
	// @hint looks at all pending claims to see if they've expired
	public any function checkPendingClaims() {
		// Get list of all pending claims
		var pendingClaimSmartList = getEventRegistrationSmartList();
		pendingClaimSmartList.joinRelatedProperty("SlatwallType", "eventRegistrationStatusType", "left", true) ;
		pendingClaimSmartList.addFilter("eventRegistrationStatusType.typeID","#getSettingService().getTypeBySystemCode('erstPendingClaim')#");
	}
	
	// @hint Sets a 'pending claim' event registration back to waitlist and places at end of queue 
	public any function expirePendingClaim(required any eventRegistration) {
		arguments.eventRegistration.setWaitlistQueueDateTime(createODBCDateTime(now()));
		arguments.eventRegistration.save();
		flagNextWaitlistRegistrant(eventRegistration.getOrderItem().getSku());
	}
	
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

