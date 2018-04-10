/**
 * dirStruct
 *
 * @author anants
 * @date 3/19/18
 **/
component accessors=true output=false persistent=false {

	remote any function getTestFolders() returnFormat="json"{
	path ="/Slatwall/meta/tests/unit/";
	metaData= DirectoryList(expandPath(path), false, "name"); // get the directory list in root path
	arrayFolders =[];
	for (item in metaData){
		if(findNoCase(".cfc",item,0) == 0 && findNoCase(".cfm",item,0) == 0){ //condition to remove .cfc and .cfm files in unit folder
			arrayAppend(arrayFolders, item);
			}
		}

	objResponse='{"TestFolders":'&SerializeJSON(arrayFolders)&'}';
	return objResponse;
	}

	remote any function getTestFiles( testFolder ) returnFormat="JSON"{
	path ="/Slatwall/meta/tests/unit/"&testFolder;
	metaData= DirectoryList(expandPath(path), false, "name");
	arrayFiles =[];
	for (item in metaData){
		if(findNoCase(".cfc",item,0) > 0 ){ // condition to add only the files that have .cfc extension in the testFiles array
				arrayAppend(arrayFiles, item.left(len(item)-4));
			}
		}
	objResponse='{"TestFiles":'&SerializeJSON(arrayFiles)&'}';
	return objResponse;
	}

	remote any function getTestMethods(testFolder, testFile) returnFormat="JSON"{
		path="Slatwall.meta.tests.unit."&testFolder&"."&testFile;
		metaData= GetMetaData(createObject("component",path));
		arrayMethods = [];
		for (item in metaData.functions){
			if(structKeyExists(item,"test") && item.test == "yes"){
			arrayAppend(arrayMethods, item.name);
			}
		}
		if(structKeyExists(metaData,"extends")&&structKeyExists(metaData.extends,"functions")){
		for (item in metaData.extends.functions){
			if(structKeyExists(item,"test") && item.test == "yes"){
			arrayAppend(arrayMethods, item.name);
			}
		}
			}
		objResponse = '{"TestMethods":'&SerializeJSON(arrayMethods)&',"TestFunctionsCount":'&arraylen(arrayMethods)&'}';
	    return objResponse;
	}
}