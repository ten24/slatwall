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
component  extends="HibachiService" accessors="true" {

	property name="attributeService" type="any";

	// ===================== START: Logical Methods ===========================

	//Utilized by HibachiControllerREST to supply usefully shaped form response data
	public array function transformFormResponseData(required any rawData){
		var transformedData = [];

		var currentFormResponseID = "";
		var responseStruct = {};

    	for(var row in arguments.rawData){
			if (currentFormResponseID != row["formResponseID"]){

				if(currentFormResponseID != ""){
					arrayAppend(transformedData, responseStruct);
				}

				currentFormResponseID = row["formResponseID"];
				responseStruct = {};
				responseStruct["formResponseID"] = row["formResponseID"];
				responseStruct["createdDateTime"] = row["formResponsePostedDateTime"];
			}
			responseStruct[row["questionID"]] = row["response"];
    	}

		arrayAppend(transformedData, responseStruct);

		return transformedData;
    }

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	public any function processForm_addFormQuestion(required any form, required any processObject ){

		arguments.form.addFormQuestion(processObject.getNewFormQuestion());

		//backfill attribute values for already submitted form responses
		if(!arguments.form.hasErrors() && arguments.form.getFormResponsesCount() > 0){
			for(var response in arguments.form.getFormResponses()){
				var value = getAttributeService().newAttributeValue();
				value.setAttribute(processObject.getNewFormQuestion());
				value.setFormResponse(response);
				value.setAttributeValueType("FormResponse");
				if(!isNull(processObject.getNewFormQuestion().getDefaultValue())){
					value.setAttributeValue(processObject.getNewFormQuestion().getDefaultValue());
				} else {
					value.setAttributeValue("");
				}
				this.saveFormResponse(response);
			}
		}
		
		return this.saveForm(arguments.form);
	}

	public any function processForm_addFormResponse(required any form, required any processObject ){
		var formResponse = processObject.getNewFormResponse();
		formResponse.setForm(arguments.form);
		formResponse = this.saveFormResponse(formResponse);
		return formResponse;
	}

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ====================== START: Delete Overrides =========================

	// ======================  END: Delete Overrides ==========================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}

