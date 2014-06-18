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
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:vertexinc:o-series:tps:6:0">
	   	<soapenv:Header/>
	   	<soapenv:Body>
	      	<urn:VertexEnvelope>
	         	<urn:Login>
	            	<urn:UserName>#setting('username')#</urn:UserName>
	            	<urn:Password>#setting('password')#</urn:Password>
	         	</urn:Login>
				<urn:QuotationRequest documentDate="#dateTimeFormat(Now(), 'yyyy-mm-dd')#" documentNumber="#arguments.requestBean.getOrderID()#" transactionId="#createUUID()#" transactionType="SALE">
				  	<urn:Currency isoCurrencyCodeAlpha="USD"/>
				  	<urn:Seller>
				    	<urn:Company>#setting('company')#</urn:Company>
				    	<urn:Division>#setting('division')#</urn:Division>
				    	<urn:Department>#setting('department')#</urn:Department>
				    	<urn:PhysicalOrigin>
				      		<urn:City>#setting('city')#</urn:City>
				      		<urn:MainDivision>#setting('mainDivision')#</urn:MainDivision>
				      		<urn:PostalCode>#setting('postalCode')#</urn:PostalCode>
				     		<urn:Country>#setting('country')#</urn:Country>
				     		<urn:CurrencyConversion isoCurrencyCodeAlpha="USD">1</urn:CurrencyConversion>
				   		</urn:PhysicalOrigin>
				  	</urn:Seller>
				  	<urn:Customer>
				    	<urn:CustomerCode>#arguments.requestBean.getAccountID()#</urn:CustomerCode>
				    	<urn:Destination>
				    		<urn:StreetAddress1>#addressTaxRequestItems[ 1 ].getTaxStreetAddress()#</urn:StreetAddress1>
				      		<urn:StreetAddress2>#addressTaxRequestItems[ 1 ].getTaxStreet2Address()#</urn:StreetAddress2>
							<urn:City>#addressTaxRequestItems[ 1 ].getTaxCity()#</urn:City>
				      		<urn:MainDivision>#addressTaxRequestItems[ 1 ].getTaxStateCode()#</urn:MainDivision>
				      		<urn:PostalCode>#addressTaxRequestItems[ 1 ].getTaxPostalCode()#</urn:PostalCode>
				     		<urn:Country>#addressTaxRequestItems[ 1 ].getTaxCountryCode()#</urn:Country>
				     		<urn:CurrencyConversion isoCurrencyCodeAlpha="USD">1</urn:CurrencyConversion>
				    	</urn:Destination>
					 </urn:Customer>
					 <cfset var count = 0 />
					 <cfloop array="#addressTaxRequestItems#" index="taxRequestItem">
					 	<cfset count++ />
					 	 <urn:LineItem lineItemNumber="#count#" materialCode="#taxRequestItem.getOrderItemID()#">
					    	<urn:ExtendedPrice>#taxRequestItem.getExtendedPriceAfterDiscounts()#</urn:ExtendedPrice>
							<urn:FlexibleFields>
					      		<urn:FlexibleCodeField fieldId="7">CUST_NAME</urn:FlexibleCodeField>
					      		<urn:FlexibleCodeField fieldId="11">TAX_CODE</urn:FlexibleCodeField>
					      		<urn:FlexibleCodeField fieldId="12">PRODUCT_NAME</urn:FlexibleCodeField>
					    	</urn:FlexibleFields>
					  	</urn:LineItem>
					</cfloop>			 
				</urn:QuotationRequest>
			</urn:VertexEnvelope>
		</soapenv:Body>
	</soapenv:Envelope>
</cfoutput>
