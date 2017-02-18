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
    along with this program.  If not, see <http://www.gnu.org/license;.

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

	public void function makeSureAllViewFilesAreLowerCased() {
		var path = expandPath('/Slatwall');
		var adminFiles = directoryList(path&'/admin',true,'path','*.cfm|*.ts|*.js');

		var path = expandPath('/Slatwall');
		var hibachiClientFiles = directoryList(path&'/org/Hibachi/client',true,'path','*.ts');

		var viewFiles = adminFiles;

		for(var item in hibachiClientFiles){
			arrayAppend(viewFiles,item);
		}

		var allLowercaseFileNames = true;
		var offenders = '';
		for(var item in viewFiles){
			var fileName = listLast(item,'/');
			if(REFIND("[A-Z]",fileName) && fileName DOES NOT CONTAIN '.d.ts'){
				offenders = listAppend(offenders,item);
				allLowercaseFileNames =false;
			}
		}
		assert(allLowercaseFileNames,offenders);

	}

	public void function varScoperTest(){
		var modelDirectoryPath = expandPath('/Slatwall');
		var modelDirectory = directoryList(modelDirectoryPath,true,'query','*.cfc');
		var hasUnscopedVars = false;
		
		for(var record in modelDirectory){
			if(
				record.directory DOES NOT CONTAIN 'mxunit'
				&& record.directory DOES NOT CONTAIN '.history'
				&& record.directory DOES NOT CONTAIN 'WEB-INF'
				&& record.directory DOES NOT CONTAIN 'varscoper'
				&& record.directory DOES NOT CONTAIN 'ckfinder'
				&& record.directory DOES NOT CONTAIN 'javaloader'
				&& record.directory DOES NOT CONTAIN 'taffy'
				//can't analyze because it blends cfml and cfscript on a function
				&& fileExists(record.directory&'/#record.name#')
			){
				var fileText = fileRead(record.directory&'/#record.name#');
				var varscoper = createObject("component","Slatwall.meta.varscoper.varScoper").init(fileText,true,true,true);
				varscoper.runVarscoper();
				if(arraylen(varscoper.getResultsArray())){
					hasUnscopedVars = true;
					addToDebug(record.directory&'/#record.name# has unscoped var');
					addToDebug(varscoper.getResultsArray());
				}
				
				
			}
		}
		assertFalse(hasUnscopedVars);
	}
	
	

//	private void function processDirectory(required string startingDirectory, string recursive=false){
//
//		var fileQuery = "";
//		var scoperFileName = "";
//		var xmlDoc = "";
//		var xmlDocData = "";
//		var directoryexcludelistXML = arrayNew(1);
//		var directoryexcludelist = "";
//		var fileexcludelistXML = arrayNew(1);
//		var fileexcludelist = "";
//		var pathsep = "/";
//
//		/* get properties */
//		if(fileExists("#expandPath('/Slatwall')#/meta/varscoper/properties.xml")){
//			/* read xml file */
//			var xmlDocData = fileread("#expandPath('/Slatwall')#/meta/varscoper/properties.xml");
//				/* get file to parse */
//			xmlDoc = XmlParse(xmlDocData);
//
//			/* get directory exclusion list */
//			directoryexcludelistXML = XmlSearch(xmlDoc, "/properties/directoryexcludelist");
//			/* if array size GT 0 the get the value */
//			if(arrayLen(directoryexcludelistXML) GT 0){
//				directoryexcludelist = trim(directoryexcludelistXML[1].XmlText);
//			}
//			/* get file exclusion list */
//			fileexcludelistXML = XmlSearch(xmlDoc, "/properties/fileexcludelist");
//			/* if array size GT 0 the get the value */
//			if(arrayLen(fileexcludelistXML) GT 0){
//				fileexcludelist = trim(fileexcludelistXML[1].XmlText);
//			}
//		}
//
//		fileQuery = DirectoryList(arguments.startingDirectory,false,"query");
//
//		for (var i = 1 ;i <= fileQuery.RecordCount ;i++){
//			/* check to see if we want to exclude the diretory or file (from properties file) */
//			if(
//				NOT listFindNoCase(directoryExcludeList, listLast(replace(arguments.startingDirectory, "\", "/", "ALL"), pathsep))
//				AND NOT listFindNoCase(fileExcludeList, "#name#")
//			){
//				scoperFileName = "#arguments.startingDirectory##pathsep##name#";
//			}
//			if(listFind("cfc,cfm",right(fileQuery.name,3)) NEQ 0 and type IS "file"){
//				variables.totalFiles = variables.totalFiles + 1;
//				include "../../../varscoper/varScoperDisplay.cfm";
//			}else if(type IS "Dir" and arguments.recursive){
//				processDirectory(startingDirectory:scoperFileName, recursive:true);
//			}
//		}
//	}


//	public void function parsestringTobigDecimalTest(){
//
//		precisionEvaluateTest(1223.23 * 100 / 1234.23,getMaxScale(discountAmount,getApplied(),c,d));
//	}

//	private any function precisionEvaluateTest(value,scale=2){
//		addToDebug(precisionEvaluate(59.999 * 100.0001)& ' precisionEvaluate ');
//
//		addToDebug(toString(59.99*100));
//
//		var roundingmode = createObject('java','java.math.RoundingMode');
//
//		AddToDebug(arguments.value & ' value ');
//		var scaledvalue = javacast('bigdecimal',arguments.value).setScale(20);
//		AddToDebug(
//			scaledvalue & ' scaledvalue '
//		);
//
//		AddToDebug(javacast('bigdecimal',1223.23).multiply(javacast('bigdecimal',100)).divide(javacast('bigdecimal',1234.23),2,roundingmode.HALF_EVEN));
//
//		return scaledvalue;
//	}

}
