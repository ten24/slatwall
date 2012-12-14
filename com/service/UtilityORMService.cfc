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
component extends="BaseService" accessors="true" {

	property name="attributeService" type="any";
	property name="entityServiceMapping" type="struct";
	
	variables.entityORMMetaDataObjects = {};
	variables.entityObjects = {};
	variables.entityHasProperty = {};
	variables.entityHasAttribute = {};

	// @hint returns the correct service on a given entityName.  This is very useful for creating abstract code
	public any function getServiceByEntityName( required string entityName ) {
		
		// This removes the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName, 8) == "Slatwall") {
			arguments.entityName = right(arguments.entityName, len(arguments.entityName) - 8);
		}
		
		if(structKeyExists(getEntityServiceMapping(), arguments.entityName)) {
			return getService( getEntityServiceMapping()[ arguments.entityName ] );
		}
		
		throw("You have requested the service for the entity of '#arguments.entityName#' and that entity was not defined in the coldspring config.xml so please add it, and the appropriate service it should use.")
	}
	
	// ======================= START: Entity Name Helper Methods ==============================
	
	public string function getProperlyCasedShortEntityName( required string entityName ) {
		if(left(arguments.entityName, 8) == "Slatwall") {
			arguments.entityName = right(arguments.entityName, len(arguments.entityName)-8);
		}
		
		if( structKeyExists(getEntityServiceMapping(), arguments.entityName) ) {
			var keyList = structKeyList(getEntityServiceMapping());
			var keyIndex = listFindNoCase(keyList, arguments.entityName);
			return listGetAt(keyList, keyIndex);
		}
		
		throw("The entity name that you have requested: #arguments.entityname# is not in the ORM Library of entity names that is setup in coldsrping.  Please add #arguments.entityname# to the list of entity mappings in coldspring.");
	}
	
	public string function getProperlyCasedFullEntityName( required string entityName ) {
		return "Slatwall#getProperlyCasedShortEntityName( arguments.entityName )#";
	}
	
	public string function getProperlyCasedFullClassNameByEntityName( required string entityName ) {
		return "Slatwall.com.entity.#replace(getProperlyCasedFullEntityName( arguments.entityName ), 'Slatwall', '')#";
	}
	
	// =======================  END: Entity Name Helper Methods ===============================
	
	// ===================== START: Cached Entity Meta Data Methods ===========================
	
	// @hint returns the entity meta data object that is used by a lot of the helper methods below
	public any function getEntityORMMetaDataObject( required string entityName ) {
		
		arguments.entityName = getProperlyCasedFullEntityName( arguments.entityName );
		
		if(!structKeyExists(variables.entityORMMetaDataObjects, arguments.entityName)) {
			variables.entityORMMetaDataObjects[ arguments.entityName ] = ormGetSessionFactory().getClassMetadata( arguments.entityName );
		}
		
		return variables.entityORMMetaDataObjects[ arguments.entityName ];
	}
	
	// @hint returns the metaData struct for an entity
	public any function getEntityObject( required string entityName ) {
		
		arguments.entityName = getProperlyCasedFullEntityName( arguments.entityName );
		
		if(!structKeyExists(variables.entityObjects, arguments.entityName)) {
			variables.entityObjects[ arguments.entityName ] = createObject(getProperlyCasedFullClassNameByEntityName( arguments.entityName ));
		}
		
		return variables.entityObjects[ arguments.entityName ];
	}
	
	// @hint returns the properties of a given entity
	public any function getPropertiesByEntityName( required string entityName ) {
		
		// First Check the application cache
		if( hasApplicationValue("classPropertyStructCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#") ) {
			return getApplicationValue("classPropertyStructCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#");
		}
		
		// Pull the meta data from the object (which in turn will cache it in the application for the next time)
		return getEntityObject( arguments.entityName ).getProperties();
	}
	
	// @hint returns the properties of a given entity
	public any function getPropertiesStructByEntityName( required string entityName ) {
		
		// First Check the application cache
		if( hasApplicationValue("classPropertyStructCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#") ) {
			return getApplicationValue("classPropertyStructCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#");
		}
		
		// Pull the meta data from the object (which in turn will cache it in the application for the next time)
		return getEntityObject( arguments.entityName ).getPropertiesStruct(); 
	}
	
	// =====================  END: Cached Entity Meta Data Methods ============================
	
	
	// ============================== START: Logical Methods ==================================
	
	// @hint returns an array of ID columns based on the entityName
	public array function getIdentifierColumnNamesByEntityName( required string entityName ) {
		return getEntityORMMetaDataObject( arguments.entityName ).getIdentifierColumnNames();
	}
	
	// @hint returns the primary id property name of a given entityName
	public string function getPrimaryIDPropertyNameByEntityName( required string entityName ) {
		var idColumnNames = getIdentifierColumnNamesByEntityName( arguments.entityName );
		
		if( arrayLen(idColumnNames) == 1) {
			return idColumnNames[1];
		} else {
			throw("There is not a single primary ID property for the entity: #arguments.entityName#");
		}
	}
	
	// @hint returns true or false based on an entityName, and checks if that property exists for that entity 
	public boolean function getEntityHasPropertyByEntityName( required string entityName, required string propertyName ) {
		return structKeyExists(getPropertiesStructByEntityName(arguments.entityName), arguments.propertyName );
	}
	
	// @hint returns true or false based on an entityName, and checks if that entity has an extended attribute with that attributeCode
	public boolean function getEntityHasAttributeByEntityName( required string entityName, required string attributeCode ) {
		if(listFindNoCase(getAttributeService().getAttributeCodesListByAttributeSetType( "ast#getProperlyCasedShortEntityName(arguments.entityName)#" ), arguments.attributeCode)) {
			return true;
		}
		return false; 
	}
	
	// @hint leverages the getEntityHasPropertyByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
	public boolean function getHasPropertyByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
		return getEntityHasPropertyByEntityName( entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), propertyName=listLast(arguments.propertyIdentifier, "._") );
	}
	
	// @hint leverages the getEntityHasAttributeByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
	public boolean function getHasAttributeByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
		return getEntityHasAttributeByEntityName( entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), attributeCode=listLast(arguments.propertyIdentifier, "._") );
	}
	
	// @hint traverses a propertyIdentifier to find the last entityName in the list... this is then used by the hasProperty and hasAttribute methods()
	public string function getLastEntityNameInPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
		if(listLen(arguments.propertyIdentifier, "._") gt 1) {
			var propertiesSruct = getPropertiesStructByEntityName( arguments.entityName );
			if( !structKeyExists(propertiesSruct, listFirst(arguments.propertyIdentifier, "._")) || !structKeyExists(propertiesSruct[listFirst(arguments.propertyIdentifier, "._")], "cfc") ) {
				throw("The Property Identifier #arguments.propertyIdentifier# is invalid for the entity #arguments.entityName#");
			}
			return getLastEntityNameInPropertyIdentifier( entityName=propertiesSruct[listFirst(arguments.propertyIdentifier, "._")].cfc, propertyIdentifier=right(arguments.propertyIdentifier, len(arguments.propertyIdentifier)-(len(listFirst(arguments.propertyIdentifier, "._"))+1)));	
		}
		
		return arguments.entityName;
	}
	
}