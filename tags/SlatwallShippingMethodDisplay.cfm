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
<cfimport prefix="swa" taglib="../tags" />
<cfimport prefix="hb" taglib="../org/Hibachi/HibachiTags" />
<cfparam name="attributes.orderFulfillmentShipping" type="any" />
<cfparam name="attributes.orderFulfillmentIndex" type="string" />
<cfparam name="attributes.edit" type="boolean" default="true" />

<cfset local.methodOptions = attributes.orderFulfillmentShipping.getShippingMethodOptions() />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<swa:SlatwallErrorDisplay object="#attributes.orderFulfillmentShipping#" errorName="processing" displayType="div">
		<cfif attributes.edit>
			<cfif arrayLen(local.methodOptions)>
				<cfset local.noneSelected = false />
				<cfif isNull(attributes.orderFulfillmentShipping.getShippingMethod())>
					<cfset local.noneSelected = true />
				</cfif>
				<cfloop array="#local.methodOptions#" index="option">
					<cfset local.optionSelected = false />
					<cfif !isNull(attributes.orderFulfillmentShipping.getShippingMethod()) and attributes.orderFulfillmentShipping.getShippingMethod().getShippingMethodID() eq option['value']>
						<cfset local.optionSelected = true />
					<cfelseif local.noneSelected>
						<cfset local.noneSelected = false />
						<cfset local.optionSelected = true />
					</cfif>
					<dl>
						<dt><input type="radio" name="orderFulfillments[#attributes.orderFulfillmentIndex#].shippingMethodID" value="#option['value']#" <cfif local.optionSelected>checked="checked"</cfif>></dt>
						<dd>#option['name']#</dd>
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
