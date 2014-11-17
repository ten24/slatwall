<!---

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

--->
<cfcomponent extends="HibachiService" persistent="false" accessors="true" output="false">
	
	<cfproperty name="templateService" />
	
	<!--- ===================== START: Logical Methods =========================== --->
	
	<!--- =====================  END: Logical Methods ============================ --->
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- =====================  END: DAO Passthrough  =========================== --->
	<!--- ===================== START: Process Methods =========================== --->
		
	<cfscript>
	
	public any function processPrint_addToQueue(required any print, required struct data) {
		// Populate the email with any data that came in
		arguments.print.populate( arguments.data );
		
		if(structKeyExists(arguments.data, "printTemplate") && isObject(arguments.data.printTemplate)) {
			var printTemplate = arguments.data.printTemplate;
		} else if (structKeyExists(arguments.data, "printTemplateID")) {
			var printTemplate = getTemplateService().getPrintTemplate( arguments.data.printTemplateID );
		}
		
		if(!isNull(printTemplate)) {
			var templateObjectIDProperty = getPrimaryIDPropertyNameByEntityName(printTemplate.getPrintTemplateObject());
			var templateObject = javaCast('null','');
			
			if(structKeyExists(arguments.data, printTemplate.getPrintTemplateObject()) && isObject(arguments.data[ printTemplate.getPrintTemplateObject() ])) {
				var templateObject = arguments.data[ printTemplate.getPrintTemplateObject() ];
			} else if(structKeyExists(arguments.data, templateObjectIDProperty)) {
				var templateObject = getServiceByEntityName( printTemplate.getPrintTemplateObject() ).invokeMethod("get#printTemplate.getPrintTemplateObject()#", {1=arguments.data[ templateObjectIDProperty ]});
			}
			
			if(!isNull(templateObject)) {
				
				// Setup the print content
				if(!isNull(printTemplate.getPrintContent())) {
					arguments.print.setPrintContent( templateObject.stringReplace( printTemplate.getPrintContent() ) );	
				}
				
				var templateFileResponse = "";
				var templatePath = getTemplateService().getTemplateFileIncludePath(templateType="print", objectName=printTemplate.getPrintTemplateObject(), fileName=printTemplate.getPrintTemplateFile());
				
				local.print = arguments.print;
				local.printData = {};
				local[ printTemplate.getPrintTemplateObject() ] = templateObject;
				
				if(len(templatePath)) {
					savecontent variable="templateFileResponse" {
						include '#templatePath#';
					}
				}
				
				if(len(templateFileResponse) && !structKeyExists(local.printData, "printContent")) {
					local.printData.printContent = templateFileResponse;
				}
				
				arguments.print.populate( local.printData );
				
				// Append the email to the email queue
				arrayAppend(getHibachiScope().getPrintQueue(), arguments.print);
			}
			
		}
		
		
		return arguments.print;
	}
	
	public void function generateAndPrintFromEntityAndPrintTemplateID( required any entity, required any printTemplateID ) {
		var print = this.newPrint();
		var printData = {
			printTemplateID = arguments.printTemplateID
		};
		printData[ arguments.entity.getPrimaryIDPropertyName() ] = arguments.entity.getPrimaryIDValue();
		print = this.processPrint(print, printData, 'addToQueue');
	}
	
	public void function generateAndPrintFromEntityAndPrintTemplate( required any entity, required any printTemplate ) {
		var print = this.newPrint();
		print = this.processPrint(print, arguments, 'addToQueue');
		return print;
	}
		
	</cfscript>
	
	<!--- =====================  END: Process Methods ============================ --->
	<!--- ====================== START: Save Overrides =========================== --->
	
	<!--- ======================  END: Save Overrides ============================ --->
	<!--- ==================== START: Smart List Overrides ======================= --->
	
	<!--- ====================  END: Smart List Overrides ======================== --->
	<!--- ====================== START: Get Overrides ============================ --->
	
	<!--- ======================  END: Get Overrides ============================= --->
	
</cfcomponent>
