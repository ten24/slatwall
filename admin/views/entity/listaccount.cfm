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


<cfparam name="rc.accountSmartList" type="any" />

<cfoutput>

	<hb:HibachiEntityActionBar type="listing" object="#rc.accountSmartList#" showCreate="false">

	<!--- Create --->
		<hb:HibachiEntityActionBarButtonGroup>
			<hb:HibachiProcessCaller action="admin:entity.preprocessaccount" entity="account" processContext="create" class="btn btn-primary" icon="plus icon-white" text="#$.slatwall.rbKey('define.create')# #$.slatwall.rbKey('entity.account')#" modal="true" />
		</hb:HibachiEntityActionBarButtonGroup>
	</hb:HibachiEntityActionBar>


    <cfset accountCollectionList = getHibachiScope().getService('accountService').getAccountCollectionList()>

	<cfset serchableDisplayProperties = "firstName,lastName,primaryEmailAddress.emailAddress,company"/>
	<cfset accountCollectionList.setDisplayProperties(
	serchableDisplayProperties,
	{
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	
	<cfset nonSerchableDisplayProperties = "calculatedGuestAccountFlag,organizationFlag"/>
	<cfset accountCollectionList.addDisplayProperties(
		nonSerchableDisplayProperties, 
		{
			isVisible=true,
			isSearchable=false,
			isDeletable=true
		}
	)/>

	<cfset accountCollectionList.addDisplayProperty(
	displayProperty='accountID',
	columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	<cfset accountCollectionList.addOrderBy('createdDateTime|DESC') />
	
	<hb:HibachiListingDisplay 
		collectionList="#accountCollectionList#"
		usingPersonalCollection="true"
		personalCollectionKey='#request.context.entityactiondetails.itemname#'
		recordEditAction="admin:entity.edit#lcase(accountCollectionList.getCollectionObject())#"
		recordDetailAction="admin:entity.detail#lcase(accountCollectionList.getCollectionObject())#"
	>
	</hb:HibachiListingDisplay>

</cfoutput>
