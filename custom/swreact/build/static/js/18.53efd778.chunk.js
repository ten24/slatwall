(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[18],{303:function(e,t,c){"use strict";var s=c(10),n=c(0);t.a=function(e){var t=e.customBody,c=void 0===t?"":t,a=e.contentTitle,r=void 0===a?"":a,i=Object(s.f)();return Object(n.jsxs)(n.Fragment,{children:[Object(n.jsx)("div",{className:"d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3",children:Object(n.jsx)("div",{className:"d-flex justify-content-between w-100",children:Object(n.jsx)("h2",{className:"h3",children:r})})}),Object(n.jsx)("div",{onClick:function(e){e.preventDefault(),e.target.getAttribute("href")&&i.push(e.target.getAttribute("href"))},dangerouslySetInnerHTML:{__html:c}})]})}},448:function(e,t,c){"use strict";c.r(t);var s=c(2),n=(c(1),c(4)),a=c(295),r=c(303),i=c(7),d=c(339),o=c.n(d),l=c(340),j=c.n(l),b=c(13),u=c(291),m=c(0),h=function(e){var t=e.accountAddressID,c=e.address,a=c.streetAddress,r=c.addressID,d=c.city,l=c.stateCode,h=c.postalCode,f=c.isPrimary,O=j()(o.a),x=Object(n.c)(),p=Object(u.a)(),y=p.t;p.i18n;return Object(m.jsxs)("tr",{children:[Object(m.jsxs)("td",{className:"py-3 align-middle",children:["".concat(a," ").concat(d,",").concat(l," ").concat(h)," ",f&&Object(m.jsx)("span",{className:"align-middle badge badge-info ml-2",children:y("frontend.core.prinary")})]}),Object(m.jsxs)("td",{className:"py-3 align-middle",children:[Object(m.jsx)(i.b,{className:"nav-link-style mr-2",to:{pathname:"/my-account/addresses/".concat(r),state:Object(s.a)({},e)},"data-toggle":"tooltip",children:Object(m.jsx)("i",{className:"far fa-edit"})}),Object(m.jsx)("a",{className:"nav-link-style text-primary",onClick:function(){O.fire({icon:"info",title:Object(m.jsx)("p",{children:y("frontend.account.address.remove")}),showCloseButton:!0,showCancelButton:!0,focusConfirm:!1,confirmButtonText:y("frontend.core.delete")}).then((function(e){e.isConfirmed&&x(Object(b.l)(t))}))},children:Object(m.jsx)("i",{className:"far fa-trash-alt"})})]})]})};t.default=Object(n.b)((function(e){return e.userReducer}))((function(e){var t=e.primaryAddress,c=e.accountAddresses,n=e.title,d=e.customBody,o=e.contentTitle,l=Object(u.a)(),j=l.t;l.i18n;return Object(m.jsxs)(a.a,{title:n,children:[Object(m.jsx)(r.a,{customBody:d,contentTitle:o}),Object(m.jsx)("div",{className:"table-responsive font-size-md",children:Object(m.jsxs)("table",{className:"table table-hover mb-0",children:[Object(m.jsx)("thead",{children:Object(m.jsxs)("tr",{children:[Object(m.jsx)("th",{children:j("frontend.account.address.heading")}),Object(m.jsx)("th",{children:j("frontend.core.actions")})]})}),Object(m.jsx)("tbody",{children:c&&c.map((function(e,c){return Object(m.jsx)(h,Object(s.a)(Object(s.a)({},e),{},{isPrimary:e.accountAddressID===t.accountAddressID}),c)}))})]})}),Object(m.jsx)("hr",{className:"pb-4"}),Object(m.jsx)("div",{className:"text-sm-right",children:Object(m.jsx)(i.b,{className:"btn btn-primary",to:"/my-account/addresses/new",children:j("frontend.account.address.add")})})]})}))}}]);
//# sourceMappingURL=18.53efd778.chunk.js.map