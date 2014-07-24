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
<cfoutput>
<GetTaxRequest>
	<CustomerCode>#arguments.requestBean.getAccountID()#</CustomerCode>
	<DocDate>#DateFormat(now(),'yyyy-mm-dd')#</DocDate>
	<DocCode>#taxCart.cartID#</DocCode>
	<DocType>salesInvoice</DocType>
	<Commit>1</Commit>
	<Addresses>
		<Address>
			<AddressCode>1</AddressCode>
			<Line1>#arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxStreetAddress()#/Line1>
			<cfif len(trim(arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxStreet2Address()))><Line2>#arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxStreet2Address()#</Line2></cfif>
			<cfif len(trim(arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxCity()))><City>#arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxCity()#</City></cfif>
			<cfif len(trim(arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxStateCode()))><Region>#arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxStateCode()#</Region></cfif>
			<cfif len(trim(arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxCountryCode())) is 2><Country>#arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxCountryCode()#</Country></cfif>
			<cfif len(trim(arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxPostalCode()))><PostalCode>#arguments.requestBean.getTaxRateItemRequestBeans()[1].getTaxPostalCode()#</PostalCode></cfif>
		</Address>
		<Address>
			<AddressCode>2</AddressCode>
			<Line1><cfif len(trim(xmlData.fromaddress1))>#xmlData.fromaddress1#<cfelse>Unavailable</cfif></Line1>
			<!--- <cfif len(trim(xmlData.fromaddress2))><Line2>#xmlData.fromaddress2#</Line2></cfif> --->
			<cfif len(trim(setting('city')))><City>#setting('city')#</City></cfif>
			<cfif len(trim(setting('stateCode')))><Region>#xmlData.fromstate#</Region></cfif>
			<cfif len(trim(setting('country')))><Country>#setting('country')#</Country></cfif>
			<cfif len(trim(setting('postalCode')))><PostalCode>#setting('postalCode')#</PostalCode></cfif>
		</Address>
	</Addresses>
	<Lines>
	<cfset counter = 1>
	<cfloop index="i" from="1" to="#arrayLen(arguments.requestBean.getTaxRateItemRequestBeans())#">
	<!--- <cfloop from="1" to="#arrayLen(taxcart.cartItems)#" index="i"> --->
		<Line>
			<LineNo>#counter#</LineNo>
			<DestinationCode>1</DestinationCode>
			<OriginCode>2</OriginCode>
			<ItemCode>#arguments.requestBean.getTaxRateItemRequestBeans()[i].getOrderItemID()#</ItemCode>
			<TaxCode>NT</TaxCode>
			<Description>Item Description</Description>
			<Qty>#arguments.requestBean.getTaxRateItemRequestBeans()[i].getQuantity()#</Qty>
			<Amount>#arguments.requestBean.getTaxRateItemRequestBeans()[i].getSubTotal()#</Amount>
		</Line>
		<cfset counter++>
	</cfloop>
	</Lines>
</GetTaxRequest>
</cfoutput>
