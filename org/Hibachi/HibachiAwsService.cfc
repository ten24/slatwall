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

component extends="HibachiService" accessors="true" {

    public struct function snsReceive( required struct snsPayload ) {

        var resultData = {};

        // Reference to data received from AWS SNS
        resultData.snsPayload = arguments.snsPayload;

        // Response status to send back to AWS SNS
        responseStatus = {statusCode = 200, statusText = "OK"}; 
        resultData.responseStatus = responseStatus; 

        if (verifyAwsSignature()) {

            // Confirm SNS subscription automatically
            if (arguments.snsPayload.type == 'SubscriptionConfirmation') {

                // Make HTTP request to AWS SNS server to confirm subscription
                var httpConfirmationRequest = new http();
                httpConfirmationRequest.setUrl(arguments.snsPayload.subscribeURL);
                httpConfirmationRequest.setMethod('GET');
                httpConfirmationRequest.setCharset('utf-8');
                var httpConfirmationResponse = httpConfirmationRequest.send().getPrefix();

                // Error attempting to confirm subscription
                if (httpConfirmationResponse.status_code != 200) {
                    var errorMessage = xmlSearch(xmlParse(httpConfirmationResponse.fileContent), "//*[local-name() = 'Message']")[1].xmlText;
                    logHibachi("AWS SNS Auto subscribe confirmation failed. AWS SNS responded with status code: #httpConfirmationResponse.status_code#, message: '#errorMessage#'");
                
                // Successfully confirmed subscription
                } else {
                    logHibachi("AWS SNS Auto subscribe confirmation success.");
                }
    
            // Handle general notifications (expecting message to be serialized JSON text)
            } else if (arguments.snsPayload.type == 'Notification') {
                if (isJSON(arguments.snsPayload.message)) {
                    arguments.snsPayload.message = deserializeJSON(arguments.snsPayload.message);
    
                    // Automatically retrieve S3 object if not named "AMAZON_SES_SETUP_NOTIFICATION" and not spam or a virus verdict.
                    if (structKeyExists(arguments.snsPayload.message, 'receipt') && structKeyExists(arguments.snsPayload.message.receipt, 'action') && structKeyExists(arguments.snsPayload.message.receipt.action, 'type') && arguments.snsPayload.message.receipt.action.type == 'S3') {
                        var retrieveFromS3Args = {};
                        retrieveFromS3Args.objectKey = arguments.snsPayload.message.receipt.action.objectKey;
                        retrieveFromS3Args.bucketName = arguments.snsPayload.message.receipt.action.bucketName;
                        retrieveFromS3Args.objectKeyPrefix = arguments.snsPayload.message.receipt.action.objectKeyPrefix;
                        retrieveFromS3Args.awsAccessKeyId = '';
                        retrieveFromS3Args.awsSecretAccessKey = '';
                        retrieveFromS3Args.deleteS3ObjectAfter = false;

                        arguments.snsPayload.s3FileData = getHibachiUtilityService().retrieveFromS3(argumentCollection = retrieveFromS3Args);
                    }
                }

                // Announce event with the data
                getHibachiEventService().announceEvent(eventName="onAwsSnsReceive", eventData=resultData);
            
            // Error further implementation required to handle notification type
            } else {
                logHibachi("Need to further implement handling for SNS notifications of type '#snsPayload.type#'.");
                responseStatus.statusCode = 501;
                responseStatus.statusText = "Not implemented to handle '#snsPayload.type#'";
            }

        }

        return resultData;
    }

    /**
     * Check to prevent processing a spoofed requests
     * TODO: Needs params specified, extend to rely on Slatwall settings within model/service/HibachiAwsService
     */
    public boolean function verifyAwsSignature() {
        return true;
    }
}