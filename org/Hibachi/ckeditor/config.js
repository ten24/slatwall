/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.filebrowserBrowseUrl = hibachiConfig['baseURL'] + '/org/Hibachi/ckfinder/ckfinder.html';
	config.filebrowserImageBrowseUrl = hibachiConfig['baseURL'] + '/org/Hibachi/ckfinder/ckfinder.html?Type=Images';
	config.filebrowserUploadUrl = hibachiConfig['baseURL'] + '/org/Hibachi/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Files';
	config.filebrowserImageUploadUrl = hibachiConfig['baseURL'] + '/org/Hibachi/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Images';
};
