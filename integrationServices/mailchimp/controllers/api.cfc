component extends="Slatwall.org.Hibachi.HibachiController" accessors="true" output="false"{

	property name="fw";

	this.publicMethods = '';
	this.secureMethods = 'updateProsperWorkLead,createLead';
	
	public any function init(required any fw){
		setFW(arguments.fw);
		return this;
	}
	
	public any function before(requred any rc){
		getFW().setView("public:main.blank");
	}
	
	public any function createLead(required any rc){
		param name="rc.FirstName" default="";
		param name="rc.LastName" default="";
		param name="rc.emailAddress" default="";
		param name="rc.OrganizationName" default="";
		param name="rc.EmployeeCount" default="";
		param name="rc.Industry" default="";
		param name="rc.Description" default="";
		param name="rc.customer_source_id" default="";
		
		//Send Data over to MailChimp
		var chimpData = {};
		chimpData['email_address'] = trim(rc.emailAddress);
		
		/*	for this we can choose between pending, subscribed, unsubribed, clean 
				by using pending, mailchimp should send out a confirmation email to the user
		*/
		chimpData['status'] = 'subscribed';
		
		// Setup custom attributes
		chimpData['merge_fields'] = {};
		chimpData['merge_fields']['FNAME'] = trim(rc.firstName);
		chimpData['merge_fields']['LNAME'] = trim(rc.lastName);
 		chimpData['merge_fields']['PHONE'] = '';
 		chimpData['merge_fields']['COMPANY'] = trim(rc.organizationName);
		chimpData['merge_fields']['DOMAINURL'] = '' ;
		
		//Setup group data, aka interests
	 	var interestDataStruct = getHibachiScope().getService('MailchimpAPIService').getMailChimpInterestDataStruct();
	 	chimpData['interests'] = interestDataStruct;
	 		
 		if ( len(rc.EmployeeCount) && structKeyExists( chimpData['interests'], rc.EmployeeCount ) ){
 			chimpData['interests'][rc.EmployeeCount] = true;
 		}
 		
 		if ( len( rc.Industry ) AND structKeyExists(chimpData['interests'], rc.Industry ) ){
 			chimpData['interests'][rc.Industry] = true;
 		}
 		
 		if ( len(rc.customer_source_id) AND structKeyExists(chimpData['interests'], rc.customer_source_id ) ) {
 			chimpData['interests'][rc.customer_source_id] = true;
 		}
 		
		var serializedChimpData =serializeJson(chimpData);
		
		var chimpResponseData = getHibachiScope().getService('MailchimpAPIService').sendRequestToMailChimp(apiRoute="members" ,method='POST',jsonData=serializedChimpData);
		
		if ( structKeyExists(chimpResponseData, 'title') AND chimpResponseData.title EQ 'Member Exists') {
			//if user already exists, we're going to just update their data on mailchimp
			var existingUser = getHibachiScope().getService('MailchimpAPIService').sendRequestToMailChimp(apiRoute="members/#Hash(trim(rc.emailAddress), 'MD5')#" ,method='GET');
			
	 		if ( len(rc.EmployeeCount) && structKeyExists( existingUser['interests'], rc.EmployeeCount ) ){
 				existingUser['interests'][rc.EmployeeCount] = true;
	 		}
	 		
	 		if ( len( rc.Industry ) AND structKeyExists(existingUser['interests'], rc.Industry ) ){
	 			existingUser['interests'][rc.Industry] = true;
	 		}
	 		
	 		if ( len(rc.customer_source_id) AND structKeyExists(existingUser['interests'], rc.customer_source_id ) ) {
	 			existingUser['interests'][rc.customer_source_id] = true;
	 		}
	 		
	 		serializedChimpData =serializeJson(existingUser);
			
			chimpResponseData = getHibachiScope().getService('MailchimpAPIService').sendRequestToMailChimp(apiRoute="members/#Hash(trim(rc.emailAddress), 'MD5')#" ,method='PUT',jsonData=serializedChimpData);
				
		}
		
		//Send Lead doata over to PropserWorks
		var industryName = '';
		var employeeCountLabel = '';
		
		
		var prospData = {};
		prospData['name'] = trim(rc.firstName) & ' ' & trim(rc.lastName);
		prospData['company_name'] = trim(rc.OrganizationName);
		prospData['email'] = {"email": trim(rc.emailAddress)};
		prospData['details'] = trim(rc.Description);
		
		if ( len(rc.Industry) ){
			var industry =  getHibachiScope().getService('MailchimpAPIService').sendRequestToMailChimp(apiRoute='interest-categories/9a5899cd17/interests/#rc.Industry#', method='GET');
	
			if ( structKeyExists(industry, 'name') ){
				industryName = industry.name;
			}
		}
		
		if ( len(rc.EmployeeCount) ) {
			var employeeCount = getHibachiScope().getService('MailchimpAPIService').sendRequestToMailChimp(apiRoute='interest-categories/39712b5abd/interests/#rc.EmployeeCount#', method='GET');
			
			if ( structKeyExists(employeeCount, 'name') ) {
				employeeCountLabel = employeeCount.name;
			}
		}
		
		
		prospData['custom_fields'] = [
			{"custom_field_definition_id" : 95545, "value" : industryName},
			{"custom_field_definition_id" : 95546, "value" : employeeCountLabel}
		];
		
		
		if ( len( trim(rc.customer_source_id) ) ){
			prospData['customer_source_id'] = rc.customer_source_id;
		}else {
			prospData['customer_source_id'] = 360048;
		}
		
		var serializedProspData= serializeJson(prospData);
		var prospResponseData =  getHibachiScope().getService('MailchimpAPIService').postLeadToProsperWork(serializedProspData);

	}
	
	
	public void function updateProsperworkLeads(){
		
		var employeeCountResponse = getHibachiScope().getService('MailchimpAPIService').sendRequestToMailChimp(apiRoute='interest-categories/39712b5abd/interests/', method='GET');
		var employeCountStruct = {};
		
		for (var employeeCount in employeeCountResponse.interests){
			employeCountStruct[employeeCount.id] = employeeCount.name;
		}
		
		
		var requestData = {};
		requestData['page_size'] = 200;
		requestData['page_number'] = 4;
		requestData['sort_by'] = 'date_modified';
		requestData['sort_direction'] = 'asc';
		
		var serializedRequestData = serializeJson(requestData);
		var prospResponseData =  getHibachiScope().getService('MailchimpAPIService').getLeadsFromProsperWork(serializedRequestData);
		var responseData = deserializeJson(prospResponseData.fileContent);
		
		while (arrayLen(responseData) ){
			for (var lead in responseData){
				for (var customField in lead['custom_fields']){
					try {
						if (customField['custom_field_definition_id'] == 95546 && structKeyExists(customField, 'value') && structKeyExists(employeCountStruct, customField['value']) ){
							
							var leadData = {};
							leadData['custom_fields'] = [
								{"custom_field_definition_id" : 95546, "value" : employeCountStruct[ customField['value']]}
							];
							
							var serializedLeadData= serializeJson(leadData);
							var updateResponseData =  getHibachiScope().getService('MailchimpAPIService').updateProsperWorkLeads(serializedLeadData, lead.id );
							
						}
					} catch (any e){
						writeDump(e);
						writeDump(Lead);
						abort;
					}
				}
			
			}
			
			requestData['page_number']++;
			serializedRequestData = serializeJson(requestData);
			prospResponseData =  getHibachiScope().getService('MailchimpAPIService').getLeadsFromProsperWork(serializedRequestData);
			responseData = deserializeJson(prospResponseData.fileContent);
		}


		writeDump("FIN");
		abort;
	}
	


}
