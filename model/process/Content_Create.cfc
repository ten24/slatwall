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
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="content";
	
	// Lazy / Injected Objects
	property name="site";
	property name="parentContent";
	
	// New Properties

	// Data Properties (ID's)
	property name="title";
	property name="urlTitle";
	property name="siteID";			// Only used on new sku
	property name="parentContentID";		// Only used on new product
	
	// Data Properties (Related Entity Populate)
	
	// Data Properties (Object / Array Populate)
	
	// Option Properties
	
	// Helper Properties
	
	// ======================== START: Defaults ============================
	
	public any function getSite() {
		if(!structKeyExists(variables, "site") && !isNull(getSiteID())) {
			variables.site = getService("siteService").getSite(getSiteID());
		}
		return variables.site;
	}
	
	public any function getParentContent() {
		if(!structKeyExists(variables, "parentContent") && !isNull(getParentContentID())) {
			variables.parentContent = getService("contentService").getContent(getParentContentID());
		}
		return variables.parentContent;
	}
	
	// ========================  END: Defaults =============================

	// =================== START: Lazy Object Helpers ======================
	
	// ===================  END: Lazy Object Helpers =======================
	
	// ================== START: New Property Helpers ======================
	
	// ==================  END: New Property Helpers =======================
	
	// ====================== START: Data Options ==========================
	
	// ======================  END: Data Options ===========================
	
	// ===================== START: Helper Methods =========================
	
	// =====================  END: Helper Methods ==========================
	
}
