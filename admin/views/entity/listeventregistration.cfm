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


<cfparam name="rc.eventregistrationsmartlist" type="any" />

<cfoutput>

	<hb:HibachiEntityActionBar type="listing" object="#rc.eventregistrationsmartlist#" showCreate="false">

		<!--- Create --->
		<hb:HibachiEntityActionBarButtonGroup>
			<hb:HibachiProcessCaller action="admin:entity.preprocessorder" entity="order" processContext="create" class="btn btn-primary" icon="plus icon-white" modal="true" />
		</hb:HibachiEntityActionBarButtonGroup>
	</hb:HibachiEntityActionBar>

	<!--- <hb:HibachiListingDisplay type="listing" object="#rc.eventregistrationsmartlist#"
							  smartList="#rc.eventregistrationsmartlist#"
							  showCreate="false"
							  recordEditAction="admin:entity.editeventregistration"
							  recorddetailaction="admin:entity.detaileventregistration">

		<hb:HibachiListingColumn propertyIdentifier="account.firstname" />
		<hb:HibachiListingColumn propertyIdentifier="account.lastname" />
		<hb:HibachiListingColumn propertyIdentifier="orderitem.sku.product.productName" />
		<hb:HibachiListingColumn propertyIdentifier="orderitem.sku.eventStartDateTime" />
		<hb:HibachiListingColumn propertyIdentifier="orderitem.sku.eventEndDateTime" />
		<hb:HibachiListingColumn propertyIdentifier="orderitem.sku.skudefinition" />
	</hb:HibachiListingDisplay> --->

	<sw-listing-display data-using-personal-collection="true"
		data-collection="'EventRegistration'"
		data-edit="false"
		data-has-search="true"
		record-edit-action="admin:entity.editeventregistration"
		record-detail-action="admin:entity.detaileventregistration"
		data-is-angular-route="false"
		data-angular-links="false"
		data-has-action-bar="false"
	>
		<sw-listing-column data-property-identifier="eventRegistrationID" data-is-visible="false" data-is-deletable="false" ></sw-listing-column>
		<sw-listing-column data-property-identifier="account.firstName" ></sw-listing-column>
		<sw-listing-column data-property-identifier="account.lastName" ></sw-listing-column>
		<sw-listing-column data-property-identifier="orderItem.sku.product.productName" ></sw-listing-column>
		<sw-listing-column data-property-identifier="orderItem.sku.eventStartDateTime" ></sw-listing-column>
		<sw-listing-column data-property-identifier="orderItem.sku.eventEndDateTime" ></sw-listing-column>
		<sw-listing-column data-property-identifier="orderItem.sku.calculatedSkuDefinition" ></sw-listing-column>
	</sw-listing-display>

</cfoutput>
