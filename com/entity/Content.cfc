/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="Content" entityname="SlatwallContent" table="SlatwallContent" persistent="true" accessors="true" extends="BaseEntity" parentPropertyName="parentContent" {
	
	// Persistent Properties
	property name="contentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="contentIDPath" ormtype="string" length="500";
	property name="activeFlag" ormtype="boolean" default=1;
	
	property name="title" ormtype="string";
	property name="cmsContentID" ormtype="string";
	property name="cmsContentIDPath" ormtype="string" length="500";
	property name="cmsSiteID" ormtype="string";
	
	property name="allowPurchaseFlag" ormtype="boolean";
	property name="disableProductAssignmentFlag" ormtype="boolean";
	property name="templateFlag" ormtype="boolean";
	
	// Related Object Properties (many-to-one)
	property name="parentContent" cfc="Content" fieldtype="many-to-one" fkcolumn="parentContentID";
	
	// Related Object Properties (one-to-many)
	property name="childContents" singularname="childContent" cfc="Content" type="array" fieldtype="one-to-many" fkcolumn="parentContentID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="many-to-many" linktable="SlatwallSkuAccessContent" fkcolumn="contentID" inversejoincolumn="skuID" inverse="true";
	property name="listingProducts" singularname="listingProduct" cfc="Product" type="array" fieldtype="many-to-many" linktable="SlatwallProductListingPage" fkcolumn="contentID" inversejoincolumn="productID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string" hint="Only used when integrated with a remote system";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties



    
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Child Contents (one-to-many)    
	public void function addChildContent(required any childContent) {    
		arguments.childContent.setParentContent( this );    
	}    
	public void function removeChildContent(required any childContent) {    
		arguments.childContent.removeParentContent( this );    
	}
	
	// Parent Content (many-to-one)
	public void function setParentContent(required any parentContent) {
		variables.parentContent = arguments.parentContent;
		if(isNew() or !arguments.parentContent.hasChildContent( this )) {
			arrayAppend(arguments.parentContent.getChildContents(), this);
		}
	}
	public void function removeParentContent(any parentContent) {
		if(!structKeyExists(arguments, "parentContent")) {
			arguments.parentContent = variables.parentContent;
		}
		var index = arrayFind(arguments.parentContent.getChildContents(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.parentContent.getChildContents(), index);
		}
		structDelete(variables, "parentContent");
	}
	
	// Skus (many-to-many - inverse)
	public void function addSku(required any sku) {
		arguments.sku.addAccessContent( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeAccessContent( this );
	}
	
	// Listing Products (many-to-many - inverse)    
	public void function addListingProduct(required any listingProduct) {    
		arguments.listingProduct.addListingPage( this );    
	}    
	public void function removeListingProduct(required any listingProduct) {    
		arguments.listingProduct.removeListingPage( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "title";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		setContentIDPath( buildIDPathList( "parentContent" ) );
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		setContentIDPath( buildIDPathList( "parentContent" ) );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}