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
        xsi:schemaLocation="http://www.fedex.com/templates/components/apps/wpor/secure/downloads/xml/Aug09/Advanced/ShipService_v7.xsd"
        xmlns:ns="http://fedex.com/ws/ship/v7"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        
        <ns:WebAuthenticationDetail>
            <ns:UserCredential>
            <ns:Key>2O9ZGgXSHFgJhJdr</ns:Key>
            <ns:Password>X87qtei798zz58VktqKOjSxsk</ns:Password>
            </ns:UserCredential>
        </ns:WebAuthenticationDetail>
    
        <ns:ClientDetail>
            <ns:AccountNumber>510087585</ns:AccountNumber>
            <ns:MeterNumber>118724670</ns:MeterNumber>
        </ns:ClientDetail>
          
        <ns:TransactionDetail>
           <ns:CustomerTransactionId>1111</ns:CustomerTransactionId>
        </ns:TransactionDetail>
       
        <ns:Version>
           <ns:ServiceId>ship</ns:ServiceId>
           <ns:Major>7</ns:Major>
           <ns:Intermediate>0</ns:Intermediate>
           <ns:Minor>0</ns:Minor>
        </ns:Version>
        <ns:RequestedShipment>
           <ns:ShipTimestamp>2016-05-13T11:11:11</ns:ShipTimestamp>
           <ns:DropoffType>REGULAR_PICKUP</ns:DropoffType>
           <ns:ServiceType>STANDARD_OVERNIGHT</ns:ServiceType>
           <ns:PackagingType>YOUR_PACKAGING</ns:PackagingType>
           <ns:Shipper>
           <ns:Contact>
	            <ns:PersonName>Ryan</ns:PersonName>
	            <ns:CompanyName>ten24web</ns:CompanyName>
	            <ns:PhoneNumber>5086997336</ns:PhoneNumber>
           </ns:Contact>
           <ns:Address>
	            <ns:StreetLines>90 Bank st</ns:StreetLines>
	            
	            <ns:City>Bank st</ns:City>
	            <ns:StateOrProvinceCode>MA</ns:StateOrProvinceCode>
	            <ns:PostalCode>02760</ns:PostalCode>
	            <ns:CountryCode>US</ns:CountryCode>
	            <ns:Residential>false</ns:Residential>
           </ns:Address>
           </ns:Shipper>
           <ns:Recipient>
	           <ns:Contact>
		            <ns:PersonName>Ryan</ns:PersonName>
		            
		            <ns:CompanyName>ten24web</ns:CompanyName>
		            
		            <ns:PhoneNumber>5086997336</ns:PhoneNumber>
	           </ns:Contact>
	           <ns:Address>
		            <ns:StreetLines>90 bank st</ns:StreetLines>
		            
		            <ns:City>North Attleboro</ns:City>
		            <ns:StateOrProvinceCode>MA</ns:StateOrProvinceCode>
		            <ns:PostalCode>02760</ns:PostalCode>
		            <ns:CountryCode>US</ns:CountryCode>
		            <ns:Residential>false</ns:Residential>
	           </ns:Address>
           </ns:Recipient>
       
           <ns:ShippingChargesPayment>
	           <ns:PaymentType>THIRD_PARTY</ns:PaymentType>
	           <ns:Payor>
	            <ns:AccountNumber>510087585</ns:AccountNumber>
	            <ns:CountryCode>US</ns:CountryCode>
	           </ns:Payor>
           </ns:ShippingChargesPayment>
          
           
           <ns:LabelSpecification>
	           <ns:LabelFormatType>COMMON2D</ns:LabelFormatType>
	           <ns:ImageType>PDF</ns:ImageType>
	           <ns:LabelStockType>PAPER_4X6</ns:LabelStockType>
           </ns:LabelSpecification>
           
           <ns:RateRequestTypes>ACCOUNT</ns:RateRequestTypes>
           
           <ns:PackageCount>1</ns:PackageCount>
           <ns:PackageDetail>INDIVIDUAL_PACKAGES</ns:PackageDetail>
           <ns:RequestedPackageLineItems>
	           <ns:SequenceNumber>1</ns:SequenceNumber>
	           <ns:Weight>
	            <ns:Units>LB</ns:Units>
	            <ns:Value>1</ns:Value>
	           </ns:Weight>
	           <ns:Dimensions>
	            <ns:Length>1</ns:Length>
	            <ns:Width>1</ns:Width>
	            <ns:Height>1</ns:Height>
	            <ns:Units>IN</ns:Units>
	           </ns:Dimensions>
	           <ns:PhysicalPackaging>BOX</ns:PhysicalPackaging>
	       
	           <ns:CustomerReferences>
		           <ns:CustomerReferenceType>INVOICE_NUMBER</ns:CustomerReferenceType>
		           <ns:Value>1</ns:Value>
	           </ns:CustomerReferences>
           
           </ns:RequestedPackageLineItems>
        </ns:RequestedShipment>
    </ns:ProcessShipmentRequest>
</cfoutput>
