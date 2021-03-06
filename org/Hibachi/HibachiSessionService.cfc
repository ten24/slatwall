component output="false" accessors="true" extends="HibachiService"  {

	property name="orderService" type="any";
	property name="accountService" type="any";
	property name="hibachiJWTService" type="any";
	property name="hibachiTagService" type="any";
	property name="hibachiAuditService" type="any";
	property name="hibachiUtilityService" type="any";
	
	

	// ===================== START: Logical Methods ===========================
	public struct function getConfig(){
		var config = {};
		config[ 'applicationKey' ] = getApplicationValue('applicationKey');
		config[ 'baseURL' ] = getApplicationValue('baseURL');

		config[ 'action' ] = getApplicationValue('action');
		config[ 'dateFormat' ] = 'mmm dd, yyyy';
		config[ 'timeFormat' ] = 'hh:mm tt';
		var rbLocale = 'en_us';
		if(!isNull(getHibachiScope().getSession().getRBLocale())){
			rbLocale = '#getHibachiScope().getSession().getRBLocale()#';
		}
		config[ 'rbLocale' ] = rbLocale;
		config[ 'debugFlag' ] = getApplicationValue('debugFlag');
		config[ 'instantiationKey' ] = '#getApplicationValue('instantiationKey')#';
		config[ 'attributeCacheKey' ] = '#getAttributeCacheKey()#';
		return config;
	}
	
	public string function generateCSRFToken(boolean forceNew=false, string tokenName='hibachiCSRFToken'){ 
		if(arguments.forceNew || !hasSessionValue(arguments.tokenName)){
			setSessionValue(arguments.tokenName, createUUID());
		} 
		return getSessionValue(arguments.tokenName);
	}

	public boolean function verifyCSRFToken(required string requestToken,string tokenName='hibachiCSRFToken'){
	   
		if(!this.getHibachiScope().hasSessionValue(arguments.tokenName)){
		    this.logHibachi("verifyCSRFToken:: does not have CSRF session value for tokenName: #arguments.tokenName#; csrf-value: #arguments.requestToken#. approving this request");
			return true; 
		}

		return arguments.requestToken == this.getHibachiScope().getSessionValue(arguments.tokenName); 
	} 

	public any function verifyCSRF(required any rc, required any framework){
		var requestHasCSRF = structKeyExists(arguments.rc, "csrf"); 

		// Right now this logic only runs if CSRF token is present, not as secure as it could be. 
		if(requestHasCSRF && !this.verifyCSRFToken(arguments.rc.csrf)){
				
				getHibachiScope().showMessage(getHibachiScope().rbKey("admin.define.csrfinvalid"),"success");
	
				//If the token is invalid we don't know if the original request was successful or not, right now this logic assumes success (not ideal)
				if(structKeyExists(arguments.rc, "sRedirectURL")) {
						arguments.framework.redirectExact( redirectlocation=arguments.rc.sRedirectURL );
				} else if (structKeyExists(arguments.rc, "sRedirectAction")) {
						if(!structKeyExists(arguments.rc,"sRedirectQS")){
							arguments.rc.sRedirectQS = '';
						}
						arguments.framework.redirect( action=arguments.rc.sRedirectAction, preserve="messages", queryString=arguments.rc.sRedirectQS );
				} else {
					var frameworkConfig = arguments.framework.getConfig();  
					var action = arguments.framework.getAction(); 
					var subsystem = arguments.framework.getSubsystem(); 
					var section = frameworkConfig['defaultSection'];
					var item = frameworkConfig['defaultItem'];
					var defaultSubsystemAction = subsystem & ':' & section & '.' & item;  
 					arguments.framework.redirect( action=defaultSubsystemAction, preserve="messages");
				}	
		}
		
		//only force a new token if one was not passed in
		if( !requestHasCSRF ){
			arguments.rc.csrf = this.generateCSRFToken(requestHasCSRF);
		}
 		return arguments.rc;	
	}
	
	public String function getCookiePrefix(any currentRequestSite){
		var cookiePrefix = getApplicationValue('applicationKey');
		
		if (!isNull(currentRequestSite) && len(currentRequestSite.getSiteCode())){
			cookiePrefix &= "-" & currentRequestSite.getSiteCode();
		}
		return cookiePrefix;
	}
	
	public void function setProperSession() {
		var requestHeaders = getHTTPRequestData();
		

		var sessionValue = "sessionID";
		var cookiePrefix = getApplicationValue('applicationKey');
		
		if(!getHibachiScope().hasSessionValue(sessionValue) || !len(getHibachiScope().getSessionValue(sessionValue))) {

			var currentRequestSite = getHibachiScope().getCurrentRequestSite();
			
			var cookiePrefixArgs = {};
			
			if (!isNull(currentRequestSite)){
				sessionValue = currentRequestSite.getSiteCode() & '-' & sessionValue;
				cookiePrefixArgs['currentRequestSite'] = currentRequestSite;
			}
			
			cookiePrefix = getCookiePrefix(argumentCollection=cookiePrefixArgs);
			
			
			// Check to see if a session value doesn't exist, then we can check for a cookie... or just set it to blank
			if(!getHibachiScope().hasSessionValue(sessionValue)) {
				getHibachiScope().setSessionValue(sessionValue, '');
			} 
		}
		
		var foundWithNPSID = false;
		var foundWithPSID = false;
		var foundWithExtendedPSID = false;
		var foundWithExpiredJWTToken = false;
		
		if( structKeyExists(requestHeaders,'Headers') && structKeyExists(requestHeaders.Headers,'Auth-Token')){
			
			var token = replace(requestHeaders.Headers['Auth-Token'], 'Bearer ', '');
			var jwt = this.getHibachiJWTService().getJwtByToken(token);
			try{
				var decodedJwt = jwt.decode(ignoreExpiration=true);
				var payload = jwt.getPayload();
				var sessionEntity = this.getSession( payload.sessionID, true);
				var currentTime = getService('hibachiUtilityService').getCurrentUtcTime();
				if(currentTime < payload.iat || currentTime > payload.exp){
					foundWithExpiredJWTToken = true;
				}
			}catch(any e){
				var sessionEntity = this.newSession();
			}
		
		}else if( len(getHibachiScope().getSessionValue(sessionValue)) ) {
			
			var sessionEntity = this.getSession( getHibachiScope().getSessionValue(sessionValue), true);
			
		} else if( (StructKeyExists(request,'context') && StructKeyExists(request.context, "jsonRequest") && request.context.jsonRequest && StructKeyExists(request.context.deserializedJsonData, "request_token") ) || StructKeyExists(requestHeaders.headers, "request_token") ){
			
				//If the API 'cookie' and deviceID were passed directly to the API, we can use that for setting the session if the request token matches
				//the token we already have.
				
				//Find the request token in the json or in the headers if it exists.
				var rt = "";
				if (StructKeyExists(request.context, "jsonRequest") && request.context.jsonRequest){
					rt = request.context.deserializedJsonData["request_token"];
				}
				if (StructKeyExists(requestHeaders.headers, "request_token")){
					rt = requestHeaders.headers["request_token"];
				}

				//set the session
				var NPSID = rt;
				var sessionEntity = this.getSessionBySessionCookie('sessionCookieNPSID', NPSID, true );
				foundWithNPSID = true;
				getHibachiScope().setSessionValue(sessionValue, sessionEntity.getSessionID());
				request.context["foundWithRequestToken"] = true;
				
				/*
				if ( StructKeyExists(request.context, "deviceID") && !Len(sessionEntity.getDeviceID())){
					//If the device doesn't yet exist, add it.'
					sessionEntity.setDeviceID("#request.context.deviceID#");
					foundWithNPSID = true;
					getHibachiScope().setSessionValue('sessionID', sessionEntity.getSessionID());
				}else if (( StructKeyExists(requestHeaders.headers, "deviceID") && Len(sessionEntity.getDeviceID()) )){
					//If the device already exists, check against that device to the new device id.
					if (requestHeaders.headers.deviceID == sessionEntity.getDeviceID()){
						foundWithNPSID = true;
						getHibachiScope().setSessionValue('sessionID', sessionEntity.getSessionID()); //We have the correct device for this session.
					}else{
						//we don't have the correct device for this session so dont set the session
						foundWithNPSID = false;
					}
				}
				*/
		
		} else if(structKeyExists(cookie, "#cookiePrefix#-ExtendedPSID")) {
			
			var sessionEntity = this.getSessionBySessionCookie('sessionCookieExtendedPSID', cookie["#cookiePrefix#-ExtendedPSID"], true);

		
			if(sessionEntity.getNewFlag()) {
				getHibachiTagService().cfcookie(name="#cookiePrefix#-ExtendedPSID", value='', expires="#getHibachiScope().setting('globalExtendedSessionAutoLogoutInDays')#");
			} else {
		
				foundWithExtendedPSID = true;
				getHibachiScope().setSessionValue(sessionValue, sessionEntity.getSessionID());
		
			}
			
		} else if(structKeyExists(cookie, "#cookiePrefix#-NPSID")) {

			var sessionEntity = this.getSessionBySessionCookie('sessionCookieNPSID', cookie["#cookiePrefix#-NPSID"], true);
		
			if(sessionEntity.getNewFlag()) {
				getHibachiTagService().cfcookie(name="#cookiePrefix#-NPSID", value='', expires="#now()#");
			} else {
		
				foundWithNPSID = true;
				getHibachiScope().setSessionValue(sessionValue, sessionEntity.getSessionID());
		
			}
		
		} else if(structKeyExists(cookie, "#cookiePrefix#-PSID")) {
			

			var sessionEntity = this.getSessionBySessionCookie('sessionCookiePSID', cookie["#cookiePrefix#-PSID"], true);
		
			if(sessionEntity.getNewFlag()) {
				getHibachiTagService().cfcookie(name="#cookiePrefix#-PSID", value='', expires="#now()#");
			} else {
				foundWithPSID = true;
				getHibachiScope().setSessionValue(sessionValue, sessionEntity.getSessionID());
			}
		
		
		} else if(StructKeyExists(requestHeaders.headers, "request_token")) {
			request.context["foundWithAuthToken"] = true;
		
		} else {
			var sessionEntity = this.newSession();
		
		}
		
		// Populate the hibachi scope with the session
		if (!isNull(currentRequestSite)){
			sessionEntity.setSite(currentRequestSite);
		}
		
		getHibachiScope().setSession( sessionEntity );
		
		// Let the hibachiScope know how we found the proper sessionID
		getHibachiScope().setSessionFoundNPSIDCookieFlag( foundWithNPSID );
		getHibachiScope().setSessionFoundPSIDCookieFlag( foundWithPSID );
		getHibachiScope().setSessionFoundExtendedPSIDCookieFlag( foundWithExtendedPSID );
		getHibachiScope().setSessionfoundWithExpiredJwtToken( foundWithExpiredJWTToken );
		
		// Variable to store the last request dateTime of a session
		var previousRequestDateTime = getHibachiScope().getSession().getLastRequestDateTime();
		
		//set a value if previous request dateTime is null.
		if (isNull(previousRequestDateTime)){
			previousRequestDateTime = now();
		}
		
		// update the sessionScope with the ID for the next request
		getHibachiScope().setSessionValue(sessionValue, getHibachiScope().getSession().getSessionID());
		
		if(!isNull(getHibachiScope().getSession().getRBLocale())) {
			getHibachiScope().setRBLocale( getHibachiScope().getSession().getRBLocale() );
		
		}
		

		var isPreviouslyLoggedInAccount = ( 
				getHibachiScope().getSessionFoundPSIDCookieFlag() 
				|| getHibachiScope().getSessionFoundExtendedPSIDCookieFlag() 
				|| getHibachiScope().getSessionFoundNPSIDCookieFlag()
				|| getHibachiScope().getSessionfoundWithExpiredJwtToken()
			) 
			&& !getHibachiScope().getLoggedInFlag() && !isNull(getHibachiScope().getSession().getAccountAuthentication());
				
		var forceLogout = !isNull(getHibachiScope().getSession().getAccountAuthentication()) && getHibachiScope().getSession().getAccountAuthentication().getForceLogoutFlag();
		
		var isGuestAccount = isNull( getHibachiScope().getSession().getAccountAuthentication()) && getHibachiScope().getLoggedInFlag();
		
		var adminAutoLogout = !isNull(getHibachiScope().getSession().getAccountAuthentication()) 
			&& getHibachiScope().getSession().getAccount().getAdminAccountFlag() == true 
			&& !isNull(previousRequestDateTime) 
			&& DateDiff('n', previousRequestDateTime, Now()) >= getHibachiScope().setting('globalAdminAutoLogoutMinutes');
				
		var adminCookie = !isNull(getHibachiScope().getSession().getAccountAuthentication()) 
			&& getHibachiScope().getSession().getAccount().getAdminAccountFlag() == true 
			&& getHibachiScope().getSessionFoundPSIDCookieFlag();
				
		var publicAutoLogout = !isNull(getHibachiScope().getSession().getAccountAuthentication()) 
			&& getHibachiScope().getSession().getAccount().getAdminAccountFlag() != true 
			&& !isNull(previousRequestDateTime) 
			&& DateDiff('n', previousRequestDateTime, Now()) >= getHibachiScope().setting('globalPublicAutoLogoutMinutes');
		
		
		if( isPreviouslyLoggedInAccount || forceLogout || isGuestAccount || adminAutoLogout || adminCookie || publicAutoLogout ) 	{
			//check fo soft logout. 
			//has the extended cookie and if not an admin and we are using those extended cookies via the setting then soft logout instead of hard. . .
			if ( structKeyExists(cookie, "#cookiePrefix#-ExtendedPSID") &&
				!getHibachiScope().getSession().getAccount().getAdminAccountFlag() && 
				 getHibachiScope().setting('globalUseExtendedSession')==1){
				 	
				//go into extended session mode.
				logoutAccount(softLogout=true);	
			} else {
				logoutAccount(softLogout=false);
			}
		}

		// Update the last request datetime, and IP Address now that all other checks have completed.
		getHibachiScope().getSession().setLastRequestDateTime( now() );
		getHibachiScope().getSession().setLastRequestIPAddress( getRemoteAddress() );
		
	}
	
	public any function getSessionBySessionCookie(required any cookieName, required any cookieValue,boolean isNew=false){
		var sessionEntity = getDAO('accountDAO').getSessionBySessionCookie(argumentCollection=arguments);
		if(isNew && isNull(sessionEntity)){
			return this.newSession();
		}
		return sessionEntity;
 	}
	
	public void function persistSession(boolean updateLoginCookies=false) {
		
		var sessionValue = "sessionID";
		var cookiePrefix = getApplicationValue('applicationKey');
		
		if(!getHibachiScope().getLoggedInFlag()) {
			
			var currentRequestSite = getHibachiScope().getCurrentRequestSite();
			
			var cookiePrefixArgs = {};
			
			if (!isNull(currentRequestSite)){
				sessionValue = currentRequestSite.getSiteCode() & '-' & sessionValue;
				cookiePrefixArgs['currentRequestSite'] = currentRequestSite;
			}
			
			cookiePrefix = getCookiePrefix(argumentCollection=cookiePrefixArgs);
			
		}
		
		// Save the session
		getHibachiDAO().save( getHibachiScope().getSession() );
		getHibachiDAO().flushORMSession();
		
		// Save session ID in the session Scope & cookie scope for next request
		getHibachiScope().setSessionValue(sessionValue, getHibachiScope().getSession().getSessionID());
		
		if (arguments.updateLoginCookies == true){
			
			//Generate new session cookies for every time the session is persisted (on every login);
			//This cookie is removed on browser close
			var npCookieValue = getValueForCookie();
				getHibachiScope().getSession().setSessionCookieNPSID(npCookieValue);
				getHibachiTagService().cfcookie(name="#cookiePrefix#-NPSID", value=getHibachiScope().getSession().getSessionCookieNPSID());
		    
		    //This cookie never expires.
		    var cookieValue = getValueForCookie();
				getHibachiScope().getSession().setSessionCookiePSID(cookieValue);
				getHibachiTagService().cfcookie(name="#cookiePrefix#-PSID", value=getHibachiScope().getSession().getSessionCookiePSID(), expires="never");
			
			//only set this if the use is not an admin user and we are using extended sessions.
			var globalExtendedSessionAutoLogoutInDays = getHibachiScope().setting('globalExtendedSessionAutoLogoutInDays'); 
			if(len(globalExtendedSessionAutoLogoutInDays) == 0){
				globalExtendedSessionAutoLogoutInDays = 0;
			}
			var globalUseExtendedSession = getHibachiScope().setting('globalUseExtendedSession'); 
			if(len(globalUseExtendedSession) == 0){
				globalUseExtendedSession = false; 
			}			
	
			if (!getHibachiScope().getAccount().getAdminAccountFlag() && globalExtendedSessionAutoLogoutInDays && globalUseExtendedSession ){
				var cookieValue = getValueForCookie();
				getHibachiScope().getSession().setSessionCookieExtendedPSID(cookieValue);
				getHibachiTagService().cfcookie(name="#cookiePrefix#-ExtendedPSID", value=getHibachiScope().getSession().getSessionCookieExtendedPSID(), expires="#globalExtendedSessionAutoLogoutInDays#");
			}
			
			getHibachiDAO().flushORMSession();
			
		}
	}
	
	public string function loginAccount(required any account, required any accountAuthentication) {
	
		var currentSession = getHibachiScope().getSession();
		currentSession.setAccount( arguments.account );
		currentSession.setAccountAuthentication( arguments.accountAuthentication );
	    currentSession.setLoggedInDateTime(DateTimeFormat(now()));
		
		// Make sure that we persist the session
		persistSession(updateLoginCookies=true);
	
		var auditLogData = {
	
			account = arguments.account
	
		};
		
		getHibachiAuditService().logAccountActivity( "login", auditLogData );
		getHibachiEventService().announceEvent("onSessionAccountLogin");
		
	}
	
	/** Logs out the user completely. */
	public void function logoutAccount(boolean softLogout=false) {

		var currentSession = getHibachiScope().getSession();
		var auditLogData = {};
	
		if(!isNull(currentSession.getAccount())) {
			auditLogData.account = currentSession.getAccount();
		}
		
		//No need to remove the account or authentication. We just set the state to being logged out.
		currentSession.setLoggedOutDateTime(DateTimeFormat(now()));
		
		// Update the last request datetime, and IP Address now that all other checks have completed.
		currentSession.setLastRequestDateTime( now() );
		currentSession.setLastRequestIPAddress( getRemoteAddress() );
		if (arguments.softLogout == false){
			
			var oldSession = currentSession;
			
			var newSession = this.newSession();
			
			//if the settings are set for copying the cart over, then copy it.
			if ( len(getHibachiScope().setting('globalCopyCartToNewSessionOnLogout')) &&  getHibachiScope().setting('globalCopyCartToNewSessionOnLogout') && !isNull(oldSession.getOrder())){
				getHibachiDAO().save( oldSession.getOrder() );
				if (!oldSession.getOrder().hasErrors()){
					newSession.setOrder(oldSession.getOrder());
				}
			}
			getHibachiScope().setSession(newSession);
			getHibachiDAO().save( newSession );
			getHibachiDAO().flushORMSession();
			
		}
		var isAdminSoftLogout = arguments.softLogout == false || currentSession.getAccount().getAdminAccountFlag();
		
		var applicationKey = getApplicationValue('applicationKey');
		//Remove the cookies. Forgets the user if they intentionally click logout (on public computer for example)
		if(structKeyExists(cookie, "#applicationKey#-NPSID")){
			getHibachiTagService().cfcookie(name="#applicationKey#-NPSID", value='', expires="#now()#");
			structDelete(cookie,"#applicationKey#-NPSID", true);
			getHibachiScope().setSessionFoundNPSIDCookieFlag( false );
		}
		
		if(structKeyExists(cookie, "#applicationKey#-PSID")){
			getHibachiTagService().cfcookie(name="#applicationKey#-PSID", value='', expires="#now()#");
			structDelete(cookie,"#applicationKey#-PSID", true);
			getHibachiScope().setSessionFoundPSIDCookieFlag( false );
		}
		
		//only delete this extended session cookie if this is a hard logout instead of soft.
		if((structKeyExists(cookie, "#applicationKey#-ExtendedPSID") && arguments.softLogout == false) || (structKeyExists(cookie, "#applicationKey#-ExtendedPSID") && currentSession.getAccount().getAdminAccountFlag())){
			getHibachiTagService().cfcookie(name="#applicationKey#-ExtendedPSID", value='', expires="#now()#");
			structDelete(cookie,"#applicationKey#-ExtendedPSID", true);
			getHibachiScope().setSessionFoundExtendedPSIDCookieFlag( false );
		}
		
		getHibachiScope().setSessionValue('sessionID', getHibachiScope().getSession().getSessionID());
		// Make sure that we persist the session
		persistSession(updateLoginCookies=false);
		
		// Make sure that this logout is persisted
		getHibachiDAO().flushORMSession();
		getHibachiAuditService().logAccountActivity("logout", auditLogData);
		if (softLogout == false){
			getHibachiEventService().announceEvent("onSessionAccountLogout");
		}
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processSession_authorizeAccount(required any session, required any processObject) {
		
		// Take the email address and get all of the user accounts by primary e-mail address
		var accountAuthentications = getAccountService().getInternalAccountAuthenticationsByEmailAddress(emailAddress=arguments.processObject.getEmailAddress());
	
		if(arrayLen(accountAuthentications)) {
			
			for(var i=1; i<=arrayLen(accountAuthentications); i++) {
				// If the password matches what it should be, then set the account in the session and 
		
				if(!isNull(accountAuthentications[i].getPassword()) && len(accountAuthentications[i].getPassword()) && accountAuthentications[i].getPassword() == getAccountService().getHashedAndSaltedPassword(password=arguments.processObject.getPassword(), salt=accountAuthentications[i].getAccountAuthenticationID())) {
					loginAccount( accountAuthentications[i].getAccount(), accountAuthentications[i] );
					return arguments.session;
				}
		
			}
	
			arguments.processObject.addError('password', rbKey('validate.session_authorizeAccount.password.incorrect'));
			
		} else {
			
			arguments.processObject.addError('emailAddress', rbKey('validate.session_authorizeAccount.emailAddress.notfound'));
			
		}
	
		return arguments.session;
	
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
	// ================== START: Private Helper Functions =====================
	
	/**
	* @deprecated getSessionIDEncryptedCookie
	*/
	private any function getSessionIDEncryptedCookie( required any sessionID, required string cookieType ) {
		return getHibachiUtilityService().encryptValue(value=arguments.sessionID, salt="valid-#arguments.cookieType#-#getApplicationKey()#SessionIDCookie");
	} 
	
	/*
	* @deprecated getSessionIDFromEncryptedCookie
	*/
	private any function getSessionIDFromEncryptedCookie( required any cookieData, required string cookieType ) {
		return getHibachiUtilityService().decryptValue(value=arguments.cookieData, salt="valid-#arguments.cookieType#-#getApplicationKey()#SessionIDCookie");
	}
	
	/**
	 * Generate new cookie value
	 */
	private any function getValueForCookie(){
		var id = getHibachiScope().getSession().getSessionID();
		var hashedID = hash(id, "md5");
		var uuid = replace(createUUID(),'-','','all');
		var final = hashedID & uuid;
		return final;
	}
	// ==================  END:  Private Helper Functions =====================
	
	// =================== START: Deprecated Functions ========================
	
	// ===================  END: Deprecated Functions =========================

}
