(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[7],{237:function(e,t,s){"use strict";var c=s(0),a=s(7),l=s(35),i=s(21),r=s(6),n=function(e){var t=e.user,s=Object(r.c)();return Object(c.jsx)("aside",{className:"col-lg-4 pt-4 pt-lg-0",children:Object(c.jsxs)("div",{className:"cz-sidebar-static rounded-lg box-shadow-lg px-0 pb-0 mb-5 mb-lg-0",children:[Object(c.jsx)("div",{className:"px-4 mb-4",children:Object(c.jsx)("div",{className:"media align-items-center",children:Object(c.jsxs)("div",{className:"media-body",children:[Object(c.jsx)("h3",{className:"font-size-base mb-0",children:"".concat(t.firstName," ").concat(t.lastName)}),Object(c.jsx)("a",{href:"#",onClick:function(){s(Object(i.f)())},className:"text-accent font-size-sm",children:"Logout"}),Object(c.jsx)("br",{}),Object(c.jsx)(a.b,{to:"/testing"})]})})}),Object(c.jsx)("div",{className:"bg-secondary px-4 py-3",children:Object(c.jsx)("h3",{className:"font-size-sm mb-0 text-muted",children:Object(c.jsx)(a.b,{to:"/my-account",className:"nav-link-style active",children:"Overview"})})}),Object(c.jsxs)("ul",{className:"list-unstyled mb-0",children:[Object(c.jsx)("li",{className:"border-bottom mb-0",children:Object(c.jsxs)(a.b,{to:"/my-account/order-history",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(c.jsx)("i",{className:"far fa-shopping-bag pr-2"})," Order History"]})}),Object(c.jsx)("li",{className:"border-bottom mb-0",children:Object(c.jsxs)(a.b,{to:"/my-account/profile",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(c.jsx)("i",{className:"far fa-user pr-2"})," Profile Info"]})}),Object(c.jsx)("li",{className:"border-bottom mb-0",children:Object(c.jsxs)(a.b,{to:"/my-account/favorites",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(c.jsx)("i",{className:"far fa-heart pr-2"})," Favorties"]})}),Object(c.jsx)("li",{className:"border-bottom mb-0",children:Object(c.jsxs)(a.b,{to:"/my-account/addresses",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(c.jsx)("i",{className:"far fa-map-marker-alt pr-2"})," Addresses"]})}),Object(c.jsx)("li",{className:"mb-0",children:Object(c.jsxs)(a.b,{to:"/my-account/cards",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(c.jsx)("i",{className:"far fa-credit-card pr-2"})," Payment Methods"]})})]})]})})},d=function(e){var t=e.crumbs,s=e.title;return Object(c.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(c.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(c.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(c.jsx)(l.b,{crumbs:t})}),Object(c.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(c.jsx)("h1",{className:"h3 mb-0",children:s})})]})})};t.a=Object(r.b)((function(e){return{user:e.userReducer}}))((function(e){var t=e.crumbs,s=e.children,a=e.title,l=e.user;return Object(c.jsxs)(c.Fragment,{children:[Object(c.jsx)(d,{crumbs:t,title:a}),Object(c.jsx)("div",{className:"container pb-5 mb-2 mb-md-3",children:Object(c.jsxs)("div",{className:"row",children:[Object(c.jsx)(n,{user:l}),Object(c.jsx)("section",{className:"col-lg-8",children:s})]})})]})}))},239:function(e,t,s){"use strict";var c=s(0),a=s(8);t.a=function(e){var t=e.customBody,s=e.contentTitle,l=Object(a.f)();return Object(c.jsxs)(c.Fragment,{children:[Object(c.jsx)("div",{className:"d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3",children:Object(c.jsx)("div",{className:"d-flex justify-content-between w-100",children:Object(c.jsx)("h2",{className:"h3",children:s})})}),Object(c.jsx)("div",{onClick:function(e){e.preventDefault(),l.push(e.target.getAttribute("href"))},dangerouslySetInnerHTML:{__html:t}})]})}},259:function(e,t,s){"use strict";s.r(t);var c=s(2),a=s(0),l=(s(1),s(6)),i=s(237),r=s(239),n=function(e){var t=e.type,s=e.ending,c=e.isPrimary,l=e.name,i=e.expirationDate;return Object(a.jsxs)("tr",{children:[Object(a.jsx)("td",{className:"py-3 align-middle",children:Object(a.jsx)("div",{className:"media align-items-center",children:Object(a.jsxs)("div",{className:"media-body",children:[Object(a.jsx)("span",{className:"font-weight-medium text-heading mr-1",children:t}),s,c&&Object(a.jsx)("span",{className:"align-middle badge badge-info ml-2",children:"Primary"})]})})}),Object(a.jsx)("td",{className:"py-3 align-middle",children:l}),Object(a.jsx)("td",{className:"py-3 align-middle",children:i}),Object(a.jsxs)("td",{className:"py-3 align-middle",children:[Object(a.jsx)("a",{className:"nav-link-style mr-2",href:"##","data-toggle":"tooltip",title:"","data-original-title":"Edit",children:Object(a.jsx)("i",{className:"far fa-edit"})}),Object(a.jsx)("a",{className:"nav-link-style text-primary",href:"##","data-toggle":"tooltip",title:"","data-original-title":"Remove",children:Object(a.jsx)("i",{className:"far fa-trash-alt"})})]})]})};t.default=Object(l.b)((function(e){return e.preload.accountPaymentMethods}))((function(e){var t=e.crumbs,s=e.title,l=e.customBody,d=e.contentTitle,j=e.paymentMethods;return Object(a.jsxs)(i.a,{crumbs:t,title:s,children:[Object(a.jsx)(r.a,{customBody:l,contentTitle:d}),Object(a.jsx)("div",{className:"table-responsive font-size-md",children:Object(a.jsxs)("table",{className:"table table-hover mb-0",children:[Object(a.jsx)("thead",{children:Object(a.jsxs)("tr",{children:[Object(a.jsx)("th",{children:"Your credit / debit cards"}),Object(a.jsx)("th",{children:"Name on card"}),Object(a.jsx)("th",{children:"Expires on"}),Object(a.jsx)("th",{})]})}),Object(a.jsx)("tbody",{children:j&&j.map((function(e,t){return Object(a.jsx)(n,Object(c.a)({},e),t)}))})]})}),Object(a.jsx)("hr",{className:"pb-4"}),Object(a.jsx)("div",{className:"text-sm-right",children:Object(a.jsx)("a",{className:"btn btn-primary",href:"##add-address","data-toggle":"modal",children:"Add new address"})})]})}))}}]);
//# sourceMappingURL=7.55b7cbea.chunk.js.map