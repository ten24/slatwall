(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[7],{100:function(e,t,s){"use strict";var c=s(5),a=s.n(c),r=s(10),l=s(3),n=s(31),i=s(99),d=s(15),b=s(30),j=function(e){var t=e.logout,s=e.user;return Object(l.jsx)("aside",{className:"col-lg-4 pt-4 pt-lg-0",children:Object(l.jsxs)("div",{className:"cz-sidebar-static rounded-lg box-shadow-lg px-0 pb-0 mb-5 mb-lg-0",children:[Object(l.jsx)("div",{className:"px-4 mb-4",children:Object(l.jsx)("div",{className:"media align-items-center",children:Object(l.jsxs)("div",{className:"media-body",children:[Object(l.jsx)("h3",{className:"font-size-base mb-0",children:"".concat(s.firstName," ").concat(s.lastName)}),Object(l.jsx)("a",{href:"#",onClick:function(){t()},className:"text-accent font-size-sm",children:"Logout"}),Object(l.jsx)("br",{}),Object(l.jsx)(n.b,{to:"/testing"})]})})}),Object(l.jsx)("div",{className:"bg-secondary px-4 py-3",children:Object(l.jsx)("h3",{className:"font-size-sm mb-0 text-muted",children:Object(l.jsx)(n.b,{to:"/my-account",className:"nav-link-style active",children:"Overview"})})}),Object(l.jsxs)("ul",{className:"list-unstyled mb-0",children:[Object(l.jsx)("li",{className:"border-bottom mb-0",children:Object(l.jsxs)(n.b,{to:"/my-account/order-history",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(l.jsx)("i",{className:"far fa-shopping-bag pr-2"})," Order History"]})}),Object(l.jsx)("li",{className:"border-bottom mb-0",children:Object(l.jsxs)(n.b,{to:"/my-account/profile",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(l.jsx)("i",{className:"far fa-user pr-2"})," Profile Info"]})}),Object(l.jsx)("li",{className:"border-bottom mb-0",children:Object(l.jsxs)(n.b,{to:"/my-account/favorites",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(l.jsx)("i",{className:"far fa-heart pr-2"})," Favorties"]})}),Object(l.jsx)("li",{className:"border-bottom mb-0",children:Object(l.jsxs)(n.b,{to:"/my-account/addresses",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(l.jsx)("i",{className:"far fa-map-marker-alt pr-2"})," Addresses"]})}),Object(l.jsx)("li",{className:"mb-0",children:Object(l.jsxs)(n.b,{to:"/my-account/cards",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(l.jsx)("i",{className:"far fa-credit-card pr-2"})," Payment Methods"]})})]})]})})},m=function(e){var t=e.crumbs,s=e.title;return Object(l.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(l.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(l.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(l.jsx)(i.b,{crumbs:t})}),Object(l.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(l.jsx)("h1",{className:"h3 mb-0",children:s})})]})})};t.a=Object(b.b)((function(e){return{user:e.userReducer}}),(function(e){return{logout:function(){var t=Object(r.a)(a.a.mark((function t(){return a.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.abrupt("return",e(Object(d.f)()));case 1:case"end":return t.stop()}}),t)})));return function(){return t.apply(this,arguments)}}()}}))((function(e){var t=e.crumbs,s=e.children,c=e.title,a=e.logout,r=e.user;return Object(l.jsxs)(l.Fragment,{children:[Object(l.jsx)(m,{crumbs:t,title:c}),Object(l.jsx)("div",{className:"container pb-5 mb-2 mb-md-3",children:Object(l.jsxs)("div",{className:"row",children:[Object(l.jsx)(j,{logout:a,user:r}),Object(l.jsx)("section",{className:"col-lg-8",children:s})]})})]})}))},102:function(e,t,s){"use strict";var c=s(3);t.a=function(e){var t=e.customBody,s=e.contentTitle;return Object(c.jsxs)(c.Fragment,{children:[Object(c.jsx)("div",{className:"d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3",children:Object(c.jsx)("div",{className:"d-flex justify-content-between w-100",children:Object(c.jsx)("h2",{className:"h3",children:s})})}),Object(c.jsx)("div",{dangerouslySetInnerHTML:{__html:t}})]})}},149:function(e,t,s){"use strict";s.r(t);var c=s(1),a=s(3),r=(s(0),s(30)),l=s(100),n=s(102),i=function(e){var t=e.location,s=e.isPrimary;return Object(a.jsxs)("tr",{children:[Object(a.jsxs)("td",{className:"py-3 align-middle",children:[t," ",s&&Object(a.jsx)("span",{className:"align-middle badge badge-info ml-2",children:"Primary"})]}),Object(a.jsxs)("td",{className:"py-3 align-middle",children:[Object(a.jsx)("a",{className:"nav-link-style mr-2",href:"##","data-toggle":"tooltip",title:"","data-original-title":"Edit",children:Object(a.jsx)("i",{className:"far fa-edit"})}),Object(a.jsx)("a",{className:"nav-link-style text-primary",href:"##","data-toggle":"tooltip",title:"","data-original-title":"Remove",children:Object(a.jsx)("i",{className:"far fa-trash-alt"})})]})]})};t.default=Object(r.b)((function(e){return e.preload.accountAddresses}))((function(e){var t=e.crumbs,s=e.title,r=e.customBody,d=e.contentTitle,b=e.addresses;return Object(a.jsxs)(l.a,{crumbs:t,title:s,children:[Object(a.jsx)(n.a,{customBody:r,contentTitle:d}),Object(a.jsx)("div",{className:"table-responsive font-size-md",children:Object(a.jsxs)("table",{className:"table table-hover mb-0",children:[Object(a.jsx)("thead",{children:Object(a.jsxs)("tr",{children:[Object(a.jsx)("th",{children:"Address"}),Object(a.jsx)("th",{children:"Actions"})]})}),Object(a.jsx)("tbody",{children:b&&b.map((function(e,t){return Object(a.jsx)(i,Object(c.a)({},e),t)}))})]})}),Object(a.jsx)("hr",{className:"pb-4"}),Object(a.jsx)("div",{className:"text-sm-right",children:Object(a.jsx)("a",{className:"btn btn-primary",href:"##add-address","data-toggle":"modal",children:"Add new address"})})]})}))}}]);
//# sourceMappingURL=7.d3452784.chunk.js.map