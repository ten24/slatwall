(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[5],{110:function(e,n,t){var r=t(111),i=t(112),o=t(113),a=t(115);e.exports=function(e,n){return r(e)||i(e,n)||o(e,n)||a()}},111:function(e,n){e.exports=function(e){if(Array.isArray(e))return e}},112:function(e,n){e.exports=function(e,n){if("undefined"!==typeof Symbol&&Symbol.iterator in Object(e)){var t=[],r=!0,i=!1,o=void 0;try{for(var a,c=e[Symbol.iterator]();!(r=(a=c.next()).done)&&(t.push(a.value),!n||t.length!==n);r=!0);}catch(s){i=!0,o=s}finally{try{r||null==c.return||c.return()}finally{if(i)throw o}}return t}}},113:function(e,n,t){var r=t(114);e.exports=function(e,n){if(e){if("string"===typeof e)return r(e,n);var t=Object.prototype.toString.call(e).slice(8,-1);return"Object"===t&&e.constructor&&(t=e.constructor.name),"Map"===t||"Set"===t?Array.from(e):"Arguments"===t||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t)?r(e,n):void 0}}},114:function(e,n){e.exports=function(e,n){(null==n||n>e.length)&&(n=e.length);for(var t=0,r=new Array(n);t<n;t++)r[t]=e[t];return r}},115:function(e,n){e.exports=function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}},135:function(e,n,t){"use strict";t.r(n);var r=t(4),i=t(0),o=t(110),a=t.n(o),c=t(27),s=t.n(c),l=t(66);function u(){if(console&&console.warn){for(var e,n=arguments.length,t=new Array(n),r=0;r<n;r++)t[r]=arguments[r];"string"===typeof t[0]&&(t[0]="react-i18next:: ".concat(t[0])),(e=console).warn.apply(e,t)}}var f={};function d(){for(var e=arguments.length,n=new Array(e),t=0;t<e;t++)n[t]=arguments[t];"string"===typeof n[0]&&f[n[0]]||("string"===typeof n[0]&&(f[n[0]]=new Date),u.apply(void 0,n))}function b(e,n,t){e.loadNamespaces(n,(function(){if(e.isInitialized)t();else{e.on("initialized",(function n(){setTimeout((function(){e.off("initialized",n)}),0),t()}))}}))}function p(e,n){var t=arguments.length>2&&void 0!==arguments[2]?arguments[2]:{};if(!n.languages||!n.languages.length)return d("i18n.languages were undefined or empty",n.languages),!0;var r=n.languages[0],i=!!n.options&&n.options.fallbackLng,o=n.languages[n.languages.length-1];if("cimode"===r.toLowerCase())return!0;var a=function(e,t){var r=n.services.backendConnector.state["".concat(e,"|").concat(t)];return-1===r||2===r};return!(t.bindI18n&&t.bindI18n.indexOf("languageChanging")>-1&&n.services.backendConnector.backend&&n.isLanguageChangingTo&&!a(n.isLanguageChangingTo,e))&&(!!n.hasResourceBundle(r,e)||(!n.services.backendConnector.backend||!(!a(r,e)||i&&!a(o,e))))}function g(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,r)}return t}function j(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?g(Object(t),!0).forEach((function(n){s()(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):g(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}var h=t(21),y=t(68),v=function(){var e=function(e){var n=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{},t=n.i18n,r=Object(i.useContext)(l.a)||{},o=r.i18n,c=r.defaultNS,s=t||o||Object(l.d)();if(s&&!s.reportNamespaces&&(s.reportNamespaces=new l.b),!s){d("You will need to pass in an i18next instance by using initReactI18next");var u=function(e){return Array.isArray(e)?e[e.length-1]:e},f=[u,{},!1];return f.t=u,f.i18n={},f.ready=!1,f}var g=j(j(j({},Object(l.c)()),s.options.react),n),h=g.useSuspense,y=e||c||s.options&&s.options.defaultNS;y="string"===typeof y?[y]:y||["translation"],s.reportNamespaces.addUsedNamespaces&&s.reportNamespaces.addUsedNamespaces(y);var v=(s.isInitialized||s.initializedStoreOnce)&&y.every((function(e){return p(e,s,g)}));function O(){return{t:s.getFixedT(null,"fallback"===g.nsMode?y:y[0])}}var m=Object(i.useState)(O()),x=a()(m,2),w=x[0],N=x[1],S=Object(i.useRef)(!0);Object(i.useEffect)((function(){var e=g.bindI18n,n=g.bindI18nStore;function t(){S.current&&N(O())}return S.current=!0,v||h||b(s,y,(function(){S.current&&N(O())})),e&&s&&s.on(e,t),n&&s&&s.store.on(n,t),function(){S.current=!1,e&&s&&e.split(" ").forEach((function(e){return s.off(e,t)})),n&&s&&n.split(" ").forEach((function(e){return s.store.off(e,t)}))}}),[y.join()]);var k=[w.t,s,v];if(k.t=w.t,k.i18n=s,k.ready=v,v)return k;if(!v&&!h)return k;throw new Promise((function(e){b(s,y,(function(){e()}))}))}().t;return Object(r.jsxs)("div",{children:[Object(r.jsx)("h1",{children:e("Translation Exmaple")}),Object(r.jsx)("p",{children:e("admin.entity.brandTabs.vendors")}),Object(r.jsx)("button",{type:"button",className:"btn btn-outline-primary",onClick:function(){h.a.changeLanguage("en"),window.localStorage.setItem("i18nextLng","en")},children:"Set English"}),Object(r.jsx)("button",{type:"button",className:"btn btn-outline-primary",onClick:function(){h.a.changeLanguage("fr"),window.localStorage.setItem("i18nextLng","fr")},children:"Set French"})]})},O=function(){return Object(r.jsxs)("div",{children:[Object(r.jsx)("h1",{children:"Cart Tools"}),Object(r.jsx)("p",{}),Object(r.jsx)("button",{className:"btn btn-outline-primary",onClick:function(){console.log("Add to Cart")},children:"Add To Cart"})]})};n.default=function(e){return Object(r.jsx)(y.h,{children:Object(r.jsxs)("div",{className:"bg-light p-0",children:[Object(r.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(r.jsx)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:Object(r.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center",children:Object(r.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:"Kitchen Sink"})})})}),Object(r.jsx)("div",{className:"container bg-light box-shadow-lg rounded-lg p-5",children:Object(r.jsxs)("div",{className:"row",children:[Object(r.jsx)("div",{className:"col-sm",children:Object(r.jsx)(v,{})}),Object(r.jsx)("div",{className:"col-sm",children:Object(r.jsx)(O,{})})]})})]})})}}}]);
//# sourceMappingURL=5.2677aac6.chunk.js.map