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
/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
/**
	*@description This Access class was generated using the cfc component located in /Slatwall/model/entity
 	*@displayname "Access"
 	*@entityname "SlatwallAccess"
 	*@table "SwAccess"
 	*@persistent "true"
 	*@accessors "true"
 	*@extends "HibachiEntity"
 	*@cacheuse "transactional"
 	*@hb_serviceName "accessService"
*/
module slatwall {  
     export class Access  {
             /**
             *@name "accessID"
             *@ormtype "string"
             *@length "32"
             *@fieldtype "id"
             *@generator "uuid"
             *@unsavedvalue ""
             *@default ""
             */
             private accessID: any;
             /**
             *@name "accessCode"
             *@ormtype "string"
             */
            private accessCode: string;
             /**
             *@name "subscriptionUsage"
             *@cfc "SubscriptionUsage"
             *@fieldtype "many-to-one"
             *@fkcolumn "subscriptionUsageID"
             *@hb_optionsNullRBKey "define.select"
             */
             private subscriptionUsage: any;
             /**
             *@name "subscriptionUsageBenefit"
             *@cfc "SubscriptionUsageBenefit"
             *@fieldtype "many-to-one"
             *@fkcolumn "subscriptionUsageBenefitID"
             *@hb_optionsNullRBKey "define.select"
             */
             private subscriptionUsageBenefit: any;
             /**
             *@name "subscriptionUsageBenefitAccount"
             *@cfc "SubscriptionUsageBenefitAccount"
             *@fieldtype "many-to-one"
             *@fkcolumn "subsUsageBenefitAccountID"
             *@hb_optionsNullRBKey "define.select"
             */
             private subscriptionUsageBenefitAccount: any;
             /**
             *@name "remoteID"
             *@ormtype "string"
             */
            private remoteID: string;
             /**
             *@name "createdDateTime"
             *@hb_populateEnabled "false"
             *@ormtype "timestamp"
             */
             private createdDateTime: string;
             /**
             *@name "createdByAccountID"
             *@hb_populateEnabled "false"
             *@ormtype "string"
             */
            private createdByAccountID: string;
             /**
             *@name "modifiedDateTime"
             *@hb_populateEnabled "false"
             *@ormtype "timestamp"
             */
             private modifiedDateTime: string;
             /**
             *@name "modifiedByAccountID"
             *@hb_populateEnabled "false"
             *@ormtype "string"
             */
            private modifiedByAccountID: string;
			/** GETTERS AND SETTERS */
			getSubscriptionUsage():any { return this.subscriptionUsage; }
			setSubscriptionUsage(subscriptionUsage:any) {this.subscriptionUsage = subscriptionUsage;}         
			getCreatedByAccountID():string { return this.createdByAccountID; }
			setCreatedByAccountID(createdByAccountID:string) {this.createdByAccountID = createdByAccountID;}         
			getAccessID():any { return this.accessID; }
			setAccessID(accessID:any) {this.accessID = accessID;}         
			getSubscriptionUsageBenefit():any { return this.subscriptionUsageBenefit; }
			setSubscriptionUsageBenefit(subscriptionUsageBenefit:any) {this.subscriptionUsageBenefit = subscriptionUsageBenefit;}         
			getCreatedDateTime():string { return this.createdDateTime; }
			setCreatedDateTime(createdDateTime:string) {this.createdDateTime = createdDateTime;}         
			getRemoteID():string { return this.remoteID; }
			setRemoteID(remoteID:string) {this.remoteID = remoteID;}         
			getModifiedDateTime():string { return this.modifiedDateTime; }
			setModifiedDateTime(modifiedDateTime:string) {this.modifiedDateTime = modifiedDateTime;}         
			getModifiedByAccountID():string { return this.modifiedByAccountID; }
			setModifiedByAccountID(modifiedByAccountID:string) {this.modifiedByAccountID = modifiedByAccountID;}         
			getAccessCode():string { return this.accessCode; }
			setAccessCode(accessCode:string) {this.accessCode = accessCode;}         
			getSubscriptionUsageBenefitAccount():any { return this.subscriptionUsageBenefitAccount; }
			setSubscriptionUsageBenefitAccount(subscriptionUsageBenefitAccount:any) {this.subscriptionUsageBenefitAccount = subscriptionUsageBenefitAccount;}         
    }//<--end class
}//<--end module
