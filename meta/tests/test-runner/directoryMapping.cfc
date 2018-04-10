/**
 * dirStruct
 *
 * @author anants
 * @date 3/19/18
 **/
component accessors=true output=false persistent=false {

	remote any function getTestFolders() returnFormat="json"{
		var path ="/Slatwall/meta/tests/unit/";
		var metaData= DirectoryList(expandPath(path), false, "name"); // get the directory list in root path
		var arrayFolders =[];
		for (var item in metaData){
			if(findNoCase(".cfc",item,0) == 0 && findNoCase(".cfm",item,0) == 0){ //condition to remove .cfc and .cfm files in unit folder
				arrayAppend(arrayFolders, item);
				}
			}

		var objResponse='{"TestFolders":'&SerializeJSON(arrayFolders)&'}';
		return objResponse;
	}

	remote any function getTestFiles( testFolder ) returnFormat="JSON"{
		var path ="/Slatwall/meta/tests/unit/"&testFolder;
		var metaData= DirectoryList(expandPath(path), false, "name");
		var arrayFiles =[];
		for (var item in metaData){
			if(findNoCase(".cfc",item,0) > 0 ){ // condition to add only the files that have .cfc extension in the testFiles array
					arrayAppend(arrayFiles, item.left(len(item)-4));
				}
			}
		var objResponse='{"TestFiles":'&SerializeJSON(arrayFiles)&'}';
		return objResponse;
	}

	remote any function getTestMethods(testFolder, testFile) returnFormat="JSON"{
		var path="Slatwall.meta.tests.unit."&testFolder&"."&testFile;
		var metaData= GetMetaData(createObject("component",path));
		var arrayMethods = [];
		// include only the test methods from the test file
		for (var item in metaData.functions){
			if(structKeyExists(item,"test") && item.test == "yes"){
			arrayAppend(arrayMethods, item.name);
			}
		}
		// including test methods from extended file
		if(structKeyExists(metaData,"extends")&&structKeyExists(metaData.extends,"functions")){
		for (item in metaData.extends.functions){
			if(structKeyExists(item,"test") && item.test == "yes"){
			arrayAppend(arrayMethods, item.name);
			}
		}
			}
		var objResponse = '{"TestMethods":'&SerializeJSON(arrayMethods)&',"TestFunctionsCount":'&arraylen(arrayMethods)&'}';
	    return objResponse;
	}
}