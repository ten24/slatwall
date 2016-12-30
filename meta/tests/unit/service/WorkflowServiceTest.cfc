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
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		
		variables.service = request.slatwallScope.getBean("workflowService");
	}
	
	/*public void function processWorkflow_execute_Test(){
		var orderData = {
			orderID = ''
			
			
		};
		var order = createPersistedTestEntity('order',orderData);
		
		
		var workflowEntityData = {
			workflowid = '',
			workflowName = 'testWorkflow',
			workflowObject = 'Product',
			activeFlag=true,
			workflowTriggers = [
				{
					workflowTriggerID = '',
					triggerType = 'Event',
					objectPropertyIdentifier = '',
					triggerEvent="afterProductSaveSuccess"
				}
			],
			workflowTasks = [
				{
					workflowTaskID="",
					taskName="testTask",
					taskConditionsConfig='[
						{
							"workflowConditionGroup":[
								{
									"propertyIdentifier":"order.orderID",
									"comparisonOperator":"required",
									"value":"true"
								}
							]
									
						}
					]',
					workflowTaskActions=[
						{
							workflowTaskActionID='',
							actionType='update',
							updateData='{"staticData":{"orderNumber":"123"}}'
						}
					]
				}
			]
		};
		var workflowEntity = createPersistedTestEntity('workflow',workflowEntityData);
		
		var data = {
			
		};
		data = {
			entity=order,
			workflowTrigger={
				workflowTriggerID = '',
				triggerType = 'Event',
				objectPropertyIdentifier = '',
				triggerEvent="afterOrderSaveSuccess"
			}
		};
		variables.service.processWorkflow_execute(workflowEntity,data);
		
		////addToDebug(workflowEntity.getWorkflowID());
	}*/
	
	public void function entityPassesAllWorkflowTaskConditionsTest(){
		var productData = {
			productid = '',
			productName = 'testproduct1',
			skus = [
				{
					skuID = "",
					price = 3
				}
			]
			
		};
		var product = createPersistedTestEntity('product',productData);
		Product.setDefaultSku(Product.getSkus()[1]);
		
		var workflowTasksConditionsConfig = '{  
		   "filterGroups":[  
		      {  
		         "filterGroup":[  
		            {  
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"True",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {  
		            	"logicalOperator":"AND",
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"True",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {  
		            	"logicalOperator":"OR",
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"false",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {
		            	"logicalOperator":"AND",
		            	"filterGroup":[
			            	 {  
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"True",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            },
				            {  
				            	"logicalOperator":"AND",
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"True",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            },
				            {  
				            	"logicalOperator":"OR",
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"false",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            }
		            	]
		            }
		         ]
		      }
		   ],
		   "baseEntityAlias":"Product",
		   "baseEntityName":"Product"
		}';
		var workflowTasksConditionsConfigStruct = deserializeJson(workflowTasksConditionsConfig);
		MakePublic(variables.service,'entityPassesAllWorkflowTaskConditions');
			MakePublic(variables.service,'getWorkflowConditionGroupsString');
		var conditionsGroupString = variables.service.getWorkflowConditionGroupsString(product,workflowTasksConditionsConfigStruct.filterGroups);	
		addToDebug(conditionsGroupString);
		var evalString = variables.service.entityPassesAllWorkflowTaskConditions(product, workflowTasksConditionsConfigStruct);
		addToDebug(evalString);
	}
	
	public void function getWOrkflowConditionGroupStringTest(){
		var productData = {
			productid = '',
			productName = 'testproduct1',
			skus = [
				{
					skuID = "",
					price = 3
				}
			]
			
		};
		var product = createPersistedTestEntity('product',productData);
		Product.setDefaultSku(Product.getSkus()[1]);
		
		var workflowTasksConditionsConfig = '[  
		      {  
		         "filterGroup":[  
		            {  
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"True",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {  
		            	"logicalOperator":"AND",
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"True",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {  
		            	"logicalOperator":"OR",
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"false",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {
		            	"logicalOperator":"AND",
		            	"filterGroup":[
			            	 {  
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"True",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            },
				            {  
				            	"logicalOperator":"AND",
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"True",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            },
				            {  
				            	"logicalOperator":"OR",
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"false",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            }
		            	]
		            }
		         ]
		      }
		   ]';
		var workflowTasksConditionsConfigStruct = deserializeJson(workflowTasksConditionsConfig);
		MakePublic(variables.service,'getWorkflowConditionGroupString');
		var conditionsGroupString = variables.service.getWorkflowConditionGroupString(product,workflowTasksConditionsConfigStruct);	
		addToDebug(conditionsGroupString);
	}
	
	public void function getValidationValue(){
		var productData = {
			productid = '',
			productName = 'testproduct1',
			skus = [
				{
					skuID = "",
					price = 3
				}
			],
			activeFlag=true
			
		};
		var product = createPersistedTestEntity('product',productData);
		Product.setDefaultSku(Product.getSkus()[1]);
		var test = request.slatwallScope.getBean("HibachiValidationService").invokeMethod('validate_eq',{1=product, 2='activeFlag', 3='true'});
		addToDebug(test);
	}
	
	public void function getWorkflowConditionGroupsStringTest(){
		var productData = {
			productid = '',
			productName = 'testproduct1',
			skus = [
				{
					skuID = "",
					price = 3
				}
			]
			
		};
		var product = createPersistedTestEntity('product',productData);
		Product.setDefaultSku(Product.getSkus()[1]);
		
		var workflowTasksConditionsConfig = '[  
		      {  
		         "filterGroup":[  
		            {  
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"True",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {  
		            	"logicalOperator":"AND",
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"True",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {  
		            	"logicalOperator":"OR",
		               "displayPropertyIdentifier":"Active",
		               "propertyIdentifier":"Product.activeFlag",
		               "comparisonOperator":"eq",
		               "breadCrumbs":[  
		                  {  
		                     "rbKey":"Product",
		                     "entityAlias":"Product",
		                     "cfc":"Product",
		                     "propertyIdentifier":"Product"
		                  }
		               ],
		               "value":"false",
		               "displayValue":"True",
		               "ormtype":"boolean",
		               "conditionDisplay":"True"
		            },
		            {
		            	"logicalOperator":"AND",
		            	"filterGroup":[
			            	 {  
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"True",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            },
				            {  
				            	"logicalOperator":"AND",
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"True",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            },
				            {  
				            	"logicalOperator":"OR",
				               "displayPropertyIdentifier":"Active",
				               "propertyIdentifier":"Product.activeFlag",
				               "comparisonOperator":"eq",
				               "breadCrumbs":[  
				                  {  
				                     "rbKey":"Product",
				                     "entityAlias":"Product",
				                     "cfc":"Product",
				                     "propertyIdentifier":"Product"
				                  }
				               ],
				               "value":"false",
				               "displayValue":"True",
				               "ormtype":"boolean",
				               "conditionDisplay":"True"
				            }
		            	]
		            }
		         ]
		      }
		   ]
		   ';
		var workflowTasksConditionsConfigStruct = deserializeJson(workflowTasksConditionsConfig);
		MakePublic(variables.service,'getWorkflowConditionGroupsString');
		var conditionsGroupString = variables.service.getWorkflowConditionGroupsString(product,workflowTasksConditionsConfigStruct);	
		addToDebug(conditionsGroupString);
	}
	
	
}


