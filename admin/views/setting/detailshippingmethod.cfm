<!---

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

--->
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.shippingMethod" type="any" />
<cfparam name="rc.shippingIntegrations" type="array" />
<cfparam name="rc.blankShippingRate" />

<cfoutput>
	<div class="svoadmindetailshippingmethod">
		<ul id="navTask">
			<cfif !rc.edit><cf_SlatwallActionCaller action="admin:setting.editshippingmethod" querystring="shippingmethodid=#rc.shippingmethod.getshippingmethodid()#" type="list"></cfif>
	    	<cf_SlatwallActionCaller action="admin:setting.detailfulfillmentmethod" querystring="fulfillmentmethodid=shipping" text="#$.slatwall.rbKey('admin.setting.fulfillmentmethod.shippingsettings')#" type="list">
		</ul>
		
		<cfif rc.edit>
		<form name="ShippingMethodEdit" action="#buildURL('admin:setting.saveshippingmethod')#" method="post">
			<input type="hidden" name="shippingMethodID" value="#rc.shippingMethod.getShippingMethodID()#" />
		</cfif>
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.shippingMethod#" property="shippingMethodName" edit="#rc.edit#" first="true">
				<cf_SlatwallPropertyDisplay object="#rc.shippingMethod#" property="activeFlag" edit="#rc.edit#">
				<dt class="spdshippingprovider">
					<label for="shippingProvider">#rc.$.slatwall.rbKey('entity.shippingmethod.shippingprovider')#</label>
				</dt>
				<dd id="spdshippingprovider">
					<cfif rc.edit and rc.shippingMethod.isNew()>
						<select id="shippingProvider" name="shippingProvider">
							<cfloop array="#rc.shippingIntegrations#" index="local.integration">
								<option value="#local.integration.getIntegrationPackage()#">#local.integration.getIntegrationName()#</option>
							</cfloop>
							<option value="Other">Other</option>
						</select>
					<cfelse>
						<cfif rc.shippingMethod.getShippingProvider() eq "other">
							Other
						<cfelse> 
							#rc.shippingMethod.getIntegration().getIntegrationName()# <cfif rc.edit and rc.shippingMethod.getShippingProvider() neq "Other"><cf_SlatwallActionCaller action="admin:integration.edit" querystring="integrationPackage=#rc.shippingMethod.getShippingProvider()#" type="link"></cfif>
						</cfif>
					</cfif>
				</dd>
				<cfif not rc.shippingMethod.isNew()>
					<cfif arrayLen(rc.shippingMethod.getEligibleAddressZoneOptions())>
					<cfif isNull(rc.shippingMethod.getEligibleAddressZone())>
						<cf_SlatwallPropertyDisplay object="#rc.shippingMethod#" property="eligibleAddressZone" edit="#rc.edit#" nullLabel="#$.slatwall.rbKey('define.all')#">
					<cfelse>
						<cf_SlatwallPropertyDisplay object="#rc.shippingMethod#" property="eligibleAddressZone" edit="#rc.edit#" nullLabel="#$.slatwall.rbKey('define.all')#" value="#rc.shippingMethod.getEligibleAddressZone().getAddressZoneID()#" displayValue="#rc.shippingMethod.getEligibleAddressZone().getAddressZoneName()#">
					</cfif>
					</cfif>
					
					<cfif rc.shippingMethod.getShippingProvider() neq "Other">
						<!--- Provider Method --->
						<dt class="spdshippingprovidermethod">Shipping Provider Method</dt>
						<cfset local.shippingServiceMethods = rc.shippingMethod.getIntegration().getIntegrationCFC('shipping').getShippingMethods() />
						<cfif rc.edit>
							<dd id="spdshippingprovidermethod">
								<select name="shippingProviderMethod">
									<cfloop collection="#local.shippingServiceMethods#" item="local.shippingMethodID">
										<option value="#local.shippingMethodID#" <cfif rc.shippingMethod.getShippingProviderMethod() eq local.shippingMethodID>selected="selected"</cfif>>#local.shippingServiceMethods[shippingMethodID]#</option>
									</cfloop>
								</select>
							</dd>
						<cfelse>
							<dd id="spdshippingprovidermethod"><cfif rc.shippingMethod.getShippingProviderMethod() neq "">#local.shippingServiceMethods[rc.shippingMethod.getShippingProviderMethod()]#<cfelse>&nbsp;</cfif></dd>	
						</cfif>
						
						<!--- Use Rate Table? --->
						<cf_SlatwallPropertyDisplay object="#rc.shippingMethod#" property="useRateTableFlag" edit="#rc.edit#">
						
						<div class="providerOptions<cfif rc.shippingMethod.getUseRateTableFlag()> hideElement</cfif>">
							<cf_SlatwallPropertyDisplay object="#rc.shippingMethod#" property="shippingRateIncreasePercentage" edit="#rc.edit#">
							<cf_SlatwallPropertyDisplay object="#rc.shippingMethod#" property="shippingRateIncreaseDollar" edit="#rc.edit#">
						</div>
					</cfif>
				</cfif>
			</dl>
			
			<cfif not rc.shippingMethod.isNew()>
				<div class="rateTable<cfif not rc.shippingMethod.getUseRateTableFlag()> hideElement</cfif>">
					<strong>Rate Table</strong>
					<cfset local.shippingRates = rc.shippingMethod.getShippingRates() />
					<table id="shippingRateTable" class="listing-grid stripe">
						<thead>
							<tr>
								<th class="varWidth">#rc.$.slatwall.rbKey('entity.shippingrate.addressZone')#</th>
								<th>#rc.$.slatwall.rbKey('entity.shippingrate.minWeight')#</th>
								<th>#rc.$.slatwall.rbKey('entity.shippingrate.maxWeight')#</th>
								<th>#rc.$.slatwall.rbKey('entity.shippingrate.minPrice')#</th>
								<th>#rc.$.slatwall.rbKey('entity.shippingrate.maxPrice')#</th>
								<th>#rc.$.slatwall.rbKey('entity.shippingrate.shippingRate')#</th>
								<th class="administration">&nbsp;</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#rc.shippingMethod.getShippingRates()#" index="local.shippingRate">
								<tr>
									<td class="varWidth"><cfif isNull(local.shippingRate.getAddressZone())>#$.slatwall.rbKey('define.all')#<cfelse>#local.shippingRate.getAddressZone().getAddressZoneName()#</cfif></td>
									<td>#local.shippingRate.getMinWeight()#</td>
									<td>#local.shippingRate.getMaxWeight()#</td>
									<td>#local.shippingRate.getMinPrice()#</td>
									<td>#local.shippingRate.getMaxPrice()#</td>
									<td>#lsCurrencyFormat(local.shippingRate.getShippingRate())#</td>
									<td class="administration">
										<ul class="one">
											<cf_SlatwallActionCaller action="admin:setting.deleteshippingrate" querystring="shippingrateid=#local.shippingRate.getShippingRateID()#" class="delete" type="list">
										</ul>
									</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
					<cfif rc.edit>
						<dl class="twoColumn">
							<cfif arrayLen(rc.blankShippingRate.getAddressZoneOptions())>
								<cf_SlatwallPropertyDisplay object="#rc.blankShippingRate#" property="addressZone" edit="true" nullLabel="#$.slatwall.rbKey('define.all')#">
							<cfelse>
								<dt>Address Zone</dt>
								<dd>All - <cf_SlatwallActionCaller action="admin:setting.createaddresszone"></dd>
							</cfif>
							<cf_SlatwallPropertyDisplay object="#rc.blankShippingRate#" property="minWeight" edit="true" />
							<cf_SlatwallPropertyDisplay object="#rc.blankShippingRate#" property="maxWeight" edit="true" />
							<cf_SlatwallPropertyDisplay object="#rc.blankShippingRate#" property="minPrice" edit="true" />
							<cf_SlatwallPropertyDisplay object="#rc.blankShippingRate#" property="maxPrice" edit="true" />
							<cf_SlatwallPropertyDisplay object="#rc.blankShippingRate#" property="shippingRate" edit="true" />
						</dl>
						<button type="submit" name="addRate" value="true">Add Rate</button>
					</cfif>
				</div>
			</cfif>
	<cfif rc.edit>
			<div id="actionButtons" class="clearfix">
				<cf_SlatwallActionCaller action="admin:setting.detailfulfillmentmethod" querystring="fulfillmentmethodID=shipping" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
				<cfif !rc.shippingMethod.isNew() AND !rc.shippingMethod.isAssigned()>
					<cf_SlatwallActionCaller action="admin:setting.deleteshippingmethod" querystring="shippingMethodID=#rc.shippingMethod.getShippingMethodID()#" class="button" type="link" confirmRequired="true">
				</cfif>
				<cf_SlatwallActionCaller action="admin:setting.saveshippingmethod" type="submit" class="button">
			</div>
		</form>
	</cfif>
</cfoutput>
