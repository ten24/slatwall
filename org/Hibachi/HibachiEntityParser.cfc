
component accessors="true" persistent="false" output="false" extends="HibachiObject"{
	property name="filePath" type="string";
	property name="componentFilePath" type="string";
	property name="lineBreak" type="string";
	property name="metaData" type="any";
	property name="fileContent" type="string";
	property name="entityName" type="string";

	public void function init(){
		//declared custom strings

		variables.customPropertyBeginString = '//CUSTOM PROPERTIES BEGIN';
		variables.customPropertyEndString = '//CUSTOM PROPERTIES END';
		variables.customFunctionBeginString = chr(9) &'//CUSTOM FUNCTIONS BEGIN';
		variables.customFunctionEndString = '//CUSTOM FUNCTIONS END';
		variables.lineBreak = getHibachiScope().getService('HibachiUtilityService').getLineBreakByEnvironment(getApplicationValue("lineBreakStyle"));
	}

	public void function setCustomPropertyBeginString(required customPropertyBeginString){
		variables.customPropertyBeginString = arguments.customPropertyBeginString;
	}

	public void function setCustomPropertyEndString(required customPropertyEndString){
		variables.customPropertyEndString = arguments.customPropertyEndString;
	}

	public void function setCustomFunctionBeginString(required customFunctionBeginString){
		variables.customFunctionBeginString = arguments.customFunctionBeginString;
	}

	public void function setCustomFunctionEndString(required customFunctionEndString){
		variables.customFunctionEndString = arguments.customFunctionEndString;
	}


	public string function getFileContent(){
		if(!structKeyExists(variables,'fileContent')){
			variables.fileContent =fileRead( "#ExpandPath('/#getDao('hibachiDAO').getApplicationKey()#/')#" & getFilePath());
		}
		return variables.fileContent;
	}

	public string function getFilePath(){
		if(!isNull(variables.filePath)){
			return variables.filePath;
		}
	}

	public void function setFileContent(required string fileContent){
		variables.fileContent = arguments.fileContent;
	}

	public void function setFilePath(required string filePath){
		if(fileExists(expandPath(arguments.filePath)))
			variables.filePath = arguments.filePath;
	}

	public boolean function hasCustomProperties(){
		return findNoCase(variables.customPropertyBeginString, getFileContent());
	}

	public boolean function hasCustomFunctions(){
		return findNoCase(variables.customFunctionBeginString, getFileContent());
	}

	public numeric function getCustomPropertyStartPosition(){
		return findNoCase(chr(9)&variables.customPropertyBeginString, getFileContent());
	}

	public numeric function getCustomPropertyEndPosition(){
		return findNoCase(variables.customPropertyEndString, getFileContent()) + len(variables.customPropertyEndString);
	}

	public numeric function getCustomFunctionStartPosition(){
		return findNoCase(variables.customFunctionBeginString, getFileContent());
	}

	public numeric function getCustomFunctionEndPosition(){
		return findNoCase(variables.customFunctionEndString, getFileContent()) + len(variables.customFunctionEndString);
	}

	public string function getCustomFunctionStringByFunctionString(){
		return variables.customFunctionBeginString & variables.lineBreak & chr(9) & getFunctionString() & variables.lineBreak & chr(9) & variables.customFunctionEndString & variables.lineBreak;
	}

	public string function getCustomPropertyStringByPropertyString(propertyString=getPropertyString()){

		return variables.customPropertyBeginString & variables.lineBreak & chr(9) & arguments.propertyString & chr(9) & variables.customPropertyEndString & variables.lineBreak;
	}

	//if there is no componentPath but there is a file path then create one
	public string function getComponentFilePath(){
		if(!structKeyExists(variables,'componentFilePath') && !isnull(getFilePath())){
			var componentFilePath = left(getFilePath(), len(getFilePath())-4);
			variables.componentFilePath = replace(componentFilePath, "/", ".", "All");
		}
		return variables.componentFilePath;
	}

	public void function setComponentFilePath(required string componentFilePath){
		variables.componentFilePath = arguments.componentFilePath;
	}

	public any function getMetaData(){
		if(!structkeyExists(variables,'metaData')){
			variables.metaData = getComponentMetaData(getComponentFilePath());
		}
		return variables.metaData;
	}

	public void function setMetaData(required any metaData){
		variables.metaData = arguments.metaData;
	}

	public numeric function getPropertyStartPos(){
		return findNoCase("property name=", getFileContent());
	}

	public numeric function getPrivateFunctionLineStartPos(){
		return reFindNoCase('\private(?:\s+\w+){1}\sfunction',getFileContent());
	}

	public numeric function getPublicFunctionLineStartPos(){
		return reFindNoCase('\public(?:\s+\w+){1}\sfunction',getFileContent());
	}

	public numeric function getFunctionLineStartPos(){
		var functionLineStartPos = 0;
		if(getPrivateFunctionLineStartPos() && getPublicFunctionLineStartPos()){
			if(getPrivateFunctionLineStartPos() > getPublicFunctionLineStartPos()){
				functionLineStartPos = getPublicFunctionLineStartPos();
			}else{
				functionLineStartPos = getPrivateFunctionLineStartPos();
			}
		}else if(getPrivateFunctionLineStartPos()){
			functionLineStartPos = getPrivateFunctionLineStartPos();
		}else if(getPublicFunctionLineStartPos()){
			functionLineStartPos = getPublicFunctionLineStartPos();
		}
		return functionLineStartPos;
	}

	public numeric function getPropertyEndPos(){
		if(getFunctionLineStartPos()){
			return getFunctionLineStartPos() -1;
		}else{
			return getComponentEndPos();
		}
	}

	public string function getFunctionString(){
		var functionString = '';
		if(getFunctionLineStartPos()){
			functionString =  mid(getFileContent(), getFunctionLineStartPos(), abs(getComponentEndPos() - getFunctionLineStartPos()));
		}
		return functionString;
	}

	public string function getPropertyString(){
		/**/
		var propertyString = '';
		if(getPropertyStartPos()){
			propertyString = mid(getFileContent(), getPropertyStartPos(), abs(getPropertyEndPos()-getPropertyStartPos()));
		}
		/*f*/
		return propertyString;
	}

	public numeric function getCustomPropertyContentStartPosition(){
		return getCustomPropertyStartPosition()+len(variables.customPropertyBeginString)+1;
	}

	public numeric function getCustomPropertyContentEndPosition(){
		return getCustomPropertyEndPosition()-len(variables.customPropertyEndString);
	}

	public string function getCustomPropertyContent(){
		return mid(
			getFileContent(),
			getCustomPropertyContentStartPosition(),
			getCustomPropertyContentEndPosition()-getCustomPropertyContentStartPosition()
		);
	}

	public numeric function getCustomFunctionContentStartPosition(){
		return getCustomFunctionStartPosition()+len(variables.customFunctionBeginString)+1;
	}

	public numeric function getCustomFunctionContentEndPosition(){
		return getCustomFunctionEndPosition()-len(variables.customFunctionEndString);
	}

	public string function getCustomFunctionContent(){
		return mid(
			getFileContent(),
			getCustomFunctionContentStartPosition(),
			getCustomFunctionContentEndPosition()-getCustomFunctionContentStartPosition()
		);
	}


	public numeric function getComponentEndPos(){
		return getFileContent().lastIndexOf("}");
	}

	public string function getPropertyStringByAttributeData(required struct attributeData){
		var lineBreak = getHibachiScope().getService('HibachiUtilityService').getLineBreakByEnvironment(getApplicationValue("lineBreakStyle"));
		var propertyString = "";
		var inputType = arguments.attributeData['attributeInputType'];
		var ORMType = '';
		var hbFormatType = '';
		var hbFormFieldType = '';
		switch(lcase(inputType)){
			case "yesNo":
				ORMType = "boolean";
				hbFormatType = "yesno";
				break;
			case "checkbox":
				ORMType = "boolean";
				break;
			case "textArea":
				ORMType = "string";
				break;
			case "text":
				ORMType = "string";
				break;
			case "email":
				ORMType = "string";
				hbFormatType = "email";
				break;
			case "date":
				ORMType = "timestamp";
				hbFormatType = "date";
				break;
			case "date time":
				ORMType = "timestamp";
				break;
			case "time":
				ORMType = "timestamp";
				HbFormatType = "time";
				break;
			case "wysiwyg":
				ORMType = "string";
				hbFormFieldType = "wysiwyg";
		}

		if(len(ORMType))
			propertyString = propertyString & "#lineBreak# property name=""#arguments.attributeData['attributeCode']#"" ormtype=""#ORMType#""";
		if(len(hbFormatType)){
			propertyString = propertyString & " hb_formatType=""#hbFormatType#""";
		}
		if(len(hbFormFieldType)){
			propertyString = propertyString & " hb_formFieldType=""#hbFormFieldType#""";
		}
		if(len(ORMType)){
			propertyString = propertyString & ";";
		}
		return propertyString;
	}

}
