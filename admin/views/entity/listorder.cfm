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



<cfparam name="rc.orderSmartList" type="any" />

<cfoutput>

	<hb:HibachiEntityActionBar type="listing" object="#rc.orderSmartList#" showCreate="false">

		<!--- Create --->
		<hb:HibachiEntityActionBarButtonGroup>
			<hb:HibachiProcessCaller action="admin:entity.preprocessorder" entity="order" processContext="create" class="btn btn-primary" icon="plus icon-white" modal="true" />
		</hb:HibachiEntityActionBarButtonGroup>
	</hb:HibachiEntityActionBar>

	<!--- <hb:HibachiListingDisplay type="listing" smartList="#rc.orderSmartList#"
			recordDetailAction="admin:entity.detailorder"
			recordEditAction="admin:entity.editorder"
			showCreate="true">

		<cfif rc.slatAction eq "admin:entity.listorder">
			<hb:HibachiListingColumn propertyIdentifier="orderNumber" />
			<hb:HibachiListingColumn propertyIdentifier="orderOpenDateTime" />
		</cfif>
		<hb:HibachiListingColumn propertyIdentifier="account.firstName" />
		<hb:HibachiListingColumn propertyIdentifier="account.lastName" />
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="account.company" />
		<hb:HibachiListingColumn propertyIdentifier="orderType.typeName" sort=true title="#$.slatwall.rbKey('entity.order.orderType')#"/>
		<hb:HibachiListingColumn propertyIdentifier="orderStatusType.typeName" title="#$.slatwall.rbKey('define.status')#" filter="true" sort="true" />
		<hb:HibachiListingColumn propertyIdentifier="orderOrigin.orderOriginName" />
		<hb:HibachiListingColumn propertyIdentifier="createdDateTime" />
		<hb:HibachiListingColumn propertyIdentifier="calculatedTotal" />
	</hb:HibachiListingDisplay> --->
	
	<cfset displayPropertyList = ""/>
	<cfset searchableDisplayPropertyList = "" />
	<cfset searchFilterPropertyIdentifier="createdDateTime"/>
	<cfif rc.slatAction eq "admin:entity.listorder">
		<cfset displayPropertyList &= "orderOpenDateTime,"/>
		<cfset searchFilterPropertyIdentifier = "orderOpenDateTime"/>
		
	<cfelse>
	</cfif>
	<cfset displayPropertyList &= 'createdDateTime,calculatedTotal'/>

	<cfset rc.orderCollectionList.setDisplayProperties(
		displayPropertyList,
		{
			isVisible=true,
			isSearchable=false,
			isDeletable=true
		}
	)/>
	<cfset rc.orderCollectionList.addDisplayProperty(displayProperty="orderType.typeName",title="#getHibachiScope().rbkey('entity.order.orderType')#",columnConfig={isVisible=true,isSearchable=false,isDeletable=true} ) />
	<cfset rc.orderCollectionList.addDisplayProperty(displayProperty="orderStatusType.typeName",title="#getHibachiScope().rbkey('entity.order.orderStatusType')#",columnConfig={isVisible=true,isSearchable=false,isDeletable=true} ) />
	<cfset rc.orderCollectionlist.addDisplayProperty(displayProperty='orderID',columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	<!--- Searchables --->
	<cfif rc.slatAction eq "admin:entity.listorder">
		<cfset rc.orderCollectionlist.addDisplayProperty(displayProperty='orderNumber',columnConfig={
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	
	</cfif>
	
	<cfset rc.orderCollectionlist.addDisplayProperty(displayProperty='account.firstName',columnConfig={
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	<cfset rc.orderCollectionlist.addDisplayProperty(displayProperty='account.lastName',columnConfig={
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	<cfset rc.orderCollectionlist.addDisplayProperty(displayProperty='account.company',columnConfig={
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	},prepend=true)/>


	<!--- Searchables --->
	<hb:HibachiListingDisplay 
		collectionList="#rc.orderCollectionlist#"
		usingPersonalCollection="true"
		showSearchFilterDropDown="true"
		searchFilterPropertyIdentifier="#searchFilterPropertyIdentifier#"
		personalCollectionKey='#request.context.entityactiondetails.itemname#'
		recordEditAction="admin:entity.edit#lcase(rc.orderCollectionlist.getCollectionObject())#"
		recordDetailAction="admin:entity.detail#lcase(rc.orderCollectionlist.getCollectionObject())#"
	>
	</hb:HibachiListingDisplay>


</cfoutput>
