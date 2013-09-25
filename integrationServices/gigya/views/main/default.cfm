<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

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
