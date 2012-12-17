<!---

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

--->

<cfparam name="rc.orderSmartList" type="any" />

<cfoutput>


<cfset rc.orderSmartList.addOrder("createdDateTime|DESC") />

<!---
<cfif not len(rc.orderSmartList.getFilters("orderStatusType.type")) >
	<cfset local.defaultStatusFilter = $.slatwall.getService('typeService').getTypeBySystemCode("ostNew").getType() />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostProcessing").getType()) />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostOnHold").getType()) />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostClosed").getType()) />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostCanceled").getType()) />
	<cfset rc.orderSmartList.addFilter('orderStatusType.type', local.defaultStatusFilter) />
</cfif>
--->

<cf_SlatwallActionBar type="listing" object="#rc.orderSmartList#" />
	
<cf_SlatwallListingDisplay smartList="#rc.orderSmartList#" 
							recordDetailAction="admin:order.detailorder">
	<cf_SlatwallListingColumn propertyIdentifier="orderNumber" search="true" />
	<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="account.company" search="true"/>
	<cf_SlatwallListingColumn propertyIdentifier="account.firstName" search="true" />
	<cf_SlatwallListingColumn propertyIdentifier="account.lastName" search="true" />
	<cf_SlatwallListingColumn propertyIdentifier="orderType.type" filter=true />
	<cf_SlatwallListingColumn propertyIdentifier="orderStatusType.type" title="#$.slatwall.rbKey('define.status')#" filter="true" />
	<cf_SlatwallListingColumn propertyIdentifier="orderOrigin.orderOriginName" filter="true" />
	<cf_SlatwallListingColumn propertyIdentifier="createdDateTime"  range=true />
	<cf_SlatwallListingColumn propertyIdentifier="orderOpenDateTime"  range=true />
	<cf_SlatwallListingColumn propertyIdentifier="calculatedTotal" range=true />
</cf_SlatwallListingDisplay>

</cfoutput>