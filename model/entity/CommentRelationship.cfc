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
component displayname="Comment Relationship" entityname="SlatwallCommentRelationship" table="SwCommentRelationship" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="commentService" hb_permission="comment.commentRelationships" {
	
	// Persistent Properties
	property name="commentRelationshipID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="referencedRelationshipFlag" hb_populateEnabled="false" ormtype="boolean" default="false";
	property name="referencedExpressionStart" hb_populateEnabled="false" ormtype="integer";
	property name="referencedExpressionEnd" hb_populateEnabled="false" ormtype="integer";
	property name="referencedExpressionEntity" hb_populateEnabled="false" ormtype="string";
	property name="referencedExpressionProperty" hb_populateEnabled="false" ormtype="string";
	property name="referencedExpressionValue" hb_populateEnabled="false" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="comment" cfc="Comment" fieldtype="many-to-one" fkcolumn="commentID";
	
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="physical" cfc="Physical" fieldtype="many-to-one" fkcolumn="physicalID";
	property name="stockAdjustment" cfc="StockAdjustment" fieldtype="many-to-one" fkcolumn="stockAdjustmentID";
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	
	// Audit Properties
	
	// Non-Persistent Properties
	
	public any function getRelationshipEntity() {
		if(!isNull(getOrder())) {
			return getOrder();
		} else if (!isNull(getStockAdjustment())) {
			return getStockAdjustment();
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Comment (many-to-one)
	public void function setComment(required any comment) {
		variables.comment = arguments.comment;
		if(isNew() or !arguments.comment.hasCommentRelationship( this )) {
			arrayAppend(arguments.comment.getCommentRelationships(), this);
		}
	}
	public void function removeComment(any comment) {
		if(!structKeyExists(arguments, "comment")) {
			arguments.comment = variables.comment;
		}
		var index = arrayFind(arguments.comment.getCommentRelationships(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.comment.getCommentRelationships(), index);
		}
		structDelete(variables, "comment");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
		
	// ===================  END:  ORM Event Hooks  =========================
}
