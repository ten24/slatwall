
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
			if(fileExists("#ExpandPath('/#getDao('hibachiDAO').getApplicationKey()#/')#" & getFilePath())){
				variables.fileContent = fileRead( ("#ExpandPath('/#getDao('hibachiDAO').getApplicationKey()#/')#" & getFilePath()) );
			}else{
				variables.fileContent = '';
			}

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
		var propertyString = '';
		if(getPropertyStartPos()){
			propertyString = mid(getFileContent(), getPropertyStartPos(), abs(getPropertyEndPos()-getPropertyStartPos()));
		}
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

		var lineBreak = getHibachiScope().getService('HibachiUtilityService').getLineBreakByEnvironment(getApplicationValue('lineBreakStyle'));
		var propertyString = '#lineBreak# property name="#arguments.attributeData.attributeCode#"';
		var inputType = arguments.attributeData['attributeInputType'];
		var ORMType = '';
		var hbFormatType = '';
		var hbFormFieldType = '';
		switch(inputType){
			case 'yesNo':
				ORMType = 'boolean';
				hbFormatType = 'yesno';
				break;
			case 'select':
				ORMType = 'string';
				hbFormFieldType = 'select';
				break;
			case 'checkbox':
				ORMType = 'boolean';
				break;
			case 'textArea':
				ORMType = 'string';
				hbFormFieldType = 'textarea';
				break;
			case 'email':
				ORMType = 'string';
				hbFormatType = 'email';
				break;
			case 'date':
				ORMType = 'timestamp';
				hbFormatType = 'date';
				break;
			case 'dateTime':
				ORMType = 'timestamp';
				break;
			case 'time':
				ORMType = 'timestamp';
				HbFormatType = 'time';
				break;
			case 'wysiwyg':
				ORMType = 'string';
				hbFormFieldType = 'wysiwyg';
				propertyString &= ' length="4000" ';
				break;
			case 'file':
				ORMType = 'string';
				hbFormFieldType = 'file';
				propertyString &= ' hb_fileUpload="true" hb_fileAcceptMIMEType="*/*"';
				break;
			case 'typeSelect':
				propertyString &= ' cfc="Type" fieldtype="many-to-one" fkcolumn="#arguments.attributeData.attributeCode#ID"';
				if(len(arguments.attributeData.typeSetID)){
					propertyString &= ' hb_optionsSmartListData="f:parentType.typeID=#arguments.attributeData.typeSetID#"';
				}
				break;
			case 'text':
			case 'multiselect':
			case 'checkboxGroup':
			case 'radioGroup':
				ORMType = 'string';
				break;
			case 'relatedObjectSelect':
				propertyString &= ' cfc="#arguments.attributeData.relatedObject#" fieldtype="many-to-one" fkcolumn="#arguments.attributeData.attributeCode#ID"';
				break;
			default:
				return '';
		}


		if(len(ORMType)){
			propertyString &= ' ormtype="#ORMType#"';
		}
		if(len(hbFormatType)){
			propertyString &= ' hb_formatType="#hbFormatType#"';
		}
		if(len(hbFormFieldType)){
			propertyString &= ' hb_formFieldType="#hbFormFieldType#"';
		}

		propertyString &= ';';

		return propertyString;
	}


}