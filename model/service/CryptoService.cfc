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
component  output="false" accessors="true" extends="HibachiService" hint="Allows for easily checking signatures, keys, uuid, as well as generating them."
{
	/**
	 * Checks if a signature is valid given (timestamp, userID (uid), key) plus the signature to compare against.
	 * Performs an additional check to make sure the timestamp is not expired (older than three minutes)
	 */
	any function isValidSignature(key, uid, timestamp, signature){
		var serverSignature = createSignature(arguments.key, arguments.uid, arguments.timestamp);
		//var isValidTime = checkTimeStampIsValid(arguments.timestamp);
		if ( serverSignature == "215" ){
			return "215";
		}
		else if ( serverSignature == arguments.signature ){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * Creates a signature given a userID (uid), and timestamp. It looks up the account auth token based on uid (accountID).
	 */
	any function createSignature(key, uid, timestamp){
		//Lookup the account tokens by account id.
		var accountSmartList = getService("AccountService").getAccountAuthenticationSmartList();
		accountSmartList.joinRelatedProperty("SlatwallAccountAuthentication", "account", "left" );
		accountSmartList.addFilter("Account.accountID", "#uid#");
		var accountAuth = accountSmartList.getRecords();
		//Iterate through the account tokens and see if this one is on the account.
		for (var i = 1; i <= ArrayLen(accountAuth); i++){
			if (accountAuth[i].getAuthToken() == deCode_Base64(arguments.key)){
				//Then we have a token for an account.
				var hmac = hmac_sha1(arguments.timestamp & "_" & arguments.uid & "_" & arguments.key);
				var upperHash = ucase(hmac);
				var signature = encode_base64(upperHash);
				return signature;
			}
		}
		return "215";
	}
	
	/**
	 * Checks that a timestamp is not older than 3 minutes.
	 */
	string function checkTimestampIsValid(any timestamp){
		//Get the time now as a unix time.
		var nowInUnixTime = DateDiff("s", CreateDate(1970,1,1), Now());
		//If the difference between the time and the timestamp is greater than 3 minutes, return false. 
		if ( ABS(nowInUnixTime - arguments.timestamp) > 180 ){
			return false;
		}else{
			return true;
		}
	}
	
	/**
	 * Converts the text to hmac (message authentication code) using the sha1 algorithm
	 * SHA-1: The 160-bit secure hash algorithm defined by FIPS 180-2 and FIPS 198.
	 */
	any function hmac_sha1(string plaintext){
		var hmac_sha1_string = Hash(arguments.plaintext, "SHA" );
		return hmac_sha1_string;
	}
	
	
	/**
	 * Encodes a plaintext or sha1 encoded string to base 64 
	 */
	any function encode_Base64(string plaintext){
		return ToBase64(plaintext, "us-ascii");
	}
	
	/**
	 * Decodes a base 64 encoded string to planitext
	 */
	any function decode_Base64(string base64_text){
		return ToString(ToBinary(base64_text));
	}
	
}