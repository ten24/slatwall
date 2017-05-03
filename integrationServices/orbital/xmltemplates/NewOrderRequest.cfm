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
<?xml version="1.0" encoding="UTF-8"?>
<cfoutput>
<Request>
	<NewOrder>
		<OrbitalConnectionUsername>#setting('username')#</OrbitalConnectionUsername>
		<OrbitalConnectionPassword>#setting('password')#</OrbitalConnectionPassword>
		<IndustryType>#setting('industryType')#</IndustryType>
		<MessageType>#variables.transactionCodes[arguments.requestBean.getTransactionType()]#</MessageType>
		<BIN>#setting('bin')#</BIN>
		<MerchantID>#getMerchantIDByCurrencyCode( arguments.requestBean.getTransactionCurrencyCode() )#</MerchantID>
		<TerminalID>#setting('terminalID')#</TerminalID>
		<CardBrand></CardBrand>
		<cfif !isNull(arguments.requestBean.getCreditCardNumber())>
			<AccountNum>#arguments.requestBean.getCreditCardNumber()#</AccountNum>
		<cfelse>
			<AccountNum />
		</cfif>
		<cfif !isNull(arguments.requestBean.getExpirationMonth()) && !isNull(arguments.requestBean.getExpirationYear())>
			<Exp>#left(arguments.requestBean.getExpirationMonth(),2)##right(arguments.requestBean.getExpirationYear(),2)#</Exp>
		<cfelse>
			<Exp/>
		</cfif>
		<CurrencyCode>#arguments.requestBean.getTransactionCurrencyISONumber()#</CurrencyCode>
		<CurrencyExponent>2</CurrencyExponent>
		<cfif !isNull(requestBean.getSecurityCode())>
			<CardSecValInd>1</CardSecValInd>
			<CardSecVal>#arguments.requestBean.getSecurityCode()#</CardSecVal>
		</cfif>
		<cfif listFindNoCase("US,CA,GB,UK", arguments.requestBean.getBillingCountryCode())>
			<AVSzip>#arguments.requestBean.getBillingPostalCode()#</AVSzip>
			<cfset fullAddress = arguments.requestBean.getBillingStreetAddress() />
			<cfif !isNull(arguments.requestBean.getBillingStreet2Address())> 
				<cfset fullAddress = fullAddress & " " & arguments.requestBean.getBillingStreet2Address() />
			</cfif>
			<AVSaddress1>#left(fullAddress, 30)#</AVSaddress1>
			<AVScity>#arguments.requestBean.getBillingCity()#</AVScity>
			<cfif len(arguments.requestBean.getBillingStateCode()) lte 2>
				<AVSstate>#arguments.requestBean.getBillingStateCode()#</AVSstate>
			<cfelse>
				<AVSstate></AVSstate>
			</cfif>
			<AVSphoneNum>#arguments.requestBean.getAccountPrimaryPhoneNumber()#</AVSphoneNum>
			<AVSname>#arguments.requestBean.getNameOnCreditCard()#</AVSname>
			<AVScountryCode>#arguments.requestBean.getBillingCountryCode()#</AVScountryCode>
		</cfif>
		<cfif isNull(arguments.requestBean.getCreditCardNumber())>
			<CustomerRefNum>#arguments.requestBean.getProviderToken()#</CustomerRefNum>
		</cfif>
		<OrderID>#arguments.requestBean.getOrder().getShortReferenceID( true )#</OrderID>
		<Amount>#getHibachiScope().getService('HibachiUtilityService').precisionCalculate(numberFormat(arguments.requestBean.getTransactionAmount(),'.00')*100)#</Amount>
		<cfif arguments.requestBean.getTransactionType() EQ "credit">
			<TxRefNum>#arguments.requestBean.getOriginalChargeProviderTransactionID()#</TxRefNum>
		</cfif>
		<CustomerEmail>#arguments.requestBean.getAccountPrimaryEmailAddress()#</CustomerEmail>
		<CustomerIpAddress>#CGI.REMOTE_ADDR#</CustomerIpAddress>
	</NewOrder>
</Request>
</cfoutput>
