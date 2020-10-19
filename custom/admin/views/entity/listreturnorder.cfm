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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfoutput>
	<div ng-init='returnOrders = {currentSection:"ALL",pastSections:{"ALL":true}}'>
		<hb:HibachiEntityActionBar type="listing" showCreate="false">
	
			<!--- Create --->
			<hb:HibachiEntityActionBarButtonGroup>
			</hb:HibachiEntityActionBarButtonGroup>
		</hb:HibachiEntityActionBar>
		
		
		<!--- Section Tabs --->
		<ul class="nav nav-tabs">
			<li ng-class="{active:returnOrders.currentSection == 'ALL'}">
				<a ng-click="returnOrders.currentSection = 'ALL'">All</a>
			</li>
			<li ng-class="{active:returnOrders.currentSection == 'INCOMPLETE'}">
				<a ng-click="returnOrders.currentSection = 'INCOMPLETE';returnOrders.pastSections.INCOMPLETE = true">Incomplete</a>
			</li>
			<li ng-class="{active:returnOrders.currentSection == 'READY'}">
				<a ng-click="returnOrders.currentSection = 'READY';returnOrders.pastSections.READY = true">Ready</a>
			</li>
			<li ng-class="{active:returnOrders.currentSection == 'APPROVED'}">
				<a ng-click="returnOrders.currentSection = 'APPROVED';returnOrders.pastSections.APPROVED = true">Approved</a>
			</li>
			<li ng-class="{active:returnOrders.currentSection == 'RELEASED'}">
				<a ng-click="returnOrders.currentSection = 'RELEASED';returnOrders.pastSections.RELEASED = true">Released</a>
			</li>
		</ul>
		<!--- End Section Tabs --->
		
		<cfset displayPropertyList = ""/>
		<cfset searchableDisplayPropertyList = "" />

		<cfset displayPropertyList = "orderOpenDateTime"/>
		<cfset searchFilterPropertyIdentifier = "orderOpenDateTime"/>
		
		<cfset local.allOrderCollectionList = $.slatwall.getService('OrderService').getOrderCollectionList() />
		<cfset local.allOrderCollectionList.setCollectionObjectListingSearchConfig({
			searchFilterPropertyIdentifier="#searchFilterPropertyIdentifier#"
		})/>
	
		<cfset local.allOrderCollectionList.setDisplayProperties(
			displayPropertyList,
			{
				isVisible=true,
				isSearchable=false,
				isDeletable=true
			}
		)/>
		
		<!--- Searchables --->
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty='orderNumber',columnConfig={
			isVisible=true,
			isSearchable=true,
			isDeletable=true
		},prepend=true)/>
		
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty='account.accountNumber',columnConfig={
			isVisible=true,
			isSearchable=true,
			isDeletable=true
		})/>	
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty='account.firstName',columnConfig={
			isVisible=true,
			isSearchable=true,
			isDeletable=true
		})/>
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty='account.lastName',columnConfig={
			isVisible=true,
			isSearchable=true,
			isDeletable=true
			})/>
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty='calculatedTotal',columnConfig={
			isVisible=true,
			isSearchable=true,
			isDeletable=true
			})/>	
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty="orderType.typeName",title="#getHibachiScope().rbkey('entity.order.orderType')#",columnConfig={isVisible=true,isSearchable=false,isDeletable=true} ) />
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty="orderStatusType.typeName",title="#getHibachiScope().rbkey('entity.order.orderStatusType')#",columnConfig={isVisible=true,isSearchable=false,isDeletable=true} ) />
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty='orderID',columnConfig={
			isVisible=false,
			isSearchable=false,
			isDeletable=false
		})/>	
		<cfset local.allOrderCollectionList.addDisplayProperty(displayProperty='currencyCode',columnConfig={
			isVisible=false,
			isSearchable=false,
			isDeletable=false
		})/>
		<cfset local.allOrderCollectionList.addFilter('orderType.systemCode','otReturnOrder,otReplacementOrder,otExchangeOrder,otRefundOrder','IN') />
		<cfset local.allOrderCollectionList.addOrderBy('orderOpenDateTime|DESC') />
		<cfset local.allOrderCollectionConfig = serializeJson(local.allOrderCollectionList.getCollectionConfigStruct()) />
		
		<!--- Incomplete orders collection setup --->
		<cfset local.incompleteOrderCollectionList = $.slatwall.getService('OrderService').getOrderCollectionList() />
		<cfset local.incompleteOrderCollectionList.setCollectionConfig(local.allOrderCollectionConfig) />
		<cfset local.incompleteOrderCollectionList.addFilter('incompleteReturnFlag',true) />
		<cfset local.incompleteOrderCollectionList.addFilter('orderStatusType.typeCode','rmaReceived') />
		
		<!--- Ready orders collection setup --->
		<cfset local.readyOrderCollectionList = $.slatwall.getService('OrderService').getOrderCollectionList() />
		<cfset local.readyOrderCollectionList.setCollectionConfig(local.allOrderCollectionConfig) />
		<cfset local.readyOrderCollectionList.addFilter('incompleteReturnFlag',true,'!=') />
		<cfset local.readyOrderCollectionList.addFilter('orderStatusType.typeCode','rmaReceived') />
		
		<!--- Approved orders collection setup --->
		<cfset local.approvedOrderCollectionList = $.slatwall.getService('OrderService').getOrderCollectionList() />
		<cfset local.approvedOrderCollectionList.setCollectionConfig(local.allOrderCollectionConfig) />
		<cfset local.approvedOrderCollectionList.addFilter('orderStatusType.typeCode','rmaApproved') />
		
		<!--- Released orders collection setup --->
		<cfset local.releasedOrderCollectionList = $.slatwall.getService('OrderService').getOrderCollectionList() />
		<cfset local.releasedOrderCollectionList.setCollectionConfig(local.allOrderCollectionConfig) />
		<cfset local.releasedOrderCollectionList.addDisplayProperty(displayProperty='orderCloseDateTime',columnConfig={isVisible:true}) />
		<cfset local.releasedOrderCollectionList.removeOrderBy('orderOpenDateTime') >
		<cfset local.releasedOrderCollectionList.addOrderBy('orderCloseDateTime|DESC') >
		<cfset local.releasedOrderCollectionList.addFilter('orderStatusType.typeCode','rmaReleased') />
	
		<!--- Searchables --->
		<div ng-show="returnOrders.currentSection == 'ALL'">
			<hb:HibachiListingDisplay 
				collectionList="#local.allOrderCollectionList#"
				usingPersonalCollection="true"
				personalCollectionKey='#request.context.entityactiondetails.itemname#'
				recordEditAction="admin:entity.edit#lcase(local.allOrderCollectionList.getCollectionObject())#"
				recordDetailAction="admin:entity.detail#lcase(local.allOrderCollectionList.getCollectionObject())#"
				multiselectPropertyIdentifier="orderID"
	            multiselectFieldName="orderIDList"
			>
			</hb:HibachiListingDisplay>
		</div>
		<div ng-if="returnOrders.pastSections.INCOMPLETE == true" ng-show="returnOrders.currentSection == 'INCOMPLETE'">
			<hb:HibachiListingDisplay 
				collectionList="#local.incompleteOrderCollectionList#"
				usingPersonalCollection="true"
				personalCollectionKey='#request.context.entityactiondetails.itemname#'
				recordEditAction="admin:entity.edit#lcase(local.allOrderCollectionList.getCollectionObject())#"
				recordDetailAction="admin:entity.detail#lcase(local.allOrderCollectionList.getCollectionObject())#"
				edit="true"
				hasActionBar="true"
				actionBarActions=""
				multiselectPropertyIdentifier="orderID"
	            multiselectFieldName="orderIDList"
				listActions="[{'name':'Approve Selected',action:'monat:entity.batchApproveReturnOrders',selectedRecords:true}]"
			>
			</hb:HibachiListingDisplay>
		</div>
		<div ng-if="returnOrders.pastSections.READY == true" ng-show="returnOrders.currentSection == 'READY'">
			<hb:HibachiListingDisplay 
				collectionList="#local.readyOrderCollectionList#"
				usingPersonalCollection="true"
				personalCollectionKey='#request.context.entityactiondetails.itemname#'
				recordEditAction="admin:entity.edit#lcase(local.allOrderCollectionList.getCollectionObject())#"
				recordDetailAction="admin:entity.detail#lcase(local.allOrderCollectionList.getCollectionObject())#"
				edit="true"
				hasActionBar="true"
				actionBarActions=""
				multiselectPropertyIdentifier="orderID"
	            multiselectFieldName="orderIDList"
				listActions="[{'name':'Approve Selected',action:'monat:entity.batchApproveReturnOrders',selectedRecords:true}]"
			>
			</hb:HibachiListingDisplay>
		</div>
		<div ng-if="returnOrders.pastSections.APPROVED == true" ng-show="returnOrders.currentSection == 'APPROVED'">
			<hb:HibachiListingDisplay
				collectionList="#local.approvedOrderCollectionList#"
				usingPersonalCollection="true"
				personalCollectionKey='#request.context.entityactiondetails.itemname#'
				recordEditAction="admin:entity.edit#lcase(local.allOrderCollectionList.getCollectionObject())#"
				recordDetailAction="admin:entity.detail#lcase(local.allOrderCollectionList.getCollectionObject())#"
				edit="true"
				hasActionBar="true"
				actionBarActions=""
				multiselectPropertyIdentifier="orderID"
	            multiselectFieldName="orderIDList"
				listActions="[{'name':'Release Selected',action:'admin:entity.batchReleaseReturnOrders',selectedRecords:true}]"
			>
			</hb:HibachiListingDisplay>
		</div>
		<div ng-if="returnOrders.pastSections.RELEASED == true" ng-show="returnOrders.currentSection == 'RELEASED'">
			<hb:HibachiListingDisplay 
				collectionList="#local.releasedOrderCollectionList#"
				usingPersonalCollection="true"
				personalCollectionKey='#request.context.entityactiondetails.itemname#'
				recordEditAction="admin:entity.edit#lcase(local.allOrderCollectionList.getCollectionObject())#"
				recordDetailAction="admin:entity.detail#lcase(local.allOrderCollectionList.getCollectionObject())#"
			>
			</hb:HibachiListingDisplay>
		</div>
	</div>
</cfoutput>
