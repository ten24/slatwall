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
component displayname="SkuMinMaxReport" entityname="SlatwallSkuMinMaxReport" table="swSkuMinMaxReport" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="skuService" {

	// Persistent Properties
	property name="skuMinMaxReportID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="reportName" ormtype="string" description="Defines the name of the report.";

	property name="skuCollectionConfig" hb_populateEnabled="public" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json" hint="json object used to construct the base collection HQL query" default="{}";

	property name="minQuantity" ormtype="integer";
	property name="maxQuantity" ormtype="integer";

	// Related Object Properties (many-to-one)
	property name="location" cfc="Location" fieldtype="many-to-one" fkcolumn="locationID";
	property name="schedule" cfc="Schedule" fieldtype="many-to-one" fkcolumn="scheduleID";

	//Calculated Properties
	
	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="skuMinMaxReportCollection" persistent="false";

	//Derived Properties


	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentationPropertyName() {
		return "reportName";
	}

	public any function getSkuCollectionConfig() {
		if(variables.skuCollectionConfig == '{}' ) {
			// Create base collection to select active skus
			var skuCollection = getService('HibachiCollectionService').newCollection();
			skuCollection.setCollectionObject('Sku');
			skuCollection.setDisplayProperties(displayPropertiesList='skuName,skuCode,skuDescription,skuDefinition,calculatedQATS,activeFlag', columnConfig={isSearchable="true",isVisible="true",isDeletable="true"});
			skuCollection.addDisplayProperty(displayProperty='skuID', columnConfig={isSearchable="false",isVisible="false",isDeletable="false"});
			skuCollection.addOrderBy('skuCode|ASC');
			skuCollection.addFilter('activeFlag', 'True', '=');
			return serializeJSON(skuCollection.getCollectionConfigStruct());
		} else {
			return variables.skuCollectionConfig;
		}
	}

	public any function getSkuMinMaxReportCollection() {
		var skuMinMaxReportCollection = getService('HibachiCollectionService').newCollection();
		skuMinMaxReportCollection.setCollectionObject('Sku');

		// Apply sku collection
		skuMinMaxReportCollection.setCollectionConfig(this.getSkuCollectionConfig());

		// Add selected locations filters
		skuMinMaxReportCollection.addFilter(propertyIdentifier='stocks.location.locationIDPath', value='%#this.getLocation().getLocationID()#%', comparisonOperator='LIKE', logicalOperator='OR', aggregate= '', filterGroupAlias='locationFilters', filterGroupLogicalOperator='AND');

		// Aggregate QATS up to selected location and filter on min/max range
		skuMinMaxReportCollection.addDisplayAggregate(propertyIdentifier='stocks.calculatedQATS', aggregateFunction='SUM', aggregateAlias='sumQATS', columnConfig={isSearchable="false",isVisible="false",isDeletable="false"});
		skuMinMaxReportCollection.addFilter(propertyIdentifier='stocks.calculatedQATS', value=this.getMinQuantity(), comparisonOperator='>=', logicalOperator='OR', aggregate='SUM', filterGroupAlias='stockFilters', filterGroupLogicalOperator='AND');
		skuMinMaxReportCollection.addFilter(propertyIdentifier='stocks.calculatedQATS', value=this.getMaxQuantity(), comparisonOperator='<=', logicalOperator='OR', aggregate='SUM', filterGroupAlias='stockFilters', filterGroupLogicalOperator='AND');

		// skuMinMaxReportCollection.updateCollectionConfig();

		return skuMinMaxReportCollection;
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}
