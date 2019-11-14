/*

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

*/
component {
    
    property name="moMoneyBalance" persistent="false";
	property name="moMoneyWallet" fieldtype="boolean" persistent="false";
    
    public array function getPaymentMethodOptions() {
		if(!structKeyExists(variables, "paymentMethodOptions")) {
			var sl = getPaymentMethodOptionsSmartList();
			sl.addSelect('paymentMethodName', 'name');
			sl.addSelect('paymentMethodID', 'value');
			sl.addSelect('paymentMethodType', 'paymentmethodtype');
		    
		    //Restrict backend to add any external gateway as payment method	
			sl.addWhereCondition("paymentMethodType != 'external' ");
			
			variables.paymentMethodOptions = sl.getRecords();
			arrayPrepend(variables.paymentMethodOptions, {name=getHibachiScope().getRBKey("entity.accountPaymentMethod.paymentMethod.select"), value=""});
		}
		return variables.paymentMethodOptions;
	}
	
	public any function getMoMoneyWallet()
	{
	    if(!StructKeyExists(variables,"moMoneyWallet"))
	    {
	    	
	    	if(!isNull(getPaymentMethod()) && !isNull(getPaymentMethod().getPaymentIntegration()) && getPaymentMethod().getPaymentIntegration().getIntegrationPackage() == 'hyperwallet')
	        {
	            variables.moMoneyWallet =  true;
	        }
	        else{
	        	variables.moMoneyWallet =  false;
	        }
	    }
	    
	    return variables.moMoneyWallet;
	}
	
	public any function getMoMoneyBalance()
	{
		//always use getMoMoneyWallet check before getting the balance
	    if(!StructKeyExists(variables,"moMoneyBalance"))
	    {
	    	var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
	    	requestBean.setProviderToken(getProviderToken());
			requestBean.setTransactionType("balance");
			
	        var responseBean = getService('integrationService').getIntegrationByIntegrationPackage('hyperwallet').getIntegrationCFC("Payment").processExternal(requestBean);
	        if(!responseBean.hasErrors())
	        {
	        	variables.moMoneyBalance = responseBean.getAmountAuthorized();
	        }
	        else{
	        	//addErrors(responseBean.getErrors());
	        	getHibachiScope().addErrors(responseBean.getErrors());
	        	variables.moMoneyBalance = 0;
	        }
	    }
	    
	    return variables.moMoneyBalance;
	}
	
	public boolean function hasValidExpirationYear(){
		var currentYear = DatePart("yyyy", now());
		var expirationYear = getExpirationYear();
		
		if (expirationYear < currentYear){
			return false;
		}
		return true;
	}
	
	public any function hasValidExpirationMonth(){
		var currentYear = DatePart("yyyy", now());
		var currentMonth = DatePart("m", now());
		var expirationYear = getExpirationYear();
		var expirationMonth = getExpirationMonth();
		
		//make sure the month is not in the past if the year is this year.
		if (expirationYear == currentYear && expirationMonth < currentMonth){
			return false;
		}
		
		return true;
	}
}
