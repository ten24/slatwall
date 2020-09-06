//--------------------------------------------------To add a custom configuration instructions.-------------------------------------------------------->
//
// Slatwall also searches for another version of this file within /custom/assets/ckeditor_config.js directory. 
// Use may make changes their that will override these settings.
//
//--------------------------------------------------To add a custom configuration instructions.-------------------------------------------------------->

/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	//config.extraAllowedContent = 'span;ul;li;table;td;style;*[id];*(*);*{*}'; 
	
	config.filebrowserBrowseUrl      = hibachiConfig['baseURL'] + '/org/Hibachi/ckfinder/ckfinder.html';
	config.filebrowserImageBrowseUrl = hibachiConfig['baseURL'] + '/org/Hibachi/ckfinder/ckfinder.html?Type=Images';
	config.filebrowserUploadUrl      = hibachiConfig['baseURL'] + '/org/Hibachi/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Files';
	config.filebrowserImageUploadUrl = hibachiConfig['baseURL'] + '/org/Hibachi/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Images';
};
