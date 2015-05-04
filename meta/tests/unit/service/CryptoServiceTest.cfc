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
component  extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" hint="Tests that the crypto for comparing signatures for API are valid."
{
	/**
	 * On setup, grab the crypto service
	 */
	public void function setUp() {
		super.setup();
		variables.crypto = request.slatwallScope.getBean("cryptoService");
		variables.key = "A1E4E94C-D2A6-3462-235FFD1EF3339E0C";
		variables.keyBase64 = "QTFFNEU5NEMtRDJBNi0zNDYyLTIzNUZGRDFFRjMzMzlFMEM=";//This is the clients secret key
		variables.userID = "4028818d4b05b871014b102d388a00db";//This is the clients userid
		variables.timestamp = Now();//This is the coldfusion time now.
		variables.unixTime = DateDiff("s", CreateDate(1970,1,1), variables.timestamp);//This is the unix version of the coldfusion time.
		variables.oldTimestamp = "1430467282";//This is an oldtimestamp for testing purposes.
		variables.keySignature = "A1E4E94C-D2A6-3462-235FFD1EF3339E0C NDIyNEYzODJCRjQ0NjI2MjJCNDY4QTM0NjQwRDQyODE0MzU4MDk3Rg== A1E4E94C-D2A6-3462-235FFD1EF3339E0C";
		//variables.unixTime = 1430642944 ;
		variables.timeUserKey = "1430739219589_4028818d4b05b871014b102d388a00db_QTFFNEU5NEMtRDJBNi0zNDYyLTIzNUZGRDFFRjMzMzlFMEM=";
	}
	
	public void function encodeAndDecode_Base64_Test(){
		variables.key = variables.crypto.encode_Base64(variables.key);
		request.debug(variables.key);
		var result = variables.crypto.decode_Base64(variables.key);
		request.debug(result);
		request.debug("Decoding the signature: ");
		request.debug("#variables.crypto.decode_Base64('ZDEyMzJhZmZhYzg4MTRmNzY3YjNjY2Y5YTRlMTQ1Zjg5MTQxMDE2NQ==')#");
	}
	
	public void function checkTimestampIsNotExpired(){
		//var result = crypto.checkTimestamp(variables.unixTime);
		//assertEquals(result, true);//Should be less than three minutes old.
		request.debug(variables.unixTime);
		
		request.debug(variables.oldTimestamp);
		request.debug(ABS(variables.unixTime - variables.oldTimestamp));
				
		assertEquals(crypto.checkTimestampIsValid(variables.oldTimestamp), false); //Should fail due to being more than three minutes old. > 180
		assertEquals(crypto.checkTimestampIsValid(variables.unixTime), true); //Should be less than 180
		
	}
	
	public void function hmac_sha1_Test(){
		//request.debug(variables.key);
		//request.debug(crypto.hmac_sha1(variables.key));
		//var compare = (variables.key == crypto.hmac_sha1(variables.key));
		//assertEquals(compare, false);
		request.debug("Time User Key: #variables.timeUserKey#");
		var hashed = crypto.hmac_sha1(variables.timeUserKey);
		request.debug("Hashed Version: #hashed#");
		var final = variables.crypto.encode_Base64(ucase(hashed));
		request.debug("Binary Version: #final#");//<---this is not matching javascript.
	}
	/**
	 * Create signature looks up the account by uid and finds the tokens on that account.
			If the token passed in as base64 key, matches the account,
			and if the timestamp is not expired,
			and if the signature created based on that information, matches the signature passed in,
			then this account is validated.
	 */
	public void function createSignature_andTest(){
		//The line below is simulating the signature that would be sent from the client.
		var signature = crypto.createSignature(variables.keyBase64, variables.userID, variables.unixTime);
		request.debug("Client Signature is: " & signature);
		
		//The result simulated the checking of that signature based on internal server data against that signature passed in.
		var result = crypto.isValidSignature(variables.keyBase64, variables.userID, variables.unixTime, signature);
		request.debug(result);
		assertEquals(result, true);
	}
	
}