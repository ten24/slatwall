/*

    Slatwall - An e-commerce plugin for Mura CMS
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
component displayname="Sku Bundle" entityname="SlatwallSkuBundle" table="SwSkuBundle" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="skuService" hb_permission="this" {
	
	// Persistent Properties
	property name="skuBundleID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="bundledQuantity" ormtype="integer";
	property name="sortOrder" ormtype="integer" sortContext="sku";
	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="bundledSku" cfc="Sku" fieldtype="many-to-one" fkcolumn="bundledSkuID";
	property name="measurementUnit" cfc="MeasurementUnit" fieldType="many-to-one" fkcolumn="measurementUnitID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="measurementUnitOptions" persistent="false";

	public numeric function getBundleQATS(string locationID=''){
		
		var locationArray = getService('LocationService').getLocationOptions(arguments.locationID);
		var skuQATS = 0;
		var bundleQATS = 0;
		
		for (var location in locationArray){
			if( !isNull(getBundledSku()) ) {
				skuQATS = getBundledSku().getQuantity(quantityType='QATS',locationID=location['value']);
				if ( skuQATS > 0){
					bundleQATS += ( int(convertNativeToBundledUnits(skuQATS) / getBundledQuantity()) );
				}
			}
		}
		
		return bundleQATS;
	}

	public string function getSimpleRepresentation() {
    	return getSku().getSkuCode();
    }
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Sku (many-to-one)    
	public void function setSku(required any sku) {    
		variables.sku = arguments.sku;    
		if(isNew() or !arguments.sku.hasBundledSku( this )) {    
			arrayAppend(arguments.sku.getBundledSkus(), this);    
		}    
	}    
	public void function removeSku(any sku) {    
		if(!structKeyExists(arguments, "sku")) {    
			arguments.sku = variables.sku;    
		}    
		var index = arrayFind(arguments.sku.getBundledSkus(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.sku.getBundledSkus(), index);    
		}    
		structDelete(variables, "sku");    
	}

	public void function setMeasurementUnit(required any measurementUnit){
		if(isNull(getBundledSku()) || getBundledSku().getInventoryTrackBy() == 'Quantity'){
			return;
		}
		variables.measurementUnit = measurementUnit;
	}

	public numeric function convertNativeToBundledUnits(required numeric quantity){
		if(isNull(getMeasurementUnit()) || isNull(getBundledSku().getInventoryMeasurementUnit())){
			return arguments.quantity;
		}
		return getService('measurementService').convertUnits(amount=arguments.quantity, originalUnitCode=getBundledSku().getInventoryMeasurementUnit().getUnitCode(), convertToUnitCode=getMeasurementUnit().getUnitCode());
	}

	public numeric function convertBundledToNativeUnits(required numeric quantity){
		if(isNull(getMeasurementUnit()) || isNull(getBundledSku().getInventoryMeasurementUnit())){
			return arguments.quantity;
		}
		return getService('measurementService').convertUnits(amount=arguments.quantity, originalUnitCode=getMeasurementUnit().getUnitCode(), convertToUnitCode=getBundledSku().getInventoryMeasurementUnit().getUnitCode());
	}

	public numeric function getNativeUnitQuantityFromBundledQuantity(){

		if(isNull(getMeasurementUnit()) || isNull(getBundledSku().getInventoryMeasurementUnit())){
			return getBundledQuantity();
		}
		return getService('measurementService').convertUnits(amount=getBundledQuantity(), originalUnitCode=getMeasurementUnit().getUnitCode(), convertToUnitCode=getBundledSku().getInventoryMeasurementUnit().getUnitCode());
	}

	public numeric function getBundledUnitQuantityFromNativeQuantity(){

		if(isNull(getMeasurementUnit()) || isNull(getBundledSku().getInventoryMeasurementUnit())){
			return getBundledQuantity();
		}
		return getService('measurementService').convertUnits(amount=getBundledQuantity(), originalUnitCode=getBundledSku().getInventoryMeasurementUnit().getUnitCode(), convertToUnitCode=getMeasurementUnit().getUnitCode());
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================

	public any function getMeasurementUnit(){
		if(!StructKeyExists(variables, 'measurementUnit') || isNull(variables.measurementUnit)){
			if(!isNull(getBundledSku()) && getBundledSku().getInventoryTrackBy() == 'Measurement'){
				variables.measurementUnit = getBundledSku().getInventoryMeasurementUnit();
			}else{
				return;
			}
		}else if(getBundledSku().getInventoryTrackBy() != 'Measurement'){
			structDelete(variables, 'measurementUnit');
			return;
		}
		return variables.measurementUnit;
	}

	public array function getMeasurementUnitOptions(){
		if(!structKeyExists(variables,'measurementUnitOptions')){
			var measurementUnitCollection = getService('hibachiService').getMeasurementUnitCollectionList();
			measurementUnitCollection.setDisplayProperties('unitCode,unitName');
			measurementUnitCollection.addFilter('measurementType', getBundledSku().getInventoryMeasurementUnit().getMeasurementType());
			var records = measurementUnitCollection.getRecords();
			var recordOptions = [];
			for(var record in records){
				arrayAppend(recordOptions, {'name'=record.unitName,'value'=record.unitCode});
			}
			variables.measurementUnitOptions = recordOptions;
		}
		return variables.measurementUnitOptions;
	}
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================

	public void function preInsert(){
		super.preInsert();
		if(isNull(getMeasurementUnit) && !isNull(getBundledSku().getMeasurementUnit())){
			setMeasurementUnit(getBundledSku().getMeasurementUnit());
		}
	}
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
