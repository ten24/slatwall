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
	
	/**
	* @test
	*/
	public void function entityQueueTest() {
	        /*var orderSmartlist = request.slatwallScope.getService('hibachiService').getOrderSmartList();
    	    orderSmartList.addOrder('orderID|ASC');
    	    orderSmartlist.setPageRecordsShow(100);
	    	for(var order in orderSmartlist.getRecords()){
    	        order.updateCalculatedProperties();
    	    }*/

	    
	        usescrollableCollectionList();
	        //abort;
	}
	
	
	
	private void function usescrollableSmartList(){
		
		local.accountSmartlist = request.slatwallScope.getService('hibachiService').getAccountSmartList();
		accountSmartlist.addOrder('accountID|ASC');
		accountSmartlist.setPageRecordsShow(1);
		local.account=local.accountSmartlist.getPageRecords()[1];
		local.account.setFirstName("potato");
		
	    local.ormSession = ormGetSessionFactory().openSession();
	    local.tx = local.ormSession.beginTransaction();
		//Test smartList 
	
	    var orderSmartlist = request.slatwallScope.getService('hibachiService').getOrderSmartList();
	    orderSmartList.addOrder('orderID|ASC');
	    var totalRecords = 5;
	    orderSmartlist.setPageRecordsShow(totalRecords);
	    local.slScrollableRecords = orderSmartlist.getScrollableRecords(refresh=true,readOnlyMode=false,ormSession=local.ormSession);
		local.total = 0;
		local.i = 0;
		var entitiesToEvict = [];
		try{
			while (slScrollableRecords.next()) {
				local.i++;
				if (arrayLen(slScrollableRecords.get())){
				    local.order = slScrollableRecords.get()[1]; //returns an array of results, just need the first entity.
				    //local.str = local.i & local.audit.getAuditID() & local.audit.getAuditDateTime() & local.audit.getSessionAccountFullName() & local.audit.getSessionAccountEmailAddress() & local.audit.getAuditType() & local.audit.getTitle() & local.audit.getBaseObject()
				    //local.total += local.sku.getskuID();
				    // process row then release reference
				    //flush first before evict if not readOnlyMode and making changes to entities.
				    local.order.updateCalculatedProperties();
				    local.order.setOrderNumber(125);
				    debug(i);
				    debug(local.order.getOrderID());
				    arrayAppend(entitiesToEvict,local.order);
				    if(local.i % 20 == 0 || totalRecords==i){
				    	
				    	local.ormSession.flush();
				    	debug('flush');
				    	
				    	for(var entityToEvict in entitiesToEvict){
							local.ormSession.evict(entityToEvict);				    	
				    	}
				    	//local.ormSession.clear();
				    }
				    //local.ormSession.evict(local.order);
				    
			    }
			   
			    
			}
			
			local.slScrollableRecords.close(); //close the connection always!
		}catch(var scrollableError){
			local.slScrollableRecords.close(); 
			throw();
		}
		tx.commit();
		local.ormSession.close();
		
		
		ormflush();
	}
	
	private void function usescrollableCollectionList(){
		
	    local.ormSession = ormGetSessionFactory().openSession();
	    local.tx = local.ormSession.beginTransaction();
		//Test smartList 
	
	    var orderCollectionlist = request.slatwallScope.getService('hibachiService').getOrderCollectionList();
	    orderCollectionList.setDisplayProperties('fulfillmentChargeTotal');
	    orderCollectionlist.setOrderBy('orderID|ASC');
	    var totalRecords = 5;
	    orderCollectionlist.setPageRecordsShow(totalRecords);
	    local.slScrollableRecords = orderCollectionlist.getScrollableRecords(refresh=true,readOnlyMode=false,ormSession=local.ormSession);
		local.total = 0;
		local.i = 0;
		var entitiesToEvict = [];
		try{
			while (slScrollableRecords.next()) {
				local.i++;
				if (arrayLen(slScrollableRecords.get())){
				    local.order = slScrollableRecords.get()[1]; //returns an array of results, just need the first entity.
				    //local.str = local.i & local.audit.getAuditID() & local.audit.getAuditDateTime() & local.audit.getSessionAccountFullName() & local.audit.getSessionAccountEmailAddress() & local.audit.getAuditType() & local.audit.getTitle() & local.audit.getBaseObject()
				    //local.total += local.sku.getskuID();
				    // process row then release reference
				    //flush first before evict if not readOnlyMode and making changes to entities.
				    local.order.updateCalculatedProperties();
				    local.order.setOrderNumber('124');
				    debug(i);
				    debug(local.order.getOrderID());
				    debug(local.order.getOrderNumber());
				    arrayAppend(entitiesToEvict,local.order);
				    if(local.i % 20 == 0 || totalRecords==i){
				    	
				    	local.ormSession.flush();
				    	debug('flush');
				    	
				    	for(var entityToEvict in entitiesToEvict){
							local.ormSession.evict(entityToEvict);				    	
				    	}
				    	//local.ormSession.clear();
				    }
				    //local.ormSession.evict(local.order);
				    
			    }
			   
			    
			}
			
			local.slScrollableRecords.close(); //close the connection always!
		}catch(var scrollableError){
			local.slScrollableRecords.close(); 
			throw();
		}
		tx.commit();
		local.ormSession.close();
		
		
	}

}
