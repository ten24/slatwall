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
component accessors="true" output="false" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {

	property name="adminNavbarHTML";
	
	public string function getIntegrationTypes() {
		return "authentication,fw1,app";
	}
	
	public string function getDisplayName() {
		return "Mura";
	}
	
	public struct function getSettings() {
		return {
			accountSyncType = {fieldType="select", valueOptions=[
				{name="Mura System Users Only",value="systemUserOnly"},
				{name="Mura Site Members Only",value="siteUserOnly"},
				{name="All Users",value="all"},
				{name="None",value="none"}
			]},
			createDefaultPages = {fieldType="yesno", defaultValue=1},
			superUserSyncFlag = {fieldType="yesno", defaultValue=1},
			legacyInjectFlag = {fieldType="yesno", defaultValue=0},
			legacyShoppingCart = {fieldType="text", defaultValue="shopping-cart"},
			legacyOrderStatus = {fieldType="text", defaultValue="order-status"},
			legacyOrderConfirmation = {fieldType="text", defaultValue="order-confirmation"},
			legacyMyAccount = {fieldType="text", defaultValue="my-account"},
			legacyCreateAccount = {fieldType="text", defaultValue="create-account"},
			legacyCheckout = {fieldType="text", defaultValue="checkout"},
			lookupListingContentObjects = {fieldType="yesno", defaultValue=0}
		};
	}
	
	public array function getEventHandlers() {
		return ["Slatwall.integrationServices.mura.model.handler.SlatwallEventHandler"];
	}
	
	public string function getAdminNavbarHTML() {
		if(!structKeyExists(variables, "adminNavbarHTML")) {
			variables.adminNavbarHTML = '<a href="#replace(request.slatwallScope.getSlatwallRootURL(), '/Slatwall', '')#/admin" class="brand" target="_self"><img src="#request.slatwallScope.getSlatwallRootPath()#/assets/images/mura.logo.png" style="width:25px;heigh:26px;" title="Mura" /></a>'; 
		}
		return variables.adminNavbarHTML;
	}
	
}
