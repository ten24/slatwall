(this["webpackJsonpswreact"] = this["webpackJsonpswreact"] || []).push([["main"],{

/***/ "./node_modules/css-loader/dist/cjs.js?!./node_modules/postcss-loader/src/index.js?!./src/components/Button/button.css":
/*!*********************************************************************************************************************************************!*\
  !*** ./node_modules/css-loader/dist/cjs.js??ref--5-oneOf-4-1!./node_modules/postcss-loader/src??postcss!./src/components/Button/button.css ***!
  \*********************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../../../node_modules/css-loader/dist/runtime/api.js */ "./node_modules/css-loader/dist/runtime/api.js");
/* harmony import */ var _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0__);
// Imports

var ___CSS_LOADER_EXPORT___ = _node_modules_css_loader_dist_runtime_api_js__WEBPACK_IMPORTED_MODULE_0___default()(true);
// Module
___CSS_LOADER_EXPORT___.push([module.i, ".storybook-button {\n  font-family: 'Nunito Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;\n  font-weight: 700;\n  border: 0;\n  border-radius: 3em;\n  cursor: pointer;\n  display: inline-block;\n  line-height: 1;\n}\n.storybook-button--primary {\n  color: white;\n  background-color: #1ea7fd;\n}\n.storybook-button--secondary {\n  color: #333;\n  background-color: transparent;\n  box-shadow: rgba(0, 0, 0, 0.15) 0px 0px 0px 1px inset;\n}\n.storybook-button--small {\n  font-size: 12px;\n  padding: 10px 16px;\n}\n.storybook-button--medium {\n  font-size: 14px;\n  padding: 11px 20px;\n}\n.storybook-button--large {\n  font-size: 16px;\n  padding: 12px 24px;\n}\n", "",{"version":3,"sources":["webpack://src/components/Button/button.css"],"names":[],"mappings":"AAAA;EACE,0EAA0E;EAC1E,gBAAgB;EAChB,SAAS;EACT,kBAAkB;EAClB,eAAe;EACf,qBAAqB;EACrB,cAAc;AAChB;AACA;EACE,YAAY;EACZ,yBAAyB;AAC3B;AACA;EACE,WAAW;EACX,6BAA6B;EAC7B,qDAAqD;AACvD;AACA;EACE,eAAe;EACf,kBAAkB;AACpB;AACA;EACE,eAAe;EACf,kBAAkB;AACpB;AACA;EACE,eAAe;EACf,kBAAkB;AACpB","sourcesContent":[".storybook-button {\n  font-family: 'Nunito Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;\n  font-weight: 700;\n  border: 0;\n  border-radius: 3em;\n  cursor: pointer;\n  display: inline-block;\n  line-height: 1;\n}\n.storybook-button--primary {\n  color: white;\n  background-color: #1ea7fd;\n}\n.storybook-button--secondary {\n  color: #333;\n  background-color: transparent;\n  box-shadow: rgba(0, 0, 0, 0.15) 0px 0px 0px 1px inset;\n}\n.storybook-button--small {\n  font-size: 12px;\n  padding: 10px 16px;\n}\n.storybook-button--medium {\n  font-size: 14px;\n  padding: 11px 20px;\n}\n.storybook-button--large {\n  font-size: 16px;\n  padding: 12px 24px;\n}\n"],"sourceRoot":""}]);
// Exports
/* harmony default export */ __webpack_exports__["default"] = (___CSS_LOADER_EXPORT___);


/***/ }),

/***/ "./src/components/Button/Button.js":
/*!*****************************************!*\
  !*** ./src/components/Button/Button.js ***!
  \*****************************************/
/*! exports provided: Button */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Button", function() { return Button; });
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react/jsx-dev-runtime */ "./node_modules/react/jsx-dev-runtime.js");
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react */ "./node_modules/react/index.js");
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var prop_types__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");
/* harmony import */ var prop_types__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(prop_types__WEBPACK_IMPORTED_MODULE_2__);
/* harmony import */ var _button_css__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./button.css */ "./src/components/Button/button.css");
/* harmony import */ var _button_css__WEBPACK_IMPORTED_MODULE_3___default = /*#__PURE__*/__webpack_require__.n(_button_css__WEBPACK_IMPORTED_MODULE_3__);

var _jsxFileName = "/Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/src/components/Button/Button.js";



/**
 * Primary UI component for user interaction
 */

const Button = ({
  primary,
  backgroundColor,
  size,
  label,
  ...props
}) => {
  const mode = primary ? 'storybook-button--primary' : 'storybook-button--secondary';
  return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("button", {
    type: "button",
    className: ['storybook-button', `storybook-button--${size}`, mode].join(' '),
    style: backgroundColor && {
      backgroundColor
    },
    ...props,
    children: label
  }, void 0, false, {
    fileName: _jsxFileName,
    lineNumber: 11,
    columnNumber: 5
  }, undefined);
};
Button.propTypes = {
  /**
   * Is this the principal call to action on the page?
   */
  primary: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.bool,

  /**
   * What background color to use
   */
  backgroundColor: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string,

  /**
   * How large should the button be?
   */
  size: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.oneOf(['small', 'medium', 'large']),

  /**
   * Button contents
   */
  label: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string.isRequired,

  /**
   * Optional click handler
   */
  onClick: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.func
};
Button.defaultProps = {
  backgroundColor: null,
  primary: false,
  size: 'medium',
  onClick: undefined
};

/***/ }),

/***/ "./src/components/Button/button.css":
/*!******************************************!*\
  !*** ./src/components/Button/button.css ***!
  \******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var api = __webpack_require__(/*! ../../../node_modules/style-loader/dist/runtime/injectStylesIntoStyleTag.js */ "./node_modules/style-loader/dist/runtime/injectStylesIntoStyleTag.js");
            var content = __webpack_require__(/*! !../../../node_modules/css-loader/dist/cjs.js??ref--5-oneOf-4-1!../../../node_modules/postcss-loader/src??postcss!./button.css */ "./node_modules/css-loader/dist/cjs.js?!./node_modules/postcss-loader/src/index.js?!./src/components/Button/button.css");

            content = content.__esModule ? content.default : content;

            if (typeof content === 'string') {
              content = [[module.i, content, '']];
            }

var options = {};

options.insert = "head";
options.singleton = false;

var update = api(content, options);



module.exports = content.locals || {};

/***/ }),

/***/ "./src/components/Footer/Footer.js":
/*!*****************************************!*\
  !*** ./src/components/Footer/Footer.js ***!
  \*****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react/jsx-dev-runtime */ "./node_modules/react/jsx-dev-runtime.js");
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react */ "./node_modules/react/index.js");
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var prop_types__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");
/* harmony import */ var prop_types__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(prop_types__WEBPACK_IMPORTED_MODULE_2__);

var _jsxFileName = "/Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/src/components/Footer/Footer.js";



function Footer(props) {
  return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("footer", {
    className: "pt-5",
    children: [props.isContact === 'true' && /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
      className: "bg-primary p-5",
      children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "container",
        children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
          className: "row",
          children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "col-0 col-md-2"
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 11,
            columnNumber: 15
          }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "col-md-8 text-center",
            dangerouslySetInnerHTML: {
              __html: props.contactUs
            }
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 12,
            columnNumber: 15
          }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "col-0 col-md-2"
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 16,
            columnNumber: 15
          }, this)]
        }, void 0, true, {
          fileName: _jsxFileName,
          lineNumber: 10,
          columnNumber: 13
        }, this)
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 9,
        columnNumber: 11
      }, this)
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 8,
      columnNumber: 9
    }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
      className: "bg-light pt-4",
      children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "container",
        children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
          className: "row pt-2",
          children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "col-md-2 col-sm-6",
            children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "widget widget-links pb-2 mb-4",
              dangerouslySetInnerHTML: {
                __html: props.siteLinks
              }
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 26,
              columnNumber: 15
            }, this)
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 25,
            columnNumber: 13
          }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "col-md-4 col-sm-6",
            children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "widget widget-links pb-2 mb-4",
              dangerouslySetInnerHTML: {
                __html: props.getInTouch
              }
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 32,
              columnNumber: 15
            }, this)
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 31,
            columnNumber: 13
          }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "col-md-6",
            children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "widget pb-2 mb-4",
              children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                dangerouslySetInnerHTML: {
                  __html: props.stayInformed
                }
              }, void 0, false, {
                fileName: _jsxFileName,
                lineNumber: 39,
                columnNumber: 17
              }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("form", {
                className: "validate",
                action: "##",
                method: "get",
                name: "mc-embedded-subscribe-form",
                id: "mc-embedded-subscribe-form",
                children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                  className: "input-group input-group-overlay flex-nowrap",
                  children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                    className: "input-group-prepend-overlay",
                    children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
                      className: "input-group-text text-muted font-size-base"
                    }, void 0, false, {
                      fileName: _jsxFileName,
                      lineNumber: 49,
                      columnNumber: 23
                    }, this)
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 48,
                    columnNumber: 21
                  }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                    className: "row",
                    children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                      className: "col-12 d-flex",
                      children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("input", {
                        className: "form-control prepended-form-control mr-2",
                        type: "text",
                        name: "FirstName",
                        id: "mce-FirstName",
                        defaultValue: "",
                        onChange: () => {},
                        placeholder: "First Name",
                        required: true
                      }, void 0, false, {
                        fileName: _jsxFileName,
                        lineNumber: 53,
                        columnNumber: 25
                      }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("input", {
                        className: "form-control prepended-form-control mr-2",
                        type: "text",
                        name: "LastName",
                        id: "mce-LastName",
                        defaultValue: "",
                        onChange: () => {},
                        placeholder: "Last Name",
                        required: true
                      }, void 0, false, {
                        fileName: _jsxFileName,
                        lineNumber: 63,
                        columnNumber: 25
                      }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("input", {
                        className: "form-control prepended-form-control",
                        type: "text",
                        name: "Company",
                        id: "mce-Comapny",
                        defaultValue: "",
                        placeholder: "Company",
                        required: true
                      }, void 0, false, {
                        fileName: _jsxFileName,
                        lineNumber: 73,
                        columnNumber: 25
                      }, this)]
                    }, void 0, true, {
                      fileName: _jsxFileName,
                      lineNumber: 52,
                      columnNumber: 23
                    }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                      className: "col-12 d-flex pt-2",
                      children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("input", {
                        className: "form-control prepended-form-control",
                        type: "email",
                        name: "Email",
                        id: "mce-Email",
                        defaultValue: "",
                        onChange: () => {},
                        placeholder: "Your email",
                        required: true
                      }, void 0, false, {
                        fileName: _jsxFileName,
                        lineNumber: 84,
                        columnNumber: 25
                      }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                        className: "input-group-append",
                        children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("button", {
                          className: "btn btn-primary",
                          type: "submit",
                          name: "subscribe",
                          id: "mc-embedded-subscribe",
                          children: "Subscribe*"
                        }, void 0, false, {
                          fileName: _jsxFileName,
                          lineNumber: 95,
                          columnNumber: 27
                        }, this)
                      }, void 0, false, {
                        fileName: _jsxFileName,
                        lineNumber: 94,
                        columnNumber: 25
                      }, this)]
                    }, void 0, true, {
                      fileName: _jsxFileName,
                      lineNumber: 83,
                      columnNumber: 23
                    }, this)]
                  }, void 0, true, {
                    fileName: _jsxFileName,
                    lineNumber: 51,
                    columnNumber: 21
                  }, this)]
                }, void 0, true, {
                  fileName: _jsxFileName,
                  lineNumber: 47,
                  columnNumber: 19
                }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                  style: {
                    position: 'absolute',
                    left: '-5000px'
                  },
                  "aria-hidden": "true",
                  children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("input", {
                    type: "text",
                    name: "b_c7103e2c981361a6639545bd5_29ca296126",
                    tabIndex: "-1"
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 112,
                    columnNumber: 21
                  }, this)
                }, void 0, false, {
                  fileName: _jsxFileName,
                  lineNumber: 108,
                  columnNumber: 19
                }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("small", {
                  className: "form-text text-light opacity-50",
                  id: "mc-helper",
                  children: "*Subscribe to our newsletter to receive early discount offers, updates and new products info."
                }, void 0, false, {
                  fileName: _jsxFileName,
                  lineNumber: 118,
                  columnNumber: 19
                }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                  className: "subscribe-status"
                }, void 0, false, {
                  fileName: _jsxFileName,
                  lineNumber: 125,
                  columnNumber: 19
                }, this)]
              }, void 0, true, {
                fileName: _jsxFileName,
                lineNumber: 40,
                columnNumber: 17
              }, this)]
            }, void 0, true, {
              fileName: _jsxFileName,
              lineNumber: 38,
              columnNumber: 15
            }, this)
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 37,
            columnNumber: 13
          }, this)]
        }, void 0, true, {
          fileName: _jsxFileName,
          lineNumber: 24,
          columnNumber: 11
        }, this)
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 23,
        columnNumber: 9
      }, this)
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 22,
      columnNumber: 7
    }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
      className: "bg-darker pt-4",
      children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "container",
        children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
          className: "row",
          children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "col-md-6 text-center text-md-left mb-4 text-light",
            children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("img", {
              className: "w-50",
              src: "#$.getThemePath()#/custom/client/assets/images/sb-logo-white.png",
              alt: "Stone and Berg logo"
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 136,
              columnNumber: 15
            }, this)
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 135,
            columnNumber: 13
          }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "col-md-6 font-size-xs text-light text-center text-md-right mb-4",
            children: [`@${props.copywriteDate} `, " All rights reserved. Stone and Berg Company Inc"]
          }, void 0, true, {
            fileName: _jsxFileName,
            lineNumber: 142,
            columnNumber: 13
          }, this)]
        }, void 0, true, {
          fileName: _jsxFileName,
          lineNumber: 134,
          columnNumber: 11
        }, this)
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 133,
        columnNumber: 9
      }, this)
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 132,
      columnNumber: 7
    }, this)]
  }, void 0, true, {
    fileName: _jsxFileName,
    lineNumber: 6,
    columnNumber: 5
  }, this);
}

Footer.propTypes = {
  isContact: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string,
  contactUs: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string,
  getInTouch: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string,
  siteLinks: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string,
  stayInformed: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string,
  copywriteDate: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string
};
/* harmony default export */ __webpack_exports__["default"] = (Footer);

/***/ }),

/***/ "./src/components/Header/Header.js":
/*!*****************************************!*\
  !*** ./src/components/Header/Header.js ***!
  \*****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react/jsx-dev-runtime */ "./node_modules/react/jsx-dev-runtime.js");
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react */ "./node_modules/react/index.js");
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var prop_types__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");
/* harmony import */ var prop_types__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(prop_types__WEBPACK_IMPORTED_MODULE_2__);

var _jsxFileName = "/Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/src/components/Header/Header.js";



const MegaMenu = props => {
  return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("li", {
    className: "nav-item dropdown",
    children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
      className: "nav-link dropdown-toggle",
      href: props.linkUrl,
      "data-toggle": "dropdown",
      children: props.title
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 7,
      columnNumber: 7
    }, undefined), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
      className: "dropdown-menu pt-0 pb-3",
      children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "nav-shop-all",
        children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
          href: props.linkUrl,
          children: ["Shop All ", props.title, /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("i", {
            className: "far fa-arrow-right ml-2"
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 18,
            columnNumber: 13
          }, undefined)]
        }, void 0, true, {
          fileName: _jsxFileName,
          lineNumber: 16,
          columnNumber: 11
        }, undefined)
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 15,
        columnNumber: 9
      }, undefined), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "d-flex flex-wrap flex-lg-nowrap px-2",
        children: props.subMenu.map((productCategory, index) => {
          return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "mega-dropdown-column py-4 px-3",
            children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "widget widget-links mb-3",
              dangerouslySetInnerHTML: {
                __html: productCategory['customBody']
              }
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 25,
              columnNumber: 17
            }, undefined)
          }, index, false, {
            fileName: _jsxFileName,
            lineNumber: 24,
            columnNumber: 15
          }, undefined);
        })
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 21,
        columnNumber: 9
      }, undefined)]
    }, void 0, true, {
      fileName: _jsxFileName,
      lineNumber: 14,
      columnNumber: 7
    }, undefined)]
  }, void 0, true, {
    fileName: _jsxFileName,
    lineNumber: 6,
    columnNumber: 5
  }, undefined);
};

function Header(props) {
  const productCategories = JSON.parse(props.productCategories);
  let menuItems = new Map();
  productCategories.forEach(item => {
    if (menuItems.has(item.parentContent_title)) {
      let exisitingItems = menuItems.get(item.parentContent_title);
      exisitingItems.push(item);
      menuItems.set(item.parentContent_title, exisitingItems);
    } else {
      menuItems.set(item.parentContent_title, [item]);
    }
  });
  return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("header", {
    className: "shadow-sm",
    children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
      className: "navbar-sticky bg-light",
      children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "navbar navbar-expand-lg navbar-light",
        children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
          className: "container",
          children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
            className: "navbar-brand d-none d-md-block mr-3 flex-shrink-0",
            href: "/",
            children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("img", {
              src: "/custom/client/assets/images/sb-logo.png",
              alt: "Stone & Berg Logo"
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 62,
              columnNumber: 15
            }, this)
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 58,
            columnNumber: 13
          }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
            className: "navbar-brand d-md-none mr-2",
            href: "/",
            children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("img", {
              src: "/custom/client/assets/images/sb-logo-mobile.png",
              style: {
                minWidth: '90px'
              },
              alt: "Stone & Berg Logo"
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 68,
              columnNumber: 15
            }, this)
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 67,
            columnNumber: 13
          }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "navbar-right",
            children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "navbar-topright",
              children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                className: "input-group-overlay d-none d-lg-flex",
                children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("input", {
                  className: "form-control appended-form-control",
                  type: "text",
                  placeholder: "Search for products"
                }, void 0, false, {
                  fileName: _jsxFileName,
                  lineNumber: 78,
                  columnNumber: 19
                }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                  className: "input-group-append-overlay",
                  children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
                    className: "input-group-text",
                    children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("i", {
                      className: "far fa-search"
                    }, void 0, false, {
                      fileName: _jsxFileName,
                      lineNumber: 85,
                      columnNumber: 23
                    }, this)
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 84,
                    columnNumber: 21
                  }, this)
                }, void 0, false, {
                  fileName: _jsxFileName,
                  lineNumber: 83,
                  columnNumber: 19
                }, this)]
              }, void 0, true, {
                fileName: _jsxFileName,
                lineNumber: 77,
                columnNumber: 17
              }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                className: "navbar-toolbar d-flex flex-shrink-0 align-items-center",
                children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("button", {
                  className: "navbar-toggler",
                  type: "button",
                  "data-toggle": "collapse",
                  "data-target": "##navbarCollapse",
                  children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
                    className: "navbar-toggler-icon"
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 96,
                    columnNumber: 21
                  }, this)
                }, void 0, false, {
                  fileName: _jsxFileName,
                  lineNumber: 90,
                  columnNumber: 19
                }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
                  className: "navbar-tool navbar-stuck-toggler",
                  href: "##",
                  children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
                    className: "navbar-tool-tooltip",
                    children: "Expand menu"
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 99,
                    columnNumber: 21
                  }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                    className: "navbar-tool-icon-box",
                    children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("i", {
                      className: "far fa-bars"
                    }, void 0, false, {
                      fileName: _jsxFileName,
                      lineNumber: 101,
                      columnNumber: 23
                    }, this)
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 100,
                    columnNumber: 21
                  }, this)]
                }, void 0, true, {
                  fileName: _jsxFileName,
                  lineNumber: 98,
                  columnNumber: 19
                }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
                  className: "navbar-tool ml-1 ml-lg-0 mr-n1 mr-lg-2",
                  href: "##",
                  "data-toggle": "modal",
                  children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                    className: "navbar-tool-icon-box",
                    children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("i", {
                      className: "far fa-user"
                    }, void 0, false, {
                      fileName: _jsxFileName,
                      lineNumber: 110,
                      columnNumber: 23
                    }, this)
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 109,
                    columnNumber: 21
                  }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                    className: "navbar-tool-text ml-n3",
                    children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("small", {
                      children: "Hello, Sign in"
                    }, void 0, false, {
                      fileName: _jsxFileName,
                      lineNumber: 113,
                      columnNumber: 23
                    }, this), "My Account"]
                  }, void 0, true, {
                    fileName: _jsxFileName,
                    lineNumber: 112,
                    columnNumber: 21
                  }, this)]
                }, void 0, true, {
                  fileName: _jsxFileName,
                  lineNumber: 104,
                  columnNumber: 19
                }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                  className: "navbar-tool ml-3",
                  children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
                    className: "navbar-tool-icon-box bg-secondary",
                    href: "##",
                    children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
                      className: "navbar-tool-label",
                      children: "4"
                    }, void 0, false, {
                      fileName: _jsxFileName,
                      lineNumber: 118,
                      columnNumber: 23
                    }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("i", {
                      className: "far fa-shopping-cart"
                    }, void 0, false, {
                      fileName: _jsxFileName,
                      lineNumber: 119,
                      columnNumber: 23
                    }, this)]
                  }, void 0, true, {
                    fileName: _jsxFileName,
                    lineNumber: 117,
                    columnNumber: 21
                  }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
                    className: "navbar-tool-text",
                    href: "shop-cart.html",
                    children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("small", {
                      children: "My Cart"
                    }, void 0, false, {
                      fileName: _jsxFileName,
                      lineNumber: 122,
                      columnNumber: 23
                    }, this), "$265.00"]
                  }, void 0, true, {
                    fileName: _jsxFileName,
                    lineNumber: 121,
                    columnNumber: 21
                  }, this)]
                }, void 0, true, {
                  fileName: _jsxFileName,
                  lineNumber: 116,
                  columnNumber: 19
                }, this)]
              }, void 0, true, {
                fileName: _jsxFileName,
                lineNumber: 89,
                columnNumber: 17
              }, this)]
            }, void 0, true, {
              fileName: _jsxFileName,
              lineNumber: 76,
              columnNumber: 15
            }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "navbar-main-links",
              dangerouslySetInnerHTML: {
                __html: props.mainNavigation
              }
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 128,
              columnNumber: 15
            }, this)]
          }, void 0, true, {
            fileName: _jsxFileName,
            lineNumber: 75,
            columnNumber: 13
          }, this)]
        }, void 0, true, {
          fileName: _jsxFileName,
          lineNumber: 57,
          columnNumber: 11
        }, this)
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 56,
        columnNumber: 9
      }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "navbar navbar-expand-lg navbar-dark bg-dark navbar-stuck-menu mt-2 pt-0 pb-0",
        children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
          className: "container p-0",
          children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "collapse navbar-collapse",
            id: "navbarCollapse",
            children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "input-group-overlay d-lg-none my-3 ml-0",
              children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
                className: "input-group-prepend-overlay",
                children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
                  className: "input-group-text",
                  children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("i", {
                    className: "far fa-search"
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 142,
                    columnNumber: 21
                  }, this)
                }, void 0, false, {
                  fileName: _jsxFileName,
                  lineNumber: 141,
                  columnNumber: 19
                }, this)
              }, void 0, false, {
                fileName: _jsxFileName,
                lineNumber: 140,
                columnNumber: 17
              }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("input", {
                className: "form-control prepended-form-control",
                type: "text",
                placeholder: "Search for products"
              }, void 0, false, {
                fileName: _jsxFileName,
                lineNumber: 145,
                columnNumber: 17
              }, this)]
            }, void 0, true, {
              fileName: _jsxFileName,
              lineNumber: 139,
              columnNumber: 15
            }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("ul", {
              className: "navbar-nav nav-categories",
              children: [...menuItems.values()].map((menuItem, index) => {
                return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])(MegaMenu, {
                  subMenu: menuItem,
                  title: menuItem[0]['parentContent_title'],
                  linkUrl: menuItem[0]['parentContent_linkUrl']
                }, index, false, {
                  fileName: _jsxFileName,
                  lineNumber: 155,
                  columnNumber: 21
                }, this);
              })
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 152,
              columnNumber: 15
            }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("ul", {
              className: "navbar-nav mega-nav ml-lg-2",
              children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("li", {
                className: "nav-item",
                children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
                  className: "nav-link",
                  href: "##",
                  children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("i", {
                    className: "far fa-industry-alt mr-2"
                  }, void 0, false, {
                    fileName: _jsxFileName,
                    lineNumber: 167,
                    columnNumber: 21
                  }, this), "Shop by Manufacturer"]
                }, void 0, true, {
                  fileName: _jsxFileName,
                  lineNumber: 166,
                  columnNumber: 19
                }, this)
              }, void 0, false, {
                fileName: _jsxFileName,
                lineNumber: 165,
                columnNumber: 17
              }, this)
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 164,
              columnNumber: 15
            }, this)]
          }, void 0, true, {
            fileName: _jsxFileName,
            lineNumber: 138,
            columnNumber: 13
          }, this)
        }, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 137,
          columnNumber: 11
        }, this)
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 136,
        columnNumber: 9
      }, this)]
    }, void 0, true, {
      fileName: _jsxFileName,
      lineNumber: 55,
      columnNumber: 7
    }, this)
  }, void 0, false, {
    fileName: _jsxFileName,
    lineNumber: 54,
    columnNumber: 5
  }, this);
}

Header.propTypes = {
  themePath: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string,
  mainNavigation: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string,
  productCategories: prop_types__WEBPACK_IMPORTED_MODULE_2___default.a.string
};
/* harmony default export */ __webpack_exports__["default"] = (Header);

/***/ }),

/***/ "./src/components/HookSample/HookSample.js":
/*!*************************************************!*\
  !*** ./src/components/HookSample/HookSample.js ***!
  \*************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react/jsx-dev-runtime */ "./node_modules/react/jsx-dev-runtime.js");
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react */ "./node_modules/react/index.js");
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var react_i18next__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! react-i18next */ "./node_modules/react-i18next/dist/es/index.js");
/* harmony import */ var i18next__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! i18next */ "./node_modules/i18next/dist/esm/i18next.js");

var _jsxFileName = "/Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/src/components/HookSample/HookSample.js";




const HookSample = props => {
  const {
    t
  } = Object(react_i18next__WEBPACK_IMPORTED_MODULE_2__["useTranslation"])();
  console.log(props);
  return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
    children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("h1", {
      children: t('Welcome to React')
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 11,
      columnNumber: 7
    }, undefined), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("p", {
      children: t('description.part1')
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 12,
      columnNumber: 7
    }, undefined), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("button", {
      type: "button",
      className: "btn btn-outline-primary",
      onClick: () => {
        i18next__WEBPACK_IMPORTED_MODULE_3__["default"].changeLanguage('en');
        window.localStorage.setItem('i18nextLng', 'en');
      },
      children: "Set English"
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 13,
      columnNumber: 7
    }, undefined), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("button", {
      type: "button",
      className: "btn btn-outline-primary",
      onClick: () => {
        i18next__WEBPACK_IMPORTED_MODULE_3__["default"].changeLanguage('fr');
        window.localStorage.setItem('i18nextLng', 'fr');
      },
      children: "Set French"
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 23,
      columnNumber: 7
    }, undefined)]
  }, void 0, true, {
    fileName: _jsxFileName,
    lineNumber: 10,
    columnNumber: 5
  }, undefined);
};

/* harmony default export */ __webpack_exports__["default"] = (HookSample);

/***/ }),

/***/ "./src/components/Layout/Layout.js":
/*!*****************************************!*\
  !*** ./src/components/Layout/Layout.js ***!
  \*****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react/jsx-dev-runtime */ "./node_modules/react/jsx-dev-runtime.js");
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react */ "./node_modules/react/index.js");
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var ___WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! .. */ "./src/components/index.js");

var _jsxFileName = "/Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/src/components/Layout/Layout.js";



class Layout extends react__WEBPACK_IMPORTED_MODULE_1___default.a.Component {
  render() {
    const {
      style = 'full'
    } = this.props;

    if (style === 'full') {
      return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "layout",
        children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])(___WEBPACK_IMPORTED_MODULE_2__["Navigation"], {}, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 10,
          columnNumber: 11
        }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
          className: "container-fluid ",
          children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "row",
            children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "col-sm-12",
              children: this.props.children
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 13,
              columnNumber: 15
            }, this)
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 12,
            columnNumber: 13
          }, this)
        }, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 11,
          columnNumber: 11
        }, this)]
      }, void 0, true, {
        fileName: _jsxFileName,
        lineNumber: 9,
        columnNumber: 9
      }, this);
    } else if (style === 'sidbar') {
      return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
        className: "layout",
        children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])(___WEBPACK_IMPORTED_MODULE_2__["Navigation"], {}, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 21,
          columnNumber: 11
        }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
          className: "container",
          children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
            className: "row",
            children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "col-sm-4",
              children: "col-sm-4"
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 24,
              columnNumber: 15
            }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
              className: "col-sm-8",
              children: this.props.children
            }, void 0, false, {
              fileName: _jsxFileName,
              lineNumber: 25,
              columnNumber: 15
            }, this)]
          }, void 0, true, {
            fileName: _jsxFileName,
            lineNumber: 23,
            columnNumber: 13
          }, this)
        }, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 22,
          columnNumber: 11
        }, this)]
      }, void 0, true, {
        fileName: _jsxFileName,
        lineNumber: 20,
        columnNumber: 9
      }, this);
    }
  }

}

/* harmony default export */ __webpack_exports__["default"] = (Layout);

/***/ }),

/***/ "./src/components/Navigation/Navigation.js":
/*!*************************************************!*\
  !*** ./src/components/Navigation/Navigation.js ***!
  \*************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react/jsx-dev-runtime */ "./node_modules/react/jsx-dev-runtime.js");
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react */ "./node_modules/react/index.js");
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_1__);

var _jsxFileName = "/Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/src/components/Navigation/Navigation.js";


function Navigation(props) {
  const [isNavCollapsed, setIsNavCollapsed] = Object(react__WEBPACK_IMPORTED_MODULE_1__["useState"])(true);

  const handleNavCollapse = () => setIsNavCollapsed(!isNavCollapsed);

  return /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("nav", {
    className: "navbar navbar-expand-lg navbar-light bg-light",
    children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("button", {
      className: "navbar-toggler",
      type: "button",
      "data-toggle": "collapse",
      "data-target": "#navbarNav",
      "aria-controls": "navbarNav",
      "aria-expanded": "false",
      "aria-label": "Toggle navigation",
      onClick: handleNavCollapse,
      children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
        className: "navbar-toggler-icon"
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 19,
        columnNumber: 9
      }, this)
    }, void 0, false, {
      fileName: _jsxFileName,
      lineNumber: 9,
      columnNumber: 7
    }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("div", {
      className: `${isNavCollapsed ? "collapse" : ""} navbar-collapse`,
      id: "navbarNav",
      children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("ul", {
        className: "navbar-nav mr-auto mt-2 mt-lg-0",
        children: [/*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("li", {
          className: "nav-item active",
          children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
            className: "nav-link",
            href: "/",
            children: "Home"
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 27,
            columnNumber: 13
          }, this)
        }, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 26,
          columnNumber: 11
        }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("li", {
          className: "nav-item",
          children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
            className: "nav-link",
            href: "/products",
            children: "All Products"
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 32,
            columnNumber: 13
          }, this)
        }, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 31,
          columnNumber: 11
        }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("li", {
          className: "nav-item",
          children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
            className: "nav-link",
            href: "/product/1",
            children: "product 2"
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 37,
            columnNumber: 13
          }, this)
        }, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 36,
          columnNumber: 11
        }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("li", {
          className: "nav-item",
          children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
            className: "nav-link",
            href: "/product/2",
            children: "product 2"
          }, void 0, false, {
            fileName: _jsxFileName,
            lineNumber: 42,
            columnNumber: 13
          }, this)
        }, void 0, false, {
          fileName: _jsxFileName,
          lineNumber: 41,
          columnNumber: 11
        }, this)]
      }, void 0, true, {
        fileName: _jsxFileName,
        lineNumber: 25,
        columnNumber: 9
      }, this), /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
        className: "navbar-text",
        children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("a", {
          className: "nav-link",
          href: "/cart",
          children: ["Cart ", /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])("span", {
            children: ["(", props.cartLength, ")"]
          }, void 0, true, {
            fileName: _jsxFileName,
            lineNumber: 49,
            columnNumber: 18
          }, this)]
        }, void 0, true, {
          fileName: _jsxFileName,
          lineNumber: 48,
          columnNumber: 11
        }, this)
      }, void 0, false, {
        fileName: _jsxFileName,
        lineNumber: 47,
        columnNumber: 9
      }, this)]
    }, void 0, true, {
      fileName: _jsxFileName,
      lineNumber: 21,
      columnNumber: 7
    }, this)]
  }, void 0, true, {
    fileName: _jsxFileName,
    lineNumber: 8,
    columnNumber: 5
  }, this);
}

/* harmony default export */ __webpack_exports__["default"] = (Navigation);

/***/ }),

/***/ "./src/components/index.js":
/*!*********************************!*\
  !*** ./src/components/index.js ***!
  \*********************************/
/*! exports provided: Navigation, Layout, HookSample, Footer, Header, Button */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _Navigation_Navigation__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Navigation/Navigation */ "./src/components/Navigation/Navigation.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "Navigation", function() { return _Navigation_Navigation__WEBPACK_IMPORTED_MODULE_0__["default"]; });

/* harmony import */ var _Layout_Layout__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Layout/Layout */ "./src/components/Layout/Layout.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "Layout", function() { return _Layout_Layout__WEBPACK_IMPORTED_MODULE_1__["default"]; });

/* harmony import */ var _HookSample_HookSample__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./HookSample/HookSample */ "./src/components/HookSample/HookSample.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "HookSample", function() { return _HookSample_HookSample__WEBPACK_IMPORTED_MODULE_2__["default"]; });

/* harmony import */ var _Footer_Footer__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./Footer/Footer */ "./src/components/Footer/Footer.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "Footer", function() { return _Footer_Footer__WEBPACK_IMPORTED_MODULE_3__["default"]; });

/* harmony import */ var _Header_Header__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./Header/Header */ "./src/components/Header/Header.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "Header", function() { return _Header_Header__WEBPACK_IMPORTED_MODULE_4__["default"]; });

/* harmony import */ var _Button_Button__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./Button/Button */ "./src/components/Button/Button.js");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "Button", function() { return _Button_Button__WEBPACK_IMPORTED_MODULE_5__["Button"]; });






 // export { default as APITester } from './APITester/APITester'

/***/ }),

/***/ "./src/i18n.js":
/*!*********************!*\
  !*** ./src/i18n.js ***!
  \*********************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var i18next__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! i18next */ "./node_modules/i18next/dist/esm/i18next.js");
/* harmony import */ var react_i18next__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react-i18next */ "./node_modules/react-i18next/dist/es/index.js");
/* harmony import */ var _locales_index__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./locales/index */ "./src/locales/index.js");



i18next__WEBPACK_IMPORTED_MODULE_0__["default"].use(react_i18next__WEBPACK_IMPORTED_MODULE_1__["initReactI18next"]).init({
  resources: _locales_index__WEBPACK_IMPORTED_MODULE_2__["default"],
  lng: window.localStorage.getItem("i18nextLng"),
  supportedLngs: ["en", "fr"],
  nonExplicitSupportedLngs: true,
  fallbackLng: "en",
  debug: true,
  interpolation: {
    escapeValue: false // not needed for react as it escapes by default

  }
});
/* harmony default export */ __webpack_exports__["default"] = (i18next__WEBPACK_IMPORTED_MODULE_0__["default"]);

/***/ }),

/***/ "./src/index.js":
/*!**********************!*\
  !*** ./src/index.js ***!
  \**********************/
/*! no exports provided */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! react/jsx-dev-runtime */ "./node_modules/react/jsx-dev-runtime.js");
/* harmony import */ var react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! react */ "./node_modules/react/index.js");
/* harmony import */ var react__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(react__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var react_dom__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! react-dom */ "./node_modules/react-dom/index.js");
/* harmony import */ var react_dom__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(react_dom__WEBPACK_IMPORTED_MODULE_2__);
/* harmony import */ var _reportWebVitals__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./reportWebVitals */ "./src/reportWebVitals.js");
/* harmony import */ var _components__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./components */ "./src/components/index.js");
/* harmony import */ var _i18n__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./i18n */ "./src/i18n.js");

var _jsxFileName = "/Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/src/index.js";




 // ReactDOM.render(
//   <React.StrictMode>
//     <HookSample />
//   </React.StrictMode>,
//   document.getElementById("HookSample1")
// );
// ReactDOM.render(
//   <React.StrictMode>
//     <HookSample />
//   </React.StrictMode>,
//   document.getElementById("HookSample2")
// );

react_dom__WEBPACK_IMPORTED_MODULE_2___default.a.render( /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])(react__WEBPACK_IMPORTED_MODULE_1___default.a.StrictMode, {
  children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])(_components__WEBPACK_IMPORTED_MODULE_4__["Header"], {
    themePath: document.getElementById('reactHeader').getAttribute('data-themePath'),
    mainNavigation: document.getElementById('reactHeader').getAttribute('data-mainNavigation'),
    productCategories: document.getElementById('reactHeader').getAttribute('data-productCategories')
  }, void 0, false, {
    fileName: _jsxFileName,
    lineNumber: 21,
    columnNumber: 5
  }, undefined)
}, void 0, false, {
  fileName: _jsxFileName,
  lineNumber: 20,
  columnNumber: 3
}, undefined), document.getElementById('reactHeader'));
react_dom__WEBPACK_IMPORTED_MODULE_2___default.a.render( /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])(react__WEBPACK_IMPORTED_MODULE_1___default.a.StrictMode, {
  children: /*#__PURE__*/Object(react_jsx_dev_runtime__WEBPACK_IMPORTED_MODULE_0__["jsxDEV"])(_components__WEBPACK_IMPORTED_MODULE_4__["Footer"], {
    isContact: document.getElementById('reactFooter').getAttribute('data-isContact'),
    contactUs: document.getElementById('reactFooter').getAttribute('data-contactUs'),
    getInTouch: document.getElementById('reactFooter').getAttribute('data-getInTouch'),
    siteLinks: document.getElementById('reactFooter').getAttribute('data-siteLinks'),
    stayInformed: document.getElementById('reactFooter').getAttribute('data-stayInformed'),
    copywriteDate: document.getElementById('reactFooter').getAttribute('data-copywriteDate')
  }, void 0, false, {
    fileName: _jsxFileName,
    lineNumber: 38,
    columnNumber: 5
  }, undefined)
}, void 0, false, {
  fileName: _jsxFileName,
  lineNumber: 37,
  columnNumber: 3
}, undefined), document.getElementById('reactFooter')); // If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals

Object(_reportWebVitals__WEBPACK_IMPORTED_MODULE_3__["default"])();

/***/ }),

/***/ "./src/locales/en/translation.json":
/*!*****************************************!*\
  !*** ./src/locales/en/translation.json ***!
  \*****************************************/
/*! exports provided: en, default */
/***/ (function(module) {

module.exports = JSON.parse("{\"en\":{\"translation\":{\"title\":\"Welcome to react using react-i18next\",\"sample\":\"sample translated text.\",\"Welcome to React\":\"Welcome to React and react-i18next\",\"description\":{\"part1\":\"Nested Key \",\"part2\":\"Switch language between english and german using buttons above.\"}}}}");

/***/ }),

/***/ "./src/locales/fr/translation.json":
/*!*****************************************!*\
  !*** ./src/locales/fr/translation.json ***!
  \*****************************************/
/*! exports provided: fr, default */
/***/ (function(module) {

module.exports = JSON.parse("{\"fr\":{\"translation\":{\"title\":\"Welcome to react using react-i18next (French)\",\"sample\":\"sample translated text. (French)\",\"Welcome to React\":\"Bienvenue à React et react-i18next (French)\",\"description\":{\"part1\":\"Nested Key (French)\",\"part2\":\"Switch language between english and german using buttons above. (French)\"}}}}");

/***/ }),

/***/ "./src/locales/index.js":
/*!******************************!*\
  !*** ./src/locales/index.js ***!
  \******************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _en_translation_json__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./en/translation.json */ "./src/locales/en/translation.json");
var _en_translation_json__WEBPACK_IMPORTED_MODULE_0___namespace = /*#__PURE__*/__webpack_require__.t(/*! ./en/translation.json */ "./src/locales/en/translation.json", 1);
/* harmony import */ var _fr_translation_json__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./fr/translation.json */ "./src/locales/fr/translation.json");
var _fr_translation_json__WEBPACK_IMPORTED_MODULE_1___namespace = /*#__PURE__*/__webpack_require__.t(/*! ./fr/translation.json */ "./src/locales/fr/translation.json", 1);


const resource = {
  en: _en_translation_json__WEBPACK_IMPORTED_MODULE_0__["en"],
  fr: _fr_translation_json__WEBPACK_IMPORTED_MODULE_1__["fr"]
};
/* harmony default export */ __webpack_exports__["default"] = (resource);

/***/ }),

/***/ "./src/reportWebVitals.js":
/*!********************************!*\
  !*** ./src/reportWebVitals.js ***!
  \********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
const reportWebVitals = onPerfEntry => {
  if (onPerfEntry && onPerfEntry instanceof Function) {
    __webpack_require__.e(/*! import() */ 1).then(__webpack_require__.bind(null, /*! web-vitals */ "./node_modules/web-vitals/dist/web-vitals.es5.min.js")).then(({
      getCLS,
      getFID,
      getFCP,
      getLCP,
      getTTFB
    }) => {
      getCLS(onPerfEntry);
      getFID(onPerfEntry);
      getFCP(onPerfEntry);
      getLCP(onPerfEntry);
      getTTFB(onPerfEntry);
    });
  }
};

/* harmony default export */ __webpack_exports__["default"] = (reportWebVitals);

/***/ }),

/***/ 0:
/*!**********************************************************************************!*\
  !*** multi ./node_modules/react-dev-utils/webpackHotDevClient.js ./src/index.js ***!
  \**********************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(/*! /Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/node_modules/react-dev-utils/webpackHotDevClient.js */"./node_modules/react-dev-utils/webpackHotDevClient.js");
module.exports = __webpack_require__(/*! /Users/tsmith/Documents/ten24/StoneAndBerg/custom/swreact/src/index.js */"./src/index.js");


/***/ })

},[[0,"runtime-main",0]]]);
//# sourceMappingURL=main.chunk.js.map