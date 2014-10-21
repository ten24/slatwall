component output="false" accessors="true" extends="HibachiService"  {

	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="hibachiAuditService" type="any";
	property name="hibachiTagService" type="any";
	

	// ===================== START: Logical Methods ===========================
	
	public void function setPropperSession() {
		var sessionFoundWithCookie = false;
		
		// Check to see if a session value doesn't exist, then we can check for a cookie... or just set it to blank
		if(!hasSessionValue("sessionID")) {
			setSessionValue('sessionID', '');
		}
		
		// Load Session
		if( len(getSessionValue('sessionID')) ) {
			var sessionEntity = this.getSession( getSessionValue('sessionID'), true);
		} else if(structKeyExists(cookie, "#getApplicationValue('applicationKey')#SessionID")) {
			setSessionValue('sessionID', cookie["#getApplicationValue('applicationKey')#SessionID"]);
			var sessionEntity = this.getSession( getSessionValue('sessionID'), true);
			if(sessionEntity.getNewFlag()) {
				getHibachiTagService().cfcookie(name="#getApplicationValue('applicationKey')#SessionID", value='', expires="now");
			} else {
				sessionFoundWithCookie = true;
			}
		} else {
			var sessionEntity = this.newSession();
		}
		
		// Populate the hibachi scope with the session
		getHibachiScope().setSession( sessionEntity );
		
		// Variable to store the last request dateTime of a session
		var previousRequestDateTime = getHibachiScope().getSession().getLastRequestDateTime();

		// update the sessionScope with the ID for the next request
		setSessionValue('sessionID', getHibachiScope().getSession().getSessionID());
		
		// Update the last request datetime, and IP Address
		getHibachiScope().getSession().setLastRequestDateTime( now() );
		getHibachiScope().getSession().setLastRequestIPAddress( CGI.REMOTE_ADDR );
		
		if(!isNull(getHibachiScope().getSession().getRBLocale())) {
			getHibachiScope().setRBLocale( getHibachiScope().getSession().getRBLocale() );
		}
		
		// If the session has an account but no authentication, then remove the account
		// Check to see if this session has an accountAuthentication, if it does then we need to verify that the authentication shouldn't be auto logged out
		// If there was an integration, then check the verify method for any custom auto-logout logic
		// If the sessions account is and admin and last request by the session was 15 min or longer ago. 
		if(
			(sessionFoundWithCookie && getHibachiScope().getLoggedInFlag()) 
			|| (!isNull(getHibachiScope().getSession().getAccountAuthentication()) && getHibachiScope().getSession().getAccountAuthentication().getForceLogoutFlag()) 
			|| (isNull(getHibachiScope().getSession().getAccountAuthentication()) && getHibachiScope().getLoggedInFlag())
			|| (!isNull(getHibachiScope().getSession().getAccountAuthentication()) && getHibachiScope().getSession().getAccount().getAdminAccountFlag() && DateDiff('n', previousRequestDateTime, Now()) >= 15 )
			) {
			logoutAccount();
		}
	}
	
	public void function persistSession() {
		// Save the session
		getHibachiDAO().save( getHibachiScope().getSession() );
		
		// Save session ID in the session Scope & cookie scope for next request
		setSessionValue('sessionID', getHibachiScope().getSession().getSessionID());
		
		if(!structKeyExists(cookie, "#getApplicationValue('applicationKey')#SessionID") || cookie[ "#getApplicationValue('applicationKey')#SessionID" ] != getHibachiScope().getSession().getSessionID()) {
			getHibachiTagService().cfcookie(name="#getApplicationValue('applicationKey')#SessionID", value=getHibachiScope().getSession().getSessionID(), expires="never");
		}
	}
	
	public string function loginAccount(required any account, required any accountAuthentication) {
		var currentSession = getHibachiScope().getSession();
		
		currentSession.setAccount( arguments.account );
		currentSession.setAccountAuthentication( arguments.accountAuthentication );
		
		// Make sure that we persist the session
		persistSession();
		
		// Make sure that this login is persisted
		getHibachiDAO().flushORMSession();
		
		var auditLogData = {
			account = arguments.account
		};
		getHibachiAuditService().logAccountActivity( "login", auditLogData );
		getHibachiEventService().announceEvent("onSessionAccountLogin");
	}
	
	public void function logoutAccount() {
		
		var currentSession = getHibachiScope().getSession();
		
		var auditLogData = {};
		if(!isNull(currentSession.getAccount())) {
			auditLogData.account = currentSession.getAccount();
		}		
		
		currentSession.removeAccount();
		currentSession.removeAccountAuthentication();
		
		// Make sure that this logout is persisted
		getHibachiDAO().flushORMSession();
		
		getHibachiAuditService().logAccountActivity("logout", auditLogData);
		getHibachiEventService().announceEvent("onSessionAccountLogout");
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
	
}
