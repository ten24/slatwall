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
component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController" {

	// fw1 Auto-Injected Service Properties
	property name="accountService" type="any";
	property name="productService" type="any";
	property name="orderService" type="any";
	property name="vendorService" type="any";
	property name="hibachiDataService" type="any";
	property name="imageService" type="any";
	property name="integrationService" type="any";
	property name="permissionService" type="any";
	property name="updateService" type="any";

	property name="hibachiSessionService" type="any";
	property name="hibachiUtilityService" type="any";

	this.publicMethods='';
	this.publicMethods=listAppend(this.publicMethods, 'login');
	this.publicMethods=listAppend(this.publicMethods, 'authorizeLogin');
	this.publicMethods=listAppend(this.publicMethods, 'logout');
	this.publicMethods=listAppend(this.publicMethods, 'noaccess');
	this.publicMethods=listAppend(this.publicMethods, 'error');
	this.publicMethods=listAppend(this.publicMethods, 'forgotPassword');
	this.publicMethods=listAppend(this.publicMethods, 'resetPassword');
	this.publicMethods=listAppend(this.publicMethods, 'setupInitialAdmin');
	this.publicMethods=listAppend(this.publicMethods, 'changeLanguage');
	this.publicMethods=listAppend(this.publicMethods, 'updatePassword');
	this.publicMethods=listAppend(this.publicMethods, 'collectionExport');

	this.anyAdminMethods='';
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'default');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'createImage');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'deleteImage');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'detailImage');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'editImage');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'removemeta');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'dismissmeta');

	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, 'ckfinder');
	this.secureMethods=listAppend(this.secureMethods, 'about');
	this.secureMethods=listAppend(this.secureMethods, 'update');
	this.secureMethods=listAppend(this.secureMethods, 'log');
	this.secureMethods=listAppend(this.secureMethods, 'unlockAccount');

	public void function before(required struct rc) {
		rc.pagetitle = rc.$.slatwall.rbKey(replace(rc.slatAction, ':', '.', 'all'));
	}

	public void function default(required struct rc) {
		rc.orderSmartList = getOrderService().getOrderSmartList();
		rc.orderSmartList.addInFilter("orderStatusType.systemCode", "ostNew,ostProcessing,ostOnHold,ostClosed,ostCanceled");
		rc.orderSmartList.addOrder("orderOpenDateTime|DESC");
		rc.orderSmartList.setPageRecordsShow(10);

		rc.productReviewSmartList = getProductService().getProductReviewSmartList();
		rc.productReviewSmartList.addFilter("activeFlag", 0);
		rc.productReviewSmartList.setPageRecordsShow(10);

		if(getUpdateService().getMetaFolderExistsWithoutDismissalFlag()) {
			rc.$.slatwall.showMessageKey( 'admin.metaexists_error' );
		}
	}
	//TODO: deprecate ,  getImageDirectory()
	public void function saveImage(required struct rc){

		var image = getImageService().getImage(rc.imageID, true);
		image.setDirectory(rc.directory);

		if(rc.imageFile != ''){
			var documentData = fileUpload(getTempDirectory(),'imageFile','','makeUnique');

			if(len(image.getImageFile()) && fileExists(expandpath(image.getImageDirectory()) & image.getImageFile())){
				fileDelete(expandpath(image.getImageDirectory()) & image.getImageFile());
			}

			//need to handle validation at some point
			if(documentData.contentType eq 'image'){
				fileMove(documentData.serverDirectory & '/' & documentData.serverFile, expandpath(image.getImageDirectory()) & documentData.serverFile);
				rc.imageFile = documentData.serverfile;
			}else if (fileExists(expandpath(image.getImageDirectory()) & image.getImageFile())){
				fileDelete(expandpath(image.getImageDirectory()) & image.getImageFile());
			}

		}else if(structKeyExists(rc,'deleteImage') && fileExists(expandpath(image.getImageDirectory()) & image.getImageFile())){
			fileDelete(expandpath(image.getImageDirectory()) & image.getImageFile());
			rc.imageFile='';
		}else{
			rc.imageFile = image.getImageFile();
		}

		super.genericSaveMethod('Image',rc);

	}

	public void function encryptionUpdatePassword(required struct rc) {
		param name="rc.process" default="0";
		param name="rc.password" default="";
		param name="rc.iterationCount" default="#randRange(500, 2500)#";

		if (rc.process) {
			getHibachiUtilityService().addEncryptionPasswordData(data=rc);
			rc.$.slatwall.showMessageKey("admin.main.encryption.updatePassword_success");
			getFW().redirect(action="admin:main.default", preserve="messages");
		}

		rc.edit = true;
	}

	public void function encryptionReencryptData(required struct rc) {
		param name="rc.process" default="0";
		param name="rc.batchSizeLimit" default="0";

		if (rc.process) {
			getHibachiUtilityService().reencryptData(val(rc.batchSizeLimit));
			rc.$.slatwall.showMessageKey("admin.main.encryption.reencryptdata_success");
			getFW().redirect(action="admin:main.default", preserve="messages");
		}

		rc.edit = true;
	}

	public void function update(required struct rc) {
		param name="rc.process" default="0";
		param name="rc.branchType" default="standard";

		if(rc.process) {
			logHibachi("Update Called", true);
			if(rc.branchType eq "custom"){
				getUpdateService().update(branch=rc.customBranch);
			}else{
				getUpdateService().update(branch=rc.updateBranch);
			}
			

			logHibachi("Update Finished, Now Calling Reload", true);

			rc.$.slatwall.showMessageKey("admin.main.update_success");
			
			getFW().redirect(action="admin:main.default", preserve="messages", queryString="#getApplicationValue('applicationReloadKey')#=#getApplicationValue('applicationReloadPassword')#&#getApplicationValue('applicationUpdateKey')#=#getApplicationValue('applicationUpdatePassword')#");
		}

		// https://api.github.com/repos/ten24/Slatwall/branches
		var versions = getUpdateService().getAvailableVersions();
		rc.availableDevelopVersion = versions.develop;
		rc.availableMasterVersion = versions.master;
		rc.availableHotfixVersion = versions.hotfix;

		rc.currentVersion = getApplicationValue('version');
		if(listLen(rc.currentVersion, '.') > 3) {
			rc.currentBranch = "develop";
		} else {
			rc.currentBranch = "master";
		}
	}

	public void function logout(required struct rc) {
		getAccountService().processAccount(rc.$.slatwall.getAccount(), rc, "logout");

		getFW().redirect('admin:main.login');
	}

	public void function login(required struct rc) {
		getFW().setView("admin:main.login");
		rc.pageTitle = rc.$.slatwall.rbKey('define.login');

		if(!structKeyExists(rc, "sRedirectURL")) {
			arguments.rc.sRedirectURL = getApplicationValue('baseURL') & '/';
		}
		//does authentication exist?
		rc.accountAuthenticationExists = getAccountService().getAccountAuthenticationExists();

		rc.integrationLoginHTMLArray = getIntegrationService().getAdminLoginHTMLArray();

	}

	public void function setupInitialAdmin( required struct rc) {
		param name="rc.password" default="";
		param name="rc.passwordConfirm" default="";

		rc.account = getAccountService().processAccount(rc.$.slatwall.getAccount(), rc, "setupInitialAdmin");

		if(!rc.account.getProcessObject("setupInitialAdmin").hasErrors() && !rc.account.hasErrors()) {
			getFW().redirect(action='admin:main.default', queryString="s=1");
		}

		login( rc );
	}

	public void function authorizeLogin(required struct rc) {
		getAccountService().processAccount(rc.$.slatwall.getAccount(), rc, "login");

		if(getHibachiScope().getLoggedInFlag()) {
			if(structKeyExists(rc, "sRedirectURL")) {
				getFW().redirectExact(rc.sRedirectURL);
			} else {
				getFW().redirect(action="admin:main.default", queryString="s=1");
			}
		}

		login( rc );
	}


	public void function forgotPassword(required struct rc) {
		rc.$.slatwall.setPublicPopulateFlag( true );

		var account = getAccountService().processAccount(rc.$.slatwall.getAccount(), rc, "forgotPassword");

		if(!account.hasErrors()) {
			account.clearProcessObject('forgotPassword');
			rc.$.slatwall.showMessageKey('entity.account.process.forgotPassword_success');
		}

		login( rc );
	}

	public void function resetPassword(required struct rc) {
		param name="rc.accountID" default="";

		var account = getAccountService().getAccount( rc.accountID );

		if(!isNull(account)) {
			account = getAccountService().processAccount(account, rc, "resetPassword");

			if(!account.hasErrors()) {
				rc.emailAddress = account.getEmailAddress();
				authorizeLogin( rc );
			} else {
				rc.processObject = account.getProcessObject('resetPassword');
			}
		}

		login( rc );
	}

	public void function updatePassword(required struct rc){
		getAccountService().processAccount(rc.$.slatwall.getAccount(), rc, "updatePassword");

		if(!rc.$.slatwall.getAccount().hasErrors()) {
			rc.$.slatwall.showMessageKey("entity.Account.process.updatePassword_success");
			getFW().redirect(action="admin:main.default", preserve="messages");
		}

		login(rc);
	}

	public void function processBouncedEmails(required struct rc){

		try {
			getService("EmailBounceService").processBouncedEmails();
			rc.$.slatwall.showMessageKey( "admin.processBouncedEmails_success" );
		} catch (any e) {
			rc.$.slatwall.showMessageKey( "admin.processBouncedEmails_failure" );
		}

		getFW().redirect(action="admin:main.default", preserve="messages");


	}

	public void function changeLanguage( required struct rc ){
		param name="arguments.rc.rbLocale" default="";
		param name="arguments.rc.redirectURL" default="";

		arguments.rc.$.slatwall.getSession().setRBLocale(hibachiHTMLEditFormat(arguments.rc.rbLocale));
		arguments.rc.$.slatwall.setPersistSessionFlag( true );

		getFW().redirectExact( rc.redirectURL );

	}

	public void function removeMeta() {
		getUpdateService().removeMeta();

		rc.$.slatwall.showMessageKey( 'admin.metaremoved_info' );

		getFW().redirect(action="admin:main.default", preserve="messages");
	}

	public void function dismissMeta() {
		getUpdateService().dismissMeta();

		rc.$.slatwall.showMessageKey( 'admin.metadismissed_info' );

		getFW().redirect(action="admin:main.default", preserve="messages");
	}

	public void function unlockAccount(){

		var account = getService("HibachiService").getAccountByAccountID(url.accountid);

		account = getAccountService().processAccount(account, "unlock");

		rc.$.slatwall.showMessageKey( 'admin.main.unlockAccount_info' );

		getFW().redirect(action="entity.detailaccount", queryString="accountID=#arguments.rc.accountid#", preserve="messages");

	}

}
