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
    <ns:ProcessShipmentRequest
        xsi:schemaLocation="http://www.fedex.com/templates/components/apps/wpor/secure/downloads/xml/Aug09/Advanced/ShipService_v17.xsd"
        xmlns:ns="http://fedex.com/ws/ship/v17"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        
        <ns:WebAuthenticationDetail>
	        <ns:UserCredential>
	            <ns:Key>#trim(setting('transactionKey'))#</ns:Key>
	            <ns:Password>#trim(setting('password'))#</ns:Password>
	        </ns:UserCredential>
	    </ns:WebAuthenticationDetail>
	    <ns:ClientDetail>
	        <ns:AccountNumber>#trim(setting('accountNo'))#</ns:AccountNumber>
	        <ns:MeterNumber>#trim(setting('meterNo'))#</ns:MeterNumber>
	    </ns:ClientDetail>
          
        <ns:Version>
           <ns:ServiceId>ship</ns:ServiceId>
           <ns:Major>17</ns:Major>
           <ns:Intermediate>0</ns:Intermediate>
           <ns:Minor>0</ns:Minor>
        </ns:Version>
        <ns:RequestedShipment>
	        <ns:ShipTimestamp>#DateFormat(Now(),'yyyy-mm-dd')#T#TimeFormat(Now(),'hh:mm:ss')#</ns:ShipTimestamp>
	        <ns:DropoffType>REGULAR_PICKUP</ns:DropoffType>
	        <ns:ServiceType>STANDARD_OVERNIGHT</ns:ServiceType>
	        <ns:PackagingType>YOUR_PACKAGING</ns:PackagingType>
	        <ns:TotalWeight>
	            <ns:Units>LB</ns:Units>
	            <ns:Value>#arguments.requestBean.getTotalWeight( unitCode='lb' )#</ns:Value>
	        </ns:TotalWeight>
	        <ns:TotalInsuredValue>
	            <ns:Currency>USD</ns:Currency>
	            <ns:Amount>#arguments.requestBean.getTotalValue()#</ns:Amount>
	        </ns:TotalInsuredValue>
	       
	        <ns:Shipper>
	        	<ns:Contact>
	            	<ns:PersonName>#trim(setting('contactPersonName'))#</ns:PersonName>
	            	<ns:CompanyName>#trim(setting('contactCompany'))#</ns:CompanyName>
	            	<ns:PhoneNumber>#trim(setting('contactPhoneNumber'))#</ns:PhoneNumber>
           		</ns:Contact>
	            <ns:Address>
	            	<ns:StreetLines>#trim(setting('shipperStreet'))#</ns:StreetLines>
	                <ns:City>#trim(setting('shipperCity'))#</ns:City>
	                <ns:StateOrProvinceCode>#trim(setting('shipperStateCode'))#</ns:StateOrProvinceCode>
	                <ns:PostalCode>#trim(setting('shipperPostalCode'))#</ns:PostalCode>
	                <ns:CountryCode>#trim(setting('shipperCountryCode'))#</ns:CountryCode>
	            </ns:Address>
	        </ns:Shipper>
	        <ns:Recipient>
	        	<ns:Contact>
		            <ns:PersonName>#arguments.requestBean.getContactPersonName()#</ns:PersonName>
		            
		            <ns:CompanyName>#arguments.requestBean.getContactCompany()#</ns:CompanyName>
		            
		            <ns:PhoneNumber>#arguments.requestBean.getContactPhoneNumber#</ns:PhoneNumber>
	           </ns:Contact>
	        	<ns:Address>
	                <ns:StreetLines>#arguments.requestBean.getShipToStreetAddress()#</ns:StreetLines>
	                <ns:City>#arguments.requestBean.getShipToCity()#</ns:City>
					<cfif len(arguments.requestBean.getShipToStateCode()) eq 2>
	                	<ns:StateOrProvinceCode>#arguments.requestBean.getShipToStateCode()#</ns:StateOrProvinceCode>
					<cfelseif len(arguments.requestBean.getShipToStateCode()) eq 3>
						<ns:StateOrProvinceCode>#left(arguments.requestBean.getShipToStateCode(),2)#</ns:StateOrProvinceCode> 
					</cfif>
	                <ns:PostalCode>#arguments.requestBean.getShipToPostalCode()#</ns:PostalCode>
	                <ns:CountryCode>#arguments.requestBean.getShipToCountryCode()#</ns:CountryCode>
					<ns:Residential>false</ns:Residential>
	            </ns:Address>
	        </ns:Recipient>
	        
	        <ns:ShippingChargesPayment>
	           <ns:PaymentType>THIRD_PARTY</ns:PaymentType>
	           <ns:Payor>
	           		<ns:ResponsibleParty>
			            <ns:AccountNumber>#trim(setting('accountNo'))#</ns:AccountNumber>
			            <ns:Contact>
			            	<ns:PersonName>#trim(setting('contactPersonName'))#</ns:PersonName>
			            	<ns:CompanyName>#trim(setting('contactCompany'))#</ns:CompanyName>
			            	<ns:PhoneNumber>#trim(setting('contactPhoneNumber'))#</ns:PhoneNumber>
		           		</ns:Contact>
		           		<ns:Address>
			            	<ns:StreetLines>#trim(setting('shipperStreet'))#</ns:StreetLines>
			                <ns:City>#trim(setting('shipperCity'))#</ns:City>
			                <ns:StateOrProvinceCode>#trim(setting('shipperStateCode'))#</ns:StateOrProvinceCode>
			                <ns:PostalCode>#trim(setting('shipperPostalCode'))#</ns:PostalCode>
			                <ns:CountryCode>#trim(setting('shipperCountryCode'))#</ns:CountryCode>
			            </ns:Address>
			        </ns:ResponsibleParty>
	           </ns:Payor>
           </ns:ShippingChargesPayment>
          
           
           <ns:LabelSpecification>
	           <ns:LabelFormatType>COMMON2D</ns:LabelFormatType>
	           <ns:ImageType>PDF</ns:ImageType>
	           <ns:LabelStockType>PAPER_4X6</ns:LabelStockType>
           </ns:LabelSpecification>
	        
	        <ns:RateRequestTypes>NONE</ns:RateRequestTypes>
	        <ns:PackageCount>1</ns:PackageCount>
	        
	        <ns:RequestedPackageLineItems>
	            <ns:SequenceNumber>1</ns:SequenceNumber>
	            <ns:InsuredValue>
	                <ns:Currency>USD</ns:Currency>
	                <ns:Amount>#arguments.requestBean.getTotalValue()#</ns:Amount>
	            </ns:InsuredValue>
	            <ns:Weight>
	                <ns:Units>LB</ns:Units>
	                <ns:Value>#arguments.requestBean.getTotalWeight( unitCode='lb' )#</ns:Value>
	            </ns:Weight>
	            <ns:Dimensions>
		            <ns:Length>1</ns:Length>
		            <ns:Width>1</ns:Width>
		            <ns:Height>1</ns:Height>
		            <ns:Units>IN</ns:Units>
	            </ns:Dimensions>
	            <ns:PhysicalPackaging>BOX</ns:PhysicalPackaging>
	        </ns:RequestedPackageLineItems>
	    </ns:RequestedShipment>
        
    </ns:ProcessShipmentRequest>
</cfoutput>
