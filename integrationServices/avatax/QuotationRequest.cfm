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
<GetTax>
	<CustomerCode>#arguments.requestBean.getAccountID()#</CustomerCode>
	<DocDate>#DateFormat(now(),'yyyy-mm-dd')#</DocDate>
	<DocCode>#arguments.requestBean.getOrderID()#</DocCode>
	<DocType>salesInvoice</DocType>
	<Commit>1</Commit>
	<Addresses>
		<Address>
			<AddressCode>1</AddressCode>
			<Line1>#addressTaxRequestItems[1].getTaxStreetAddress()#</Line1>
			<cfif len(trim(addressTaxRequestItems[1].getTaxStreet2Address()))><Line2>#addressTaxRequestItems[1].getTaxStreet2Address()#</Line2></cfif>
			<cfif len(trim(addressTaxRequestItems[1].getTaxCity()))><City>#addressTaxRequestItems[1].getTaxCity()#</City></cfif>
			<cfif len(trim(addressTaxRequestItems[1].getTaxStateCode()))><Region>#addressTaxRequestItems[1].getTaxStateCode()#</Region></cfif>
			<cfif len(trim(addressTaxRequestItems[1].getTaxCountryCode())) is 2><Country>#addressTaxRequestItems[1].getTaxCountryCode()#</Country></cfif>
			<cfif len(trim(addressTaxRequestItems[1].getTaxPostalCode()))><PostalCode>#addressTaxRequestItems[1].getTaxPostalCode()#</PostalCode></cfif>
		</Address>
		<Address>
			<AddressCode>2</AddressCode>
			<Line1>#setting('sourceStreetAddress')#</Line1>
			<cfif len(setting('sourceStreetAddress2'))><Line2>#setting('sourceStreetAddress2')#</Line2></cfif>
			<cfif len(setting('sourceCity'))><City>#setting('sourceCity')#</City></cfif>
			<cfif len(setting('sourceRegion'))><Region>#setting('sourceRegion')#</Region></cfif>
			<cfif len(setting('sourceCountry'))><Country>#setting('sourceCountry')#</Country></cfif>
			<cfif len(setting('sourcePostalCode'))><PostalCode>#setting('sourcePostalCode')#</PostalCode></cfif>
		</Address>
	</Addresses>
	<Lines>
	<cfset counter = 1>
	<cfloop index="i" from="1" to="#arrayLen(addressTaxRequestItems)#">
		<Line>
			<LineNo>#counter#</LineNo>
			<DestinationCode>1</DestinationCode>
			<OriginCode>2</OriginCode>
			<ItemCode>#addressTaxRequestItems[i].getOrderItemID()#</ItemCode>
			<TaxCode>NT</TaxCode>
			<Description>Item Description</Description>
			<Qty>#addressTaxRequestItems[i].getQuantity()#</Qty>
			<Amount>#addressTaxRequestItems[i].getExtendedPriceAfterDiscount()#</Amount>
		</Line>
		<cfset counter++>
	</cfloop>
	</Lines>
</GetTax>
</cfoutput>
