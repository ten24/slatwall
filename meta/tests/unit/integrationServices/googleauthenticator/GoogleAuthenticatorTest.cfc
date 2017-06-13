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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
	
	public void function setUp() {
		super.setUp();
		
		variables.googleAuthenticator = new Slatwall.integrationServices.googleauthenticator.model.marcins.GoogleAuthenticator();
		
		// During development only
		variables.slatwallFW1Application.setBeanFactory(variables.slatwallFW1Application.getConfiguredBeanFactoryInstance());
		variables.integrationService =  request.slatwallScope.getBean("integrationService");
	}
	
	/**
	* @test
	*/
	public void function create_java_loader_instance() {
		// Resource Links
		// Algorithm - Github Repo - https://github.com/marcins/cf-google-authenticator
		// Algorithm - http://junkheap.net/blog/2013/05/30/implementing-google-authenticator-support-in-coldfusion/
		// Base32 Library - Google - https://google.github.io/guava/releases/20.0/api/docs/index.html?com/google/common/io/BaseEncoding.html
		// Base32 Library - Apache Commons - https://commons.apache.org/proper/commons-codec/apidocs/index.html?org/apache/commons/codec/binary/Base32.html
		
		//writeDump(variables.integrationService.getIntegrationByIntegrationPackage("googleauthenticator"));
		//var commonsLoader = variables.hibachiUtilityService.loadApacheCommonsCodec();
		//var guavaLoader = variables.hibachiUtilityService.loadGuava();
		//var base32 = commonsLoader.create("org.apache.commons.codec.binary.Base32");
		//var value = "this is the message to encode as base 32";
		//value.toString();
		//base32.encodeToString(value.getBytes());
		//writeDump(base32.encodeToString(value.getBytes()));
		//writeDump(base32.encodeAsString(value.getBytes()));
		//writeDump(value.getClass());
		//value
		//writeDump(("yoddle").getBytes());
		//writeDump(toBinary(b64));
		//binaryEncode(binarydata,encoding);
		//writeDump(binaryDecode("this is the message","hex"));
		//writeDump(toBinary(binaryDecode("this is my message", "base64")));
		//writeDump(base32.encodeAsString("Hello this is todd"));
		//writeDump(variables["hibachiUtilityService"]);
		//writeDump(variables.hibachiUtilityService);
		//debug(structKeyArray(request));
		//debug(structKeyArray(application));
		//debug(variables.hibachiUtilityService);
		//
		//variables.hibachiUtilityService
		
	}
	
	/**
	* @test
	*/
	public void function generateKey_basic ()
	{
		var key = googleAuthenticator.generateKey("blah");
		assertEquals(16, len(key));
	}
	
	/**
	* @test
	*/
	public void function generateKey_custom_salt()
	{
		var badSalt = javaCast("byte[]", [0, 0]);
		try
		{
			var key = googleAuthenticator.generateKey("blah", badSalt);
			assertFail("Should not get here");
		}
		catch(any e)
		{
			assertEquals("GoogleAuthenticator.BadSalt", e.errorCode);
		}
		
		var goodSalt = charsetDecode("1234567890123456", "utf-8");
		var key = googleAuthenticator.generateKey("password", goodSalt);
		assertEquals("D5NJOIFNXEB4DL7M", key);
	}
	
	private numeric function returnTimeZero()
	{
		return 0;
	}
	
	private numeric function returnTimeKnown()
	{
		return 1000;
	}
	
	/**
	* @test
	*/
	public void function getOneTimeToken()
	{
		var token = googleAuthenticator.getOneTimeToken("D5NJOIFNXEB4DL7M", 0);
		assertEquals("731217", token);
	}
	
	/**
	* @test
	*/
	public void function getGoogleToken()
	{
		injectMethod(googleAuthenticator, this, "returnTimeZero", "getCurrentTime");
		var token = googleAuthenticator.getGoogleToken("D5NJOIFNXEB4DL7M");
		assertEquals("731217", token);
	}
	
	/**
	* @test
	*/
	public void function verifyGoogleToken()
	{
		injectMethod(googleAuthenticator, this, "returnTimeZero", "getCurrentTime");
		assertFalse(googleAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "000000", 0), 
	             "Expected invalid value to fail");
		assertTrue(googleAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "731217", 0), 
	            "Expected known value to succeed");
		assertFalse(googleAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "434975", 0), 
	             "Expected last value to fail with no grace");
		assertTrue(googleAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "434975", 1), 
	            "Expected last value to succeed with grace");
		assertTrue(googleAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "434975", 2), 
	            "Expected last value to succeed with excess grace");
	}
	
	/**
	* @test
	*/
	public void function getOTPURL()
	{
		assertEquals("otpauth://totp/test@example.com?secret=D5NJOIFNXEB4DL7M", 
	              googleAuthenticator.getOTPURL("test@example.com", "D5NJOIFNXEB4DL7M"));
	}
	
	/**
	* @test
	*/
	public void function base32decodeString()
	{
		assertEquals("", googleAuthenticator.base32decodeString(""));
		assertEquals("f", googleAuthenticator.base32decodeString("MY======"));
		assertEquals("fo", googleAuthenticator.base32decodeString("MZXQ===="));
		assertEquals("foo", googleAuthenticator.base32decodeString("MZXW6==="));
		assertEquals("foob", googleAuthenticator.base32decodeString("MZXW6YQ="));
		assertEquals("fooba", googleAuthenticator.base32decodeString("MZXW6YTB"));
		assertEquals("foobar", googleAuthenticator.base32decodeString("MZXW6YTBOI======"));
	}
	
	/**
	* @test
	*/
	public void function base32encodeString()
	{
		assertEquals("", googleAuthenticator.base32encodeString(""));
		assertEquals("MY======", googleAuthenticator.base32encodeString("f"));
		assertEquals("MZXQ====", googleAuthenticator.base32encodeString("fo"));
		assertEquals("MZXW6===", googleAuthenticator.base32encodeString("foo"));
		assertEquals("MZXW6YQ=", googleAuthenticator.base32encodeString("foob"));
		assertEquals("MZXW6YTB", googleAuthenticator.base32encodeString("fooba"));
		assertEquals("MZXW6YTBOI======", googleAuthenticator.base32encodeString("foobar"));
	}
	
	/**
	* @test
	*/
	public void function base32encode_edge()
	{
		var bytes = javaCast("byte[]", [0, 0, 0, 0, 0]);
		assertEquals("AAAAAAAA", googleAuthenticator.base32encode(bytes));
	}
	
	/**
	* @test
	*/
	public void function base32decode_edge()
	{
		var dec = googleAuthenticator.base32decode("AAAAAAAA");
		assertEquals(5, arrayLen(dec));
		for(var i = 1; i <= 5; i++)
		{
			assertEquals(0, dec[i]);
		}
	}
}