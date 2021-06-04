/*

    Slatwall - An Open Source eCommerce Platform
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

component extends="Slatwall.org.Hibachi.HibachiCollectionService" accessors="true" output="false" {
    
    property name="settingService";
    property name="hibachiDataDAO";
	
	public any function processAccountCollection_Create(required any accountCollection, required any processObject){
		arguments.accountCollection = this.saveAccountCollection(arguments.processObject.getAccountCollection());	
		return arguments.accountCollection; 
	}

    public any function processCollection_Rename(required any collection, any processObject, struct data={}) {
        arguments.collection.setCollectionName(arguments.data.collectionName);
        
        this.saveCollection(arguments.collection);
        
        return arguments.collection;
    }

    public any function processCollection_Configure(required any collection, any processObject, struct data={}) {
        arguments.collection.setPublicFlag(arguments.data.publicFlag);
        
        if(!arguments.collection.getPublicFlag()){
            arguments.collection.setAccountOwner(getHibachiScope().getAccount());
        }
        
        this.saveCollection(arguments.collection);
        
        return arguments.collection;
    }

    public any function processCollection_Clone(required any collection, required any processObject, struct data={}) {

        var newCollection = this.newCollection();

        newCollection.setCollectionName(arguments.processObject.getCollectionName());
        newCollection.setCollectionCode(arguments.processObject.getCollectionCode());
        newCollection.setCollectionDescription(arguments.collection.getCollectionDescription());
        newCollection.setCollectionObject(arguments.collection.getCollectionObject());
        newCollection.setCollectionConfig(arguments.collection.getCollectionConfig());
	    if(!isNull(arguments.collection.getParentCollection())){
		    newCollection.setParentCollection(arguments.collection.getParentCollection());
	    }

        newCollection = this.saveCollection(newCollection);

        return newCollection;
    }
    
    public boolean function tableSizeExceedsDefaultOrderByLimit(required string tableName){
        
        if( !StructKeyExists(variables, 'targeTablesIndex') ){
            variables.targeTablesIndex = {};
            var targeTables = this.getHibachiDataDAO().getTablesHavingRecordsMoreThan(
                                    this.getSettingService().getSettingValue("globalDefaultOrderByMaxRecordsLimit")
                                );
                
            for(var row in targeTables){
                variables.targetablesIndex[ row['table_name'] ] = row['table_name'];
            }
        }
        
        if( StructKeyExists(variables.targeTablesIndex, arguments.tableName) ){
            return true;
        }
        
        return false;
    }

}
