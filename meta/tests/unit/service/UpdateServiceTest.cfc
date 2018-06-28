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

		//variables.service = request.slatwallScope.getService("updateService");
		variables.service = variables.mockService.getUpdateServiceMock();

		var filePathWith = expandPath('/Slatwall')&"/meta/tests/unit/resources/updateService/AccountWithoutCustomProperties.txt";
		variables.fileContentForAccountWithoutCustomPropeties = fileRead(filePathWith);


		var filePathWithout = expandPath('/Slatwall')&"/meta/tests/unit/resources/updateService/AccountWithCustomProperties.txt";
		variables.fileContentForAccountWithCustomPropeties = fileRead(filePathWithout);

		var customFilePath = expandPath('/Slatwall')&"/meta/tests/unit/resources/updateService/customProperties.txt";
		variables.customFileContent = fileRead(customFilePath);

	}

	/**
	* @test
	*/
	public void function updateCMSApplicationsTest(){
		variables.service.updateCMSApplications();
	}
	/**
	* @test
	*/
	public void function allScriptsSucceededTest(){
		//these scripts should have already run when the system boots and we are just checking them in the db to see that they succeeded
		var updateScripts = variables.service.listUpdateScript();
		for(var updateScript in updateScripts){
			assert(updateScript.getSuccessfulExecutionCount() > 0,'script: #updateScript.getscriptPath()# failed');
		}
	}

	/**
	* @test
	*/
	public void function mergeEntityParsersTest_withoutCustomPropertiesInitially(){

		var coreEntityParser = variables.mockService.getHibachiEntityParserTransientMock(); // request.slatwallScope.getTransient('hibachiEntityParser');

		coreEntityParser.setFileContent(variables.fileContentForAccountWithoutCustomPropeties);

		var customEntityParser = variables.mockService.getHibachiEntityParserTransientMock(); //request.slatwallScope.getTransient('hibachiEntityParser');
		customEntityParser.setFileContent(variables.customFileContent);
		variables.service.mergeEntityParsers(coreEntityParser,customEntityParser);
		assert(len(coreEntityParser.getCustomPropertyContent()));
		assertEquals(trim(coreEntityParser.getCustomPropertyContent()),trim(customEntityParser.getPropertyString()));
		assertEquals(trim(coreEntityParser.getCustomFunctionContent()),trim(customEntityParser.getFunctionString()));
		assertEquals(trim("public void function testFunc(){ return ''; } private void function testFunc3(){ return ''; } public void function testFunc2(){ return ''; } private void function testFunc4(){ return ''; }"), reReplace(trim(coreEntityParser.getCustomFunctionContent()),"\s+"," ","ALL") );

	}

	/**
	* @test
	*/
	public void function mergeEntityParsersTest_withCustomPropertiesInitially_andPurge(){

		var coreEntityParser = variables.mockService.getHibachiEntityParserTransientMock(); //request.slatwallScope.getTransient('hibachiEntityParser');

		coreEntityParser.setFileContent(variables.fileContentForAccountWithCustomPropeties);

		var customEntityParser = variables.mockService.getHibachiEntityParserTransientMock(); //request.slatwallScope.getTransient('hibachiEntityParser');
		customEntityParser.setFileContent(variables.customFileContent);
		variables.service.mergeEntityParsers(coreEntityParser,customEntityParser, true);

		assert(len(coreEntityParser.getCustomPropertyContent()));
		assertEquals(trim(coreEntityParser.getCustomPropertyContent()),trim(customEntityParser.getPropertyString()));
		assertEquals(trim(coreEntityParser.getCustomFunctionContent()),trim(customEntityParser.getFunctionString()));
		assertEquals(trim("public void function testFunc(){ return ''; } private void function testFunc3(){ return ''; } public void function testFunc2(){ return ''; } private void function testFunc4(){ return ''; }"), reReplace(trim(coreEntityParser.getCustomFunctionContent()),"\s+"," ","ALL") );

	}
	/**
	* @test
	*/
	public void function mergeEntityParsersTest_withCustomPropertiesInitially(){

		var coreEntityParser = variables.mockService.getHibachiEntityParserTransientMock(); //request.slatwallScope.getTransient('hibachiEntityParser');

		coreEntityParser.setFileContent(variables.fileContentForAccountWithCustomPropeties);

		var customEntityParser = variables.mockService.getHibachiEntityParserTransientMock(); //request.slatwallScope.getTransient('hibachiEntityParser');
		customEntityParser.setFileContent(variables.customFileContent);

		variables.service.mergeEntityParsers(coreEntityParser,customEntityParser);

		assert(len(customEntityParser.getPropertyString()));
		assert(coreEntityParser.getCustomPropertyContent() CONTAINS customEntityParser.getPropertyString());
		assert(coreEntityParser.getCustomFunctionContent() CONTAINS customEntityParser.getFunctionString());

		assertEquals(trim("public void function testFunc(){ return ''; } private void function testFunc3(){ return ''; } public void function testFunc2(){ return ''; } private void function testFunc4(){ return ''; }"), reReplace(trim(customEntityParser.getFunctionString()),"\s+"," ","ALL") );
	}
}


