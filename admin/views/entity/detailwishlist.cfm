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
--->
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.edit" default="false" />
<cfparam name="rc.orderTemplate" type="any" />

<cfset defaultCountryCode = 'US' />
<cfset stateCollectionList = getHibachiScope().getService('AddressService').getStateCollectionList() />
<cfset stateCollectionList.addFilter('countryCode', defaultCountryCode) />
<cfset stateCollectionList.addOrderBy('stateName|ASC') />

<cfset rc.processCallers = [] />


<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.orderTemplate#" edit="#rc.edit#">

		<sw-entity-action-bar data-base-query-string="orderTemplateID=#rc.orderTemplate.getOrderTemplateID()#"
							  data-messages="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(request.context.messages))#"
							  data-entity-action-details="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.entityActionDetails))#" 
							  data-page-title="#rc.orderTemplate.getSimpleRepresentation()#" 
							  data-cancel-action="saveOrderTemplate" 
							  data-cancel-event="cancelEditOrderTemplate"
							  data-save-action="saveOrderTemplate" 
							  data-save-event="saveOrderTemplate"
							  data-edit-action="editOrderTemplate"
							  data-edit-event="editOrderTemplate"
							  data-process-callers="#getHibachiScope().hibachiHTMLEditFormat(serializeJson(rc.processCallers))#"
							  data-type="detail" 
							  data-edit="#rc.edit#">
		</sw-entity-action-bar>

		<div class="panel-group s-pannel-group row">	
			<div class="col-md-3">
				<sw-customer-account-card data-title='#getHibachiScope().rbkey('entity.orderTemplate.account')#' 
											data-account='#rc.orderTemplate.getAccount().getEncodedJsonRepresentation()#'>
				</sw-customer-account-card> 
			</div>
		</div>

		<hb:HibachiEntityDetailGroup object="#rc.orderTemplate#">
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic.wishList')#" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertemplatetabs/ordertemplateitems" text="#$.slatwall.rbKey('admin.define.ordertemplateitems.wishList')#" open="true" />
		</hb:HibachiEntityDetailGroup>
	</hb:HibachiEntityDetailForm>
</cfoutput>
