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

component displayname="Gateway Response"  accessors="true" output="false" extends="Slatwall.model.transient.ResponseBean" {

	property name="providerTransactionID" type="string";
	property name="providerToken" type="string";   
	property name="authorizationCode" type="string";
	property name="authorizationCodeUsed" type="string";
	property name="authorizationCodeInvalidFlag" type="boolean";
	property name="amountAuthorized" type="numeric";
	property name="amountReceived" type="numeric";
	property name="amountCredited" type="numeric";
	property name="avsCode" type="string";
	property name="securityCodeMatchFlag" type="boolean";
	property name="duplicateFlag" type="boolean";
	
	// DEPRECATED
	property name="transactionID" type="string";	// Use: ProviderTransactionID
	
	public function init(){
		// Set Defaults
		setTransactionID("");
		setAuthorizationCode("");
		setAuthorizationCodeUsed("");
		setAuthorizationCodeInvalidFlag(false);
		setAmountAuthorized(0);
		setAmountReceived(0);
		setAmountCredited(0);
		setAVSCode("E");
		setSecurityCodeMatchFlag(false);
		setProviderToken("");
		
		return super.init();
	}
	
	// DEPRECATED - Use provider transactionID
	public void function setTransactionID( required string transactionID ) {
		variables.transactionID = arguments.transactionID;
		setProviderTransactionID( arguments.transactionID );
	}
	
	public string function setAVSCode(required string avsCode){
		if(structKeyExists(getAVSCodes(), arguments.avsCode)){
			variables.AVSCode = arguments.avsCode;
		} else {
			throw("The AVS Code that was set is not supported by Slatwall.  Please check the documentation for valid AVSCodes");
		}
	}
	
	public struct function getAVSCodes(){
		var allowedAVSCodes = {
			A = "Street address matches, but 5-digit and 9-digit postal code do not match.",	
			B = "Street address matches, but postal code not verified."	,
			C = "Street address and postal code do not match.",
			D = "Street address and postal code match. Code M is equivalent.",
			E = "AVS data is invalid or AVS is not allowed for this card type.",
			F = "Card member's name does not match, but billing postal code matches.",
			G = "Non-U.S. issuing bank does not support AVS.",
			H = "Card member's name does not match. Street address and postal code match.",
			I = "Standard international",
			J = "Card member's name, billing address, and postal code match.",
			K = "Card member's name matches but billing address and billing postal code do not match.",
			L = "Card member's name and billing postal code match, but billing address does not match.",	
			M = "Street address and postal code match. Code D is equivalent.",
			N = "Street address and postal code do not match.",
			O = "Card member's name and billing address match, but billing postal code does not match.",
			P = "Postal code matches, but street address not verified.",
			Q = "Card member's name, billing address, and postal code match.",
			R = "System unavailable.",
			S = "Bank does not support AVS.",
			T = "Card member's name does not match, but street address matches.",
			U = "Address information unavailable. Returned if the U.S. bank does not support non-U.S. AVS or if the AVS in a U.S. bank is not functioning properly.",
			V = "Card member's name, billing address, and billing postal code match.",
			W = "Street address does not match, but 9-digit postal code matches.",
			X = "Street address and 9-digit postal code match.",
			Y = "Street address and 5-digit postal code match.",
			Z = "Street address does not match, but 5-digit postal code matches."
		
		};
		
		return allowedAVSCodes;
	}
	
	/*
	AVS Code List
	A	Standard domestic		Street address matches, but 5-digit and 9-digit postal code do not match.	
	B	Standard international	Street address matches, but postal code not verified.	
	C	Standard international	Street address and postal code do not match.
	D	Standard international	Street address and postal code match. Code "M" is equivalent.	
	E	Standard domestic		AVS data is invalid or AVS is not allowed for this card type.
	F	American Express only	Card member's name does not match, but billing postal code matches.
	G	Standard international	Non-U.S. issuing bank does not support AVS.
	H	American Express only	Card member's name does not match. Street address and postal code match.
	I	Standard international	Address not verified.	
	J	American Express only	Card member's name, billing address, and postal code match.
	K	American Express only	Card member's name matches but billing address and billing postal code do not match.
	L	American Express only	Card member's name and billing postal code match, but billing address does not match.	
	M	Standard international	Street address and postal code match. Code "D" is equivalent.
	N	Standard domestic		Street address and postal code do not match.
	O	American Express only	Card member's name and billing address match, but billing postal code does not match.
	P	Standard international	Postal code matches, but street address not verified.
	Q	American Express only	Card member's name, billing address, and postal code match.
	R	Standard domestic		System unavailable.
	S	Standard domestic		Bank does not support AVS.
	T	American Express only	Card member's name does not match, but street address matches.
	U	Standard domestic		Address information unavailable. Returned if the U.S. bank does not support non-U.S. AVS or if the AVS in a U.S. bank is not functioning properly.
	V	American Express only	Card member's name, billing address, and billing postal code match.
	W	Standard domestic		Street address does not match, but 9-digit postal code matches.
	X	Standard domestic		Street address and 9-digit postal code match.
	Y	Standard domestic		Street address and 5-digit postal code match.
	Z	Standard domestic		Street address does not match, but 5-digit postal code matches.
	*/
	
}
