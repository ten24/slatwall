(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[7],{516:function(e,t,c){"use strict";var r=c(32);c.d(t,"a",(function(){return r.a}));var a=c(33);c.d(t,"c",(function(){return a.c}));var n=c(65);c.d(t,"b",(function(){return n.a}));c(55)},520:function(e,t,c){"use strict";c.r(t);var r=c(1),a=c.n(r),n=c(28),s=c(3),j=c(12),o=c(10),b=c(142),i=c(143),d=c(31),l=c(20),h=c.n(l),u=c(2),O=c(6),x=c(25),p=c(30),f=c(33),m=c(516),v=c(8),y=(c(44),c(17)),g=(c(51),c(26),c(141)),P=c(0),w=function(e){var t=e.type,c=void 0===t?"info":t,r=e.text;return Object(P.jsx)("span",{className:"badge badge-".concat(c," m-0"),children:r})},z=function(e){var t=Object(m.a)({}),c=Object(O.a)(t,1)[0],r=Object(m.b)(),a=Object(O.a)(r,1)[0],n=Object(s.c)(),j=Object(p.a)().t,o=e.orderID,b=e.createdDateTime,i=e.orderStatusType_typeName,d=e.calculatedTotal;return Object(P.jsxs)("tr",{children:[Object(P.jsx)("td",{className:"py-3",children:a(b)}),Object(P.jsx)("td",{className:"py-3",children:Object(P.jsx)(w,{text:i})}),Object(P.jsx)("td",{className:"py-3",children:c(d)}),Object(P.jsxs)("td",{className:"py-3",children:[Object(P.jsx)(v.b,{className:"text-link",onClick:function(e){n(Object(y.y)(o)),window.scrollTo({top:0,behavior:"smooth"})},children:j("frontend.account.order.change_order")}),Object(P.jsx)("br",{})]})]})},N=function(e){e.customBody;var t=e.crumbs,c=e.title,a=(e.contentTitle,Object(r.useState)("")),s=Object(O.a)(a,2),j=s[0],o=s[1],b=Object(p.a)().t,i=Object(f.a)(),d=Object(O.a)(i,2),l=d[0],h=d[1],m=function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:1;h(Object(u.a)(Object(u.a)({},l),{},{params:{currentPage:e,pageRecordsShow:10,keyword:j},makeRequest:!0,isFetching:!0,isLoaded:!1}))};return Object(r.useEffect)((function(){var e=!1;return l.isFetching||l.isLoaded||e||h(Object(u.a)(Object(u.a)({},l),{},{isFetching:!0,isLoaded:!1,params:{pageRecordsShow:20,keyword:j},makeRequest:!0})),function(){e=!0}}),[l,j,h]),Object(P.jsxs)(x.a,{crumbs:t,title:c,children:[Object(P.jsx)(g.a,{term:j,updateTerm:o,search:m}),Object(P.jsx)("div",{className:"table-responsive font-size-md",children:Object(P.jsxs)("table",{className:"table table-hover mb-0",children:[Object(P.jsx)("thead",{children:Object(P.jsxs)("tr",{children:[Object(P.jsx)("th",{children:b("frontend.core.date_created")}),Object(P.jsx)("th",{children:b("frontend.account.order.status")}),Object(P.jsxs)("th",{children:[" ",b("frontend.account.order.total")]}),Object(P.jsx)("th",{children:b("frontend.account.order.select_order")})]})}),Object(P.jsx)("tbody",{children:l.isLoaded&&l.data.map((function(e,t){return Object(P.jsx)(z,Object(u.a)({},e),t)}))})]})}),Object(P.jsx)("hr",{className:"pb-4"}),Object(P.jsx)(n.v,{recordsCount:l.data.records,currentPage:l.data.currentPage,totalPages:Math.ceil(l.data.records/20),setPage:m})]})},k=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,158))})),T=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,183))})),R=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,186))})),S=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,157))})),F=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,155))})),L=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,156))})),_=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,181))})),D=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,184))})),q=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,182))})),C=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,185))}));t.default=function(){var e=Object(j.j)(),t=Object(j.h)(),c=Object(s.c)(),a=Object(s.d)((function(e){return e.userReducer}));if(Object(r.useEffect)((function(){!Object(d.e)()||a.isFetching||a.accountID.length||c(Object(o.u)())}),[c,a]),Object(d.e)()&&t.search.includes("redirect=")){var l=h.a.parse(t.search);return Object(P.jsx)(j.a,{to:l.redirect})}var u=t.pathname.split("/").reverse();return Object(P.jsxs)(n.t,{children:[Object(d.e)()&&Object(P.jsxs)(j.d,{children:[Object(P.jsx)(j.b,{path:"".concat(e.path,"/addresses/:id"),children:Object(P.jsx)(L,{path:u[0]})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/addresses"),children:Object(P.jsx)(F,{})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/cards/:id"),children:Object(P.jsx)(C,{path:u[0]})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/cards"),children:Object(P.jsx)(D,{})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/favorites"),children:Object(P.jsx)(S,{})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/orders/:id"),children:Object(P.jsx)(_,{path:u[0],forwardState:t.state})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/orders"),children:Object(P.jsx)(q,{})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/profile"),children:Object(P.jsx)(R,{})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/carts"),children:Object(P.jsx)(N,{})}),Object(P.jsx)(j.b,{path:e.path,children:Object(d.e)()&&Object(P.jsx)(T,{})})]}),!Object(d.e)()&&Object(P.jsxs)(j.d,{children:[Object(P.jsx)(j.b,{path:"".concat(e.path,"/createAccount"),children:Object(P.jsx)(b.a,{})}),Object(P.jsx)(j.b,{path:"".concat(e.path,"/forgotPassword"),children:Object(P.jsx)(i.a,{})}),Object(P.jsx)(j.b,{path:e.path,children:Object(P.jsx)(k,{})})]})]})}}}]);
//# sourceMappingURL=7.f65dd27b.chunk.js.map