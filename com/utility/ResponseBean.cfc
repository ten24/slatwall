/*

    Slatwall - An e-commerce plugin for Mura CMS
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

*/
component accessors="true" displayname="ResponseBean" hint="bean to encapsulate response from service layer" extends="BaseObject" {
	
	property name="data" type="any";
	property name="statusCode" type="string";
	property name="errorBean" type="any";
	property name="messageBeans" type="array";
	
	public any function init() {
		// Set Defaults
		this.setStatusCode("");
		this.setData({});
		this.setMessageBeans([]);
		this.setErrorBean(new Slatwall.com.utility.ErrorBean());
		
		// Populate all keys passed in
		for(var key in arguments) {
			if(structKeyExists(this, "set#key#")) {
				var setterMethod = this["set" & key];
				setterMethod(arguments[key]);	
			}
		}
		
		return this;
	} 
	
	public boolean function hasErrors() {
		return getErrorBean().hasErrors();
	}
	
	public void function addMessage() {
		arrayAppend(getMessageBeans(), new MessageBean(argumentcollection=arguments));
		getService("logService").logMessage(argumentcollection=arguments);
	}
	
	public void function addError(required string name, required string message) {
		getErrorBean().addError(argumentcollection=arguments);
		getService("logService").logMessage(messageCode=arguments.name, message=arguments.message, messageType="Response Error");
	}
	
	public string function getError(required string name) {
		return getErrorBean().getError(arguments.name);
	}
	
	public string function getMessageString() {
		var messageString = "";
		
		for(var i=1; i<=arrayLen(getMessageBeans()); i++) {
			if(i>1) {
				messageString &= "~";
			}
			messageString &= "#getMessageBeans()[1].getMessageCode()#|#getMessageBeans()[1].getMessageType()#|#getMessageBeans()[1].getMessage()#";
		}
		
		return messageString;
	}
	
} 