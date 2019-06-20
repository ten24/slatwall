<!---

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

--->
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.fulfillmentBatchSmartList" type="any" />

<hb:HibachiEntityActionBar type="listing" object="#rc.fulfillmentBatchSmartList#" showCreate="false">
</hb:HibachiEntityActionBar>
<span ng-init="multislot = true"></span>
<sw-listing-display 
	data-base-entity-name="FulfillmentBatch"
	data-edit="true"
	data-has-search="true"
	record-edit-action="admin:entity.editfulfillmentbatch"
	data-record-detail-action="admin:entity.detailfulfillmentbatch"
	data-is-angular-route="false"
	data-angular-links="false"
	data-has-action-bar="false"
	data-using-personal-collection="true"
	data-persisted-collection-config="true"
	data-name="fulfillmentBatchCollectionTable"
	data-multi-slot="multislot"
		>
	
		
		
		<sw-collection-configs>
			<sw-collection-config data-entity-name="FulfillmentBatch" data-parent-directive-controller-as-name="swListingDisplay" data-filter-flag="true" data-collection-config-property="collectionConfig" data-parent-deferred-property="singleCollectionDeferred">
				<sw-collection-columns>
					<sw-collection-column data-property-identifier="fulfillmentBatchID" data-is-exportable="true"  data-is-visible="false"></sw-collection-column>
					<sw-collection-column data-property-identifier="fulfillmentBatchNumber" data-is-exportable="true"  data-is-visible="true"></sw-collection-column>
					<sw-collection-column data-property-identifier="fulfillmentBatchName" data-is-exportable="true"  data-is-visible="true"></sw-collection-column>
		            <sw-collection-column data-property-identifier="description" data-is-exportable="true"  data-is-visible="true"></sw-collection-column>
		            <sw-collection-column data-property-identifier="assignedAccount.calculatedFullName" data-is-exportable="true" data-is-visible="true"></sw-collection-column>
		        </sw-collection-columns>
				<sw-collection-filters>
					<sw-collection-filter data-property-identifier="fulfillmentBatchItems.orderFulfillment.orderFulfillmentStatusType.systemCode" data-comparison-operator="IN" data-comparison-value="ofstUnfulfilled,ofstPartiallyFulfilled"></sw-collection-filter>
				</sw-collection-filters>
			</sw-collection-config>
		</sw-collection-configs>
		
		
	</sw-listing-display>
