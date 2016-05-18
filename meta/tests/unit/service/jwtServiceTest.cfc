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
	public void function setUp() {
		super.setup();
		variables.service = request.slatwallScope.getService("HibachiJWTService");
		variables.key = "abcdefg";
		variables.jwt = variables.service.newJwt(key);
		variables.json = '{"ts":"February, 05 2014 12:08:05","userid":"jdoe","iat":"1456503640","exp":"14565027400"}';
		variables.payload = deserializeJSON(json);
		variables.jwt.setPayload(variables.payload);
		
		variables.testTokenInvalid = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0cyI6IkZlYnJ1YXJ5LCAwNSAyMDE0IDEyOjA4OjA1IiwidXNlcmlkIjoiamRvZSJ9.mL2-sQ2xeC4PidmV-uEvlINiI0mlpq5KRKsmO9EDTYx";
	
	}
	
	public void function setupTest(){
		addToDebug(variables.jwt);
	}
	
	
	public void function encodeTest(){

		var token = variables.jwt.encode(variables.payload);
		
		assert(listLen(token,".") eq 3);
	}

	public void function decodeTest(){
		
		var token = variables.jwt.encode(variables.payload);
		
		variables.jwt.setTokenString(token);
		
		var result = variables.jwt.decode();
		
	}

	public void function decodeInvalidSignitureTest(){
		variables.jwt.setTokenString(variables.testTokenInvalid);
		try{
			result = variables.jwt.decode();
		}catch(any e){
			assert(e.message == 'signature verification failed');
		}
	}

	public void function verifyTest(){
		var token = variables.jwt.encode(variables.payload);
		var result = variables.jwt.verify(token);
		
	}
	public void function verifyInvalidTokenTest(){
		
		var result = variables.jwt.verify(variables.testTokenInvalid);

		assert(result eq false);
	}
}
