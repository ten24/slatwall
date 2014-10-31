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

	property name="commentDAO" type="any";
	
	property name="orderService" type="any";
	
	public void function parseCommentAndCreateRelationships(required any comment) {
		
		var accptablePreHashKeyEntityList = "order";
		var wordArray = listToArray(arguments.comment.getComment(), " ");
		
		for(var i=2; i<=arrayLen(wordArray); i++) {
			
			var expressionStart = i-1;
			var expressionEnd = i;
			
			if( left(wordArray[expressionEnd], 1) == "##" && listFindNoCase(accptablePreHashKeyEntityList, wordArray[expressionStart]) ) {
			
				var expressionEntityType = wordArray[expressionStart];
				var expressionValue = right(wordArray[expressionEnd], len(wordArray[expressionEnd]) - 1);
				
				switch(expressionEntityType) {
					case "order" : {
						var order = getOrderService().getOrderByOrderNumber(orderNumber=expressionValue);
						if(!isNull(order)) {
							var newRelationship = this.newCommentRelationship();
							newRelationship.setReferencedRelationshipFlag( true );
							newRelationship.setReferencedExpressionStart( expressionStart );
							newRelationship.setReferencedExpressionEnd( expressionEnd );
							newRelationship.setReferencedExpressionEntity( expressionEntityType );
							newRelationship.setReferencedExpressionProperty( "orderNumber" );
							newRelationship.setReferencedExpressionValue( expressionValue );
							newRelationship.setComment( arguments.comment );
							newRelationship.setOrder( order );
						}
						break;
					}
				}
			}
		}
	}
	
	public string function getCommentWithLinks(required any comment) {
		var returnCommentArray = listToArray(arguments.comment.getComment(), " ");
		
		if(arguments.comment.getCommentRelationshipsCount() gt 1) {
			for(var i=1; i<=arrayLen(arguments.comment.getCommentRelationships()); i++) {
				var relationship = arguments.comment.getCommentRelationships()[i];
				if(relationship.getReferencedRelationshipFlag()) {
					returnCommentArray[ relationship.getReferencedExpressionStart() ] = '<a href="?slatAction=admin:comment.link&entity=#relationship.getReferencedExpressionEntity()#&property=#relationship.getReferencedExpressionProperty()#&value=#relationship.getReferencedExpressionValue()#">' & returnCommentArray[ relationship.getReferencedExpressionStart() ];
					returnCommentArray[ relationship.getReferencedExpressionEnd() ] = returnCommentArray[ relationship.getReferencedExpressionEnd() ]  & '</a>';
				}
			}	
		}
		
		return arrayToList(returnCommentArray, " ");
	}
		
	public boolean function removeAllEntityRelatedComments(required any entity) {
		var properties = arguments.entity.getProperties();
		
		for(var p=1; p<=arrayLen(properties); p++) {
			if(structKeyExists(properties[p], "fieldType") && properties[p].fieldType eq "one-to-many" && structKeyExists(properties[p], "cascade") && properties[p].cascade eq "all-delete-orphan" && structKeyExists(properties[p], "cfc") && getHasPropertyByEntityNameAndPropertyIdentifier('CommentRelationship', properties[p].cfc)) {
				var subItems = arguments.entity.invokeMethod("get#properties[p].name#");
				for(var s=1; s<=arrayLen(subItems); s++) {
					removeAllEntityRelatedComments(subItems[s]);
				}
			}
		}
		
		
		if(getHasPropertyByEntityNameAndPropertyIdentifier('CommentRelationship', arguments.entity.getClassName())) {
			return getCommentDAO().deleteAllRelatedComments(primaryIDPropertyName=arguments.entity.getPrimaryIDPropertyName(), primaryIDValue=arguments.entity.getPrimaryIDValue());	
		}
		return true;
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public array function getRelatedCommentsForEntity( required string primaryIDPropertyName, required string primaryIDValue, boolean publicflag ) {
		return getCommentDAO().getRelatedCommentsForEntity( argumentCollection=arguments );
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	
	public any function saveComment(required any comment, required any data) {
		
		arguments.comment.populate( arguments.data );
		
		parseCommentAndCreateRelationships( arguments.comment );
		
		arguments.comment.validate("save");
		
		// If the object passed validation then call save in the DAO, otherwise set the errors flag
        if(!arguments.comment.hasErrors()) {
            arguments.comment = getHibachiDAO().save(target=arguments.comment);
        }
        
        return arguments.comment;
	}
	
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}

