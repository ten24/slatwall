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

	property name="commentService" type="any";
	property name="orderService" type="any";
	property name="settingService" type="any";
	property name="typeService" type="any";


	// ===================== START: Logical Methods ===========================

	// @hint Returns a randomly generated code. Takes a codeLength parm which defaults to 8.
	public string function generateAttendanceCode(required codeLength=8) {
		var lowerAlpha = "abcdefghjkmnpqrtuvwxyz";
		var upperAlpha = UCase( lowerAlpha );
		var numbers = "0123456789";
		//var strOtherChars = "!@##$%&*";
		var validChars = (upperAlpha & numbers);
		var helperArr = [];
		var attendanceCode = "";

		helperArr[ 1 ] = Mid(numbers,randRange( 1, len( numbers ) ),1);
		helperArr[ 2 ] = Mid(lowerAlpha,randRange( 1, len( lowerAlpha ) ),1);
		helperArr[ 3 ] = Mid(upperAlpha,randRange( 1, len( upperAlpha ) ),1);
		for(var i=1; i<=arguments.codeLength; i++){
			helperArr[ i ] = mid(validChars,randRange( 1, len( validChars ) ),1);
		}
		createObject( "java", "java.util.Collections" ).Shuffle(helperArr);
		attendanceCode = arrayToList(helperArr,"");
		return attendanceCode;
	}

	// @hint looks at all pending confirmations to see if they've expired
	public any function getPendingConfirmationsSmartlist() {
		// Get list of all pending confirmations
		var pendingConfirmationsSmartlist = getEventRegistrationSmartList();
		pendingConfirmationsSmartlist.joinRelatedProperty("SlatwallType", "eventRegistrationStatusType", "left", true) ;
		pendingConfirmationsSmartlist.addFilter("eventRegistrationStatusType.typeID","#getTypeService().getTypeBySystemCode('erstPendingConfirmation')#");
		return pendingConfirmationsSmartlist;
	}

	public any function getEventRegistrationByOrderItem(required orderItem) {
		var smartList = this.getEventRegistrationSmartList();
		smartlist.addFilter("orderItem.orderItemID",arguments.orderItem);
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
		return smartList;
	}

	public any function getWaitlistedRegistrants(required any sku) {
		var smartList = this.getEventRegistrationSmartList();
		smartList.joinRelatedProperty("SlatwallEventRegistration", "sku", "left", true) ;
		smartList.addInFilter('sku.skuID', '#arguments.sku.getSkuID()#');
		smartList.addInFilter('eventRegistrationStatusType.typeID', '#getTypeService().getTypeBySystemCode('erstWaitlisted').getTypeID()#');
		smartList.addOrder("waitlistQueueDateTime|ASC");
		return smartList.getRecords();
	}



	// @hint Changes next waitlisted registrant to pending claim for specified sku
	/*public any function notifyNextWaitlistedRegistrants(required any sku, integer quantity=1) {
		var notifiedCount = 0;
		// Retrieve waitlisted event registrations for the sku
		var smartlist = getEventRegistrationSmartList({},false);
		smartList.joinRelatedProperty("SlatwallOrderItem", "sku", "left", true) ;
		smartList.addFilter("skuID", "#arguments.sku.getSkuID()#");
		smartList.addFilter("eventRegistrationStatusTypeID", "#getTypeService().getTypeBySystemCode("erstWaitlisted").getTypeID()#");
		smartList.addOrder("waitlistQueueDateTime|ASC");
		if(smartlist.getRecordsCount()){
			var registrants = smartlist.getRecords();
			for(registrant in registrants) {
					registrant.setRegistrationStatusType(getTypeService().getTypeBySystemCode("erstPendingConfirmation"));
					registrant.save();
					if(notifiedCount==arguments.quantity) {
						break;
					}
			}
		}
	}*/

	public any function getNonWaitlistedCountBySku(required any sku) {
		var smartlist = getEventRegistrationSmartList({},false);
		smartList.joinRelatedProperty("SlatwallEventRegistration", "sku", "left", true) ;
		smartList.addInFilter('sku.skuID', '#arguments.sku.getSkuID()#');
		smartlist.addWhereCondition("aslatwalleventregistration.eventRegistrationStatusType.systemCode <> 'erstWaitlisted'");
		smartlist.addWhereCondition("aslatwalleventregistration.eventRegistrationStatusType.systemCode <> 'erstCancelled'");
		smartlist.addWhereCondition("aslatwalleventregistration.eventRegistrationStatusType.systemCode <> 'erstNotPlaced'");
		
		return smartlist.getRecordsCount();
	}

	public any function getUnavailableSeatCountBySku(required any sku) {
		var smartlist = getEventRegistrationSmartList({},false);
		var cancelledTypeID = getTypeService().getTypeBySystemCode('erstCancelled').getTypeID();
		smartList.joinRelatedProperty("SlatwallEventRegistration", "sku", "left", true) ;
		smartList.addInFilter('sku.skuID', '#arguments.sku.getSkuID()#');
		smartlist.addWhereCondition("aslatwalleventregistration.eventRegistrationStatusType.typeID <> '#cancelledTypeID#'");
		return smartlist.getRecordsCount();
	}

	public any function getAvailableSeatCountBySku(required any sku) {
		return arguments.sku.getEventCapacity() - getNonWaitlistedCountBySku(arguments.sku);
	}

	// @hint Marks eligible waitlisted registrant as pending confirmation
	public void function updateEligibleRegistrants(required any sku) {
		var availableSeatCount = arguments.sku.getAvailableSeatCount();
		var notifiedCount = 0;
		if(availableSeatCount > 0) {
			var waitlistedRegistrants = getWaitlistedRegistrants(arguments.sku);
			for(registrant in waitlistedRegistrants) {
				registrant.setRegistrationStatusType(getTypeService().getTypeBySystemCode("erstPendingConfirmation"));
				registrant.save();
				notifiedCount++;
				if(notifiedCount==availableSeatCount) {
					break;
				}
			}
		}
	}

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public any function updateStockLocation(required string fromLocationID, required string toLocationID) {
		getStockDAO().updateStockLocation( argumentCollection=arguments );
	}

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	public any function processEventRegistration_approve(required any eventRegistration, required any processObject) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.processObject, "comment") && len(trim(arguments.processObject.getComment()))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.processObject);
		}

		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstRegistered") );

		return arguments.eventRegistration;
	}

	public any function processEventRegistration_attend(required any eventRegistration, required any processObject) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.processObject, "comment") && len(trim(arguments.processObject.getComment()))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.processObject);
		}

		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstAttended") );

		return arguments.eventRegistration;
	}

	public any function processEventRegistration_cancel(required any eventRegistration, required any processObject) {
		var createReturnOrder = true;
		if(isDefined("arguments.processObject.getcreateReturnOrderFlag")) {
			createReturnOrder = arguments.processObject.getCreateReturnOrderFlag();
		}
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.processObject, "comment") && len(trim(arguments.processObject.getComment()))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.processObject);
		}
		// Create return order if order is closed
		if(createReturnOrder && arguments.eventRegistration.hasOrderItem()) {
			var processData = structNew();
			// Create order item to give to return process
			var newOrderItem = getService("OrderService").newOrderItem();
			// Inform return process that the registration has already been cancelled
			newOrderItem.cancelRegistrationFlag = false;
			newOrderItem.setPrice(referencedOrderItem.getPrice());
			newOrderItem.setQuantity(1);
			newOrderItem.setReferencedOrderItem(arguments.eventRegistration.getOrderItem());
			processData.orderItems = [newOrderItem];
			getOrderService().processOrder(arguments.eventRegistration.getOrderItem().getOrder(), processData, 'createReturn');
		} else {
			// If order is not closed then subtract order item quantity by 1
			if(arguments.eventRegistration.hasOrderItem()) {
				arguments.eventRegistration.getOrderItem().setQuantity(arguments.eventRegistration.getOrderItem().getQuantity()-1);
			}
		}

		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstCancelled") );
		getService("SkuService").processOrder(arguments.eventRegistration.getSku(), {}, 'notifyWaitlistOpenings');

		return arguments.eventRegistration;
	}


	// @hint Changes event registration status to pending confirmation
	public any function processEventRegistration_confirm(required any eventRegistration, processObject={}) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.processObject, "comment") && len(trim(arguments.processObject.getComment()))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.processObject);
		}
		arguments.eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstPendingConfirmation") );

		return arguments.eventRegistration;
	}


	// @hint Sets a 'pending confirmation' event registration back to waitlist and places at end of queue
	public any function processEventRegistration_expire(required any eventRegistration,processObject={}) {
		arguments.eventRegistration.setWaitlistQueueDateTime(createODBCDateTime(now()));
		arguments.eventRegistration.save();
		processEventRegistration( eventRegistration, {}, "confirm");
	}

	public any function processEventRegistration_pendingApproval(required any eventRegistration, required any processObject) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.processObject, "comment") && len(trim(arguments.processObject.getComment()))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.processObject);
		}

		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstPendingApproval") );

		return arguments.eventRegistration;
	}
	
	public any function processEventRegistration_pendingConfirmation(required any eventRegistration, required any processObject) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.processObject, "comment") && len(trim(arguments.processObject.getComment()))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.processObject);
		}

		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstPendingConfirmation") );

		return arguments.eventRegistration;
	}

	public any function processEventRegistration_register(required any eventRegistration, required any processObject) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.processObject, "comment") && len(trim(arguments.processObject.getComment()))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.processObject);
		}

		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstRegistered") );

		return arguments.eventRegistration;
	}

	public any function processEventRegistration_waitlist(required any eventRegistration, required any processObject) {
		// Set up the comment if someone typed in the box
		if(structKeyExists(arguments.processObject, "comment") && len(trim(arguments.processObject.getComment()))) {
			var comment = getCommentService().newComment();
			comment = getCommentService().saveComment(comment, arguments.processObject);
		}

		// Change the status
		arguments.eventRegistration.seteventRegistrationStatusType( getTypeService().getTypeBySystemCode("erstWaitListed") );

		return arguments.eventRegistration;

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

	public any function getEventRegistrationSmartList(struct data={},orderBySkuCode=true) {
		arguments.entityName = "SlatwallEventRegistration";
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		if(arguments.orderBySkuCode) {
			smartList.addOrder("sku.skuCode|ASC");
		}
		return smartList;
	}

	public any function getRegistrationAttendenceSmartList(struct data={}) {
		var attendanceTypes = [getTypeService().getTypeBySystemCode("erstRegistered").getTypeID(),getSettingService().getTypeBySystemCode("erstAttended").getTypeID()];
		var attendanceTypesList = listQualify(arrayToList(attendanceTypes),"'");
		arguments.entityName = "SlatwallEventRegistration";
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		smartlist.addWhereCondition("eventRegistrationStatusTypeID IN (#attendanceTypesList#)");
		return smartList;
	}

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================
}

