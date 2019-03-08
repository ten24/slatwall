(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["npm.is-buffer"],{

/***/ "TXUe":
/*!*********************************************************************************************!*\
  !*** /home/ec2-user/environment/dev-ops/projects/slatwall2/node_modules/is-buffer/index.js ***!
  \*********************************************************************************************/
/*! no static exports found */
/*! all exports used */
/***/ (function(module, exports) {

eval("/*!\n * Determine if an object is a Buffer\n *\n * @author   Feross Aboukhadijeh <https://feross.org>\n * @license  MIT\n */\n\n// The _isBuffer check is for Safari 5-7 support, because it's missing\n// Object.prototype.constructor. Remove this eventually\nmodule.exports = function (obj) {\n  return obj != null && (isBuffer(obj) || isSlowBuffer(obj) || !!obj._isBuffer)\n}\n\nfunction isBuffer (obj) {\n  return !!obj.constructor && typeof obj.constructor.isBuffer === 'function' && obj.constructor.isBuffer(obj)\n}\n\n// For Node v0.10 support. Remove this eventually.\nfunction isSlowBuffer (obj) {\n  return typeof obj.readFloatLE === 'function' && typeof obj.slice === 'function' && isBuffer(obj.slice(0, 0))\n}\n\n\n//# sourceURL=webpack:////home/ec2-user/environment/dev-ops/projects/slatwall2/node_modules/is-buffer/index.js?");

/***/ })

}]);