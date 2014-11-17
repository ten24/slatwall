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
		super.setup();
		
		variables.service = request.slatwallScope.getService("hibachiRBService");
	}
	
	// getRBKey()
	public void function getRBKey_default() {
		assertEquals("all", variables.service.getRBKey('define.all'));
	}
	
	public void function getRBKey_en() {
		assertEquals("all", variables.service.getRBKey('define.all', 'en'));
	}
	
	public void function getRBKey_en_fully_qualified() {
		assertEquals("all", variables.service.getRBKey('define.all', 'en_us'));
	}
	
	public void function getRBKey_fully_qualified_local_missing_shows_both_tried() {
		assertEquals("define.aaa_en_us_missing,define.aaa_en_missing", variables.service.getRBKey('define.aaa', 'en_us'));
	}
	
	public void function getRBKey_step_down_define_works_when_key_not_found() {
		assertEquals("aaa.bbb.ccc.ddd_en_us_missing,aaa.bbb.ccc.ddd_en_missing,aaa.bbb.define.ddd_en_us_missing,aaa.bbb.define.ddd_en_missing,aaa.define.ddd_en_us_missing,aaa.define.ddd_en_missing,define.ddd_en_us_missing,define.ddd_en_missing", variables.service.getRBKey('aaa.bbb.ccc.ddd', 'en_us'));
	}
	
	public void function getRBKey_another_language_besides_english_works() {
		assertEquals("Tout", variables.service.getRBKey('define.all', 'fr'));
	}
	
	public void function getRBKey_another_language_besides_english_works_with_fully_qualified_locale() {
		assertEquals("Tout", variables.service.getRBKey('define.all', 'fr_fr'));
	}
	
	// getResourceBundle()
	public void function getResourceBundle_en() {
		assert(structCount(variables.service.getResourceBundle('en')) gt 1);
	}
}


