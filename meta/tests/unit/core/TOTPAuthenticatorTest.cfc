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
		
		variables.totpAuthenticator = new Slatwall.org.Hibachi.marcins.TOTPAuthenticator();
		
		// During development only
		//variables.slatwallFW1Application.setBeanFactory(variables.slatwallFW1Application.getConfiguredBeanFactoryInstance());
		variables.integrationService = variables.mockService.getIntegrationServiceMock();
	}
	
	/**
	* @test
	*/
	public void function generateKey_basic ()
	{
		var key = totpAuthenticator.generateKey("blah");
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
			var key = totpAuthenticator.generateKey("blah", badSalt);
			assertFail("Should not get here");
		}
		catch(any e)
		{
			assertEquals("GoogleAuthenticator.BadSalt", e.errorCode);
		}
		
		var goodSalt = charsetDecode("1234567890123456", "utf-8");
		var key = totpAuthenticator.generateKey("password", goodSalt);
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
		var token = totpAuthenticator.getOneTimeToken("D5NJOIFNXEB4DL7M", 0);
		assertEquals("731217", token);
	}
	
	/**
	* @test
	*/
	public void function getGoogleToken()
	{
		injectMethod(totpAuthenticator, this, "returnTimeZero", "getCurrentTime");
		var token = totpAuthenticator.getGoogleToken("D5NJOIFNXEB4DL7M");
		assertEquals("731217", token);
	}
	
	/**
	* @test
	*/
	public void function verifyGoogleToken()
	{
		injectMethod(totpAuthenticator, this, "returnTimeZero", "getCurrentTime");
		assertFalse(totpAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "000000", 0), 
	             "Expected invalid value to fail");
		assertTrue(totpAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "731217", 0), 
	            "Expected known value to succeed");
		assertFalse(totpAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "434975", 0), 
	             "Expected last value to fail with no grace");
		assertTrue(totpAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "434975", 1), 
	            "Expected last value to succeed with grace");
		assertTrue(totpAuthenticator.verifyGoogleToken("D5NJOIFNXEB4DL7M", "434975", 2), 
	            "Expected last value to succeed with excess grace");
	}
	
	/**
	* @test
	*/
	public void function getOTPURL()
	{
		assertEquals("otpauth://totp/test@example.com?secret=D5NJOIFNXEB4DL7M", 
	              totpAuthenticator.getOTPURL("test@example.com", "D5NJOIFNXEB4DL7M"));
	}
	
	/**
	* @test
	*/
	public void function base32decodeString()
	{
		assertEquals("", totpAuthenticator.base32decodeString(""));
		assertEquals("f", totpAuthenticator.base32decodeString("MY======"));
		assertEquals("fo", totpAuthenticator.base32decodeString("MZXQ===="));
		assertEquals("foo", totpAuthenticator.base32decodeString("MZXW6==="));
		assertEquals("foob", totpAuthenticator.base32decodeString("MZXW6YQ="));
		assertEquals("fooba", totpAuthenticator.base32decodeString("MZXW6YTB"));
		assertEquals("foobar", totpAuthenticator.base32decodeString("MZXW6YTBOI======"));
	}
	
	/**
	* @test
	*/
	public void function base32encodeString()
	{
		assertEquals("", totpAuthenticator.base32encodeString(""));
		assertEquals("MY======", totpAuthenticator.base32encodeString("f"));
		assertEquals("MZXQ====", totpAuthenticator.base32encodeString("fo"));
		assertEquals("MZXW6===", totpAuthenticator.base32encodeString("foo"));
		assertEquals("MZXW6YQ=", totpAuthenticator.base32encodeString("foob"));
		assertEquals("MZXW6YTB", totpAuthenticator.base32encodeString("fooba"));
		assertEquals("MZXW6YTBOI======", totpAuthenticator.base32encodeString("foobar"));
	}
	
	/**
	* @test
	*/
	public void function base32encode_edge()
	{
		var bytes = javaCast("byte[]", [0, 0, 0, 0, 0]);
		assertEquals("AAAAAAAA", totpAuthenticator.base32encode(bytes));
	}
	
	/**
	* @test
	*/
	public void function base32decode_edge()
	{
		var dec = totpAuthenticator.base32decode("AAAAAAAA");
		assertEquals(5, arrayLen(dec));
		for(var i = 1; i <= 5; i++)
		{
			assertEquals(0, dec[i]);
		}
	}
}