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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.account" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
<hb:HibachiEntityProcessForm entity="#rc.account#" edit="#rc.edit#" sRedirectAction="admin:entity.editaccount">
	
	<hb:HibachiEntityActionBar type="preprocess" object="#rc.account#">
	</hb:HibachiEntityActionBar>
	
	<hb:HibachiFormField fieldName="totpSecretKey" value="#rc.processObject.getTotpSecretKey()#" fieldType="hidden" />
	
	<p>#$.slatwall.rbKey('admin.entity.preprocessaccount_addtwofactorauthentication.app_installation_instructions')#</p>
	
	<!--- Display QR Code --->
	<style>
		##qrcode img { margin: auto; }
	</style>
	<div id="qrcode" class="text-center"></div>
    <script>new QRCode(document.getElementById('qrcode'), {text: "#rc.processObject.getOtpUri()#", width: 160, height: 160});</script>
	<hr>
	
	<!--- Display secret code for manual configuration --->
	<p class="text-center">#$.slatwall.rbKey('admin.entity.preprocessaccount_addtwofactorauthentication.manual_configuration')#<br>
	#rc.processObject.getTotpSecretKey()#</p>
	<hr>
	
	<!--- Confirmation instructions --->
	<hb:HibachiPropertyDisplay object="#rc.processObject#" property="authenticationCode" edit="#rc.edit#" fieldAttributes="placeholder='#$.slatwall.rbKey('entity.account.authenticationCode_confirm_placeholder')#'">
</hb:HibachiEntityProcessForm>
</cfoutput>