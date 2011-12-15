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
<cfparam name="attributes.orderFulfillmentShipping" type="any" />
<cfparam name="attributes.orderFulfillmentIndex" type="string" />
<cfparam name="attributes.edit" type="boolean" default="true" />

<cfset local.methodOptions = attributes.orderFulfillmentShipping.getOrderShippingMethodOptions() />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<cf_SlatwallErrorDisplay object="#attributes.orderFulfillmentShipping#" errorName="processing" displayType="div">
		<cfif attributes.edit>
			<cfif arrayLen(local.methodOptions)>
				<cfset local.noneSelected = false />
				<cfif isNull(attributes.orderFulfillmentShipping.getShippingMethod())>
					<cfset local.noneSelected = true />
				</cfif>
				<cfloop array="#local.methodOptions#" index="option">
					<cfset local.optionSelected = false />
					<cfif !isNull(attributes.orderFulfillmentShipping.getShippingMethod()) and attributes.orderFulfillmentShipping.getShippingMethod().getShippingMethodID() eq option.getShippingMethod().getShippingMethodID()>
						<cfset local.optionSelected = true />
					<cfelseif local.noneSelected>
						<cfset local.noneSelected = false />
						<cfset local.optionSelected = true />
					</cfif>
					<dl>
						<dt><input type="radio" name="orderFulfillments[#attributes.orderFulfillmentIndex#].orderShippingMethodOptionID" value="#option.getOrderShippingMethodOptionID()#" <cfif local.optionSelected>checked="checked"</cfif>>#option.getShippingMethod().getShippingMethodName()#</dt>
						<dd>#option.getFormattedValue('totalCharge', 'currency')#</dd>
					</dl>
				</cfloop>
			<cfelse>
				<p class="noOptions">No Shipping options available, please update your address to proceed.</p>
			</cfif>
		<cfelse>
			<cfif not isNull(attributes.orderFulfillmentShipping.getShippingMethod())>
				<dl>
					<dt>#attributes.orderFulfillmentShipping.getFormattedValue('fulfillmentCharge', 'currency')# </dt>
					<dd>#attributes.orderFulfillmentShipping.getShippingMethod().getShippingMethodName()#</dd>
				</dl>
			</cfif>
		</cfif>
	</cfoutput>
</cfif>