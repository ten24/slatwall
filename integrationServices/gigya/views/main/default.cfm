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
<cfoutput>
<p>Gigya is active.  In order to enable gigya on the frontend of your website you will need to drop the following snpit wherever you would like gigya to dispay:</p>
<pre>
##$.slatwall.getEntity('Integration', {integrationPackage='gigya'}).getIntegrationCFC('authentication').renderGigyaWidget( {
	accountLoginFormID = 'enterFormIDOfLoginFormHere',
	accountCreateFormID = 'enterFormIDOfCreateAccountFormHere',
	unregisterdUserCallback = 'enterACustomJavaScriptFunctionNameHere',
	config = {} 
} )##
</pre>
<dl>
	<dt>accountLoginFormID</dt>
	<dd>This is the form id attribute that is the default login form.  When gigya comes back with an unregistered user it will add the gigya form fields to the login form defined here.</dd>
	<dt>accountCreateFormID</dt>
	<dd>This is the form id attribute that is the default create form.  When gigya comes back with an unregistered user it will add the gigya form fields to this form so that the new user is tied to the gigya account.</dd>
	<dt>unregisterdUserCallback</dt>
	<dd>This should define a custom javascript function so that you can stylize the Login & Create forms with messaging that tells the user they need to login or create account.  Thats all this function needs to do, it does not need to call any gigya functions or add any gigya form fields.  The function defined here will have the gigya event object passed to it.</dd>
	<dt>config</dt>
	<dd>This is an optional structure where you can define any custom stylization of the socialize.showLoginUI() api method that is used to display the social login buttons.</dd>
</dl>
</cfoutput>

