<!---

    Slatwall - An Open Source eCommerce Platform
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
<?xml version="1.0" encoding="UTF-8"?>
<cfoutput>
<Request>
	<Profile>
		<OrbitalConnectionUsername>#setting('username')#</OrbitalConnectionUsername>
		<OrbitalConnectionPassword>#setting('password')#</OrbitalConnectionPassword>
		<CustomerBin>#setting('bin')#</CustomerBin>
		<CustomerMerchantID>#getMerchantIDByCurrencyCode( arguments.requestBean.getTransactionCurrencyCode() )#</CustomerMerchantID>
		<CustomerName>#arguments.requestBean.getNameOnCreditCard()#</CustomerName>
		<cfif !isNull(arguments.requestBean.getOrderPayment())>
			<CustomerRefNum>#arguments.requestBean.getOrderPayment().getShortReferenceID( true )#</CustomerRefNum>
		<cfelseif !isNull(arguments.requestBean.getAccountPayment())>
			<CustomerRefNum>#arguments.requestBean.getAccountPayment().getShortReferenceID( true )#</CustomerRefNum>
		<cfelseif !isNull(arguments.requestBean.getAccountPaymentMethod())>
			<CustomerRefNum>#arguments.requestBean.getAccountPaymentMethod().getShortReferenceID( true )#</CustomerRefNum>
		</cfif>
		<CustomerAddress1>#arguments.requestBean.getBillingStreetAddress()#</CustomerAddress1>
		<CustomerAddress2>#arguments.requestBean.getBillingStreet2Address()#</CustomerAddress2>
		<CustomerCity>#arguments.requestBean.getBillingCity()#</CustomerCity>
		<cfif len(arguments.requestBean.getBillingStateCode()) lte 2>
			<CustomerState>#arguments.requestBean.getBillingStateCode()#</CustomerState>
		<cfelse>
			<CustomerState></CustomerState>
		</cfif>
		<CustomerZIP>#arguments.requestBean.getBillingPostalCode()#</CustomerZIP>
		<CustomerEmail>#arguments.requestBean.getAccountPrimaryEmailAddress()#</CustomerEmail>
		<CustomerPhone>#arguments.requestBean.getAccountPrimaryPhoneNumber()#</CustomerPhone>
		<CustomerCountryCode>#arguments.requestBean.getBillingCountryCode()#</CustomerCountryCode>
		<CustomerProfileAction>C</CustomerProfileAction>
		<CustomerProfileOrderOverrideInd>NO</CustomerProfileOrderOverrideInd>
		<CustomerProfileFromOrderInd>A</CustomerProfileFromOrderInd>
		<CustomerAccountType>CC</CustomerAccountType>
		<Status>A</Status>
		<CCAccountNum>#arguments.requestBean.getCreditCardNumber()#</CCAccountNum>
		<cfif !isNull(arguments.requestBean.getExpirationMonth()) && !isNull(arguments.requestBean.getExpirationYear())>
			<CCExpireDate>#left(arguments.requestBean.getExpirationMonth(),2)##right(arguments.requestBean.getExpirationYear(),2)#</CCExpireDate>
		<cfelse>
			<CCExpireDate/>
		</cfif>
	</Profile>
</Request>
</cfoutput>
