(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[7],{524:function(e,t,c){"use strict";var r=c(31);c.d(t,"a",(function(){return r.a}));var a=c(32);c.d(t,"c",(function(){return a.c}));var n=c(65);c.d(t,"b",(function(){return n.a}));c(55)},528:function(e,t,c){"use strict";c.r(t);var r=c(1),a=c.n(r),n=c(26),s=c(3),j=c(12),b=c(10),o=c(147),d=c(148),i=c(39),l=c(22),h=c.n(l),u=c(2),O=c(6),x=c(24),p=c(37),f=c(30),m=c(32),v=c(524),y=c(149),g=(c(44),c(17)),P=(c(50),c(28),c(146)),w=c(0),z=function(e){var t=e.type,c=void 0===t?"info":t,r=e.text;return Object(w.jsx)("span",{className:"badge badge-".concat(c," m-0"),children:r})},N=function(e){var t=Object(v.a)({}),c=Object(O.a)(t,1)[0],r=Object(v.b)(),a=Object(O.a)(r,1)[0],n=Object(s.c)(),j=Object(f.a)().t,b=e.orderID,o=e.createdDateTime,d=e.orderStatusType_typeName,i=e.calculatedTotal;return Object(w.jsxs)("tr",{children:[Object(w.jsx)("td",{className:"py-3",children:a(o)}),Object(w.jsx)("td",{className:"py-3",children:Object(w.jsx)(z,{text:d})}),Object(w.jsx)("td",{className:"py-3",children:c(i)}),Object(w.jsxs)("td",{className:"py-3",children:[Object(w.jsx)(y.a,{onClick:function(e){n(Object(g.y)(b)),window.scrollTo({top:0,behavior:"smooth"})},children:j("frontend.account.order.change_order")}),Object(w.jsx)("br",{})]})]})},k=function(){var e=Object(r.useState)(""),t=Object(O.a)(e,2),c=t[0],a=t[1],s=Object(f.a)().t,j=Object(m.a)(),b=Object(O.a)(j,2),o=b[0],d=b[1],i=function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:1;d(Object(u.a)(Object(u.a)({},o),{},{params:{currentPage:e,pageRecordsShow:10,keyword:c},makeRequest:!0,isFetching:!0,isLoaded:!1}))};return Object(r.useEffect)((function(){var e=!1;return o.isFetching||o.isLoaded||e||d(Object(u.a)(Object(u.a)({},o),{},{isFetching:!0,isLoaded:!1,params:{pageRecordsShow:20,keyword:c},makeRequest:!0})),function(){e=!0}}),[o,c,d]),Object(w.jsxs)(x.a,{children:[Object(w.jsx)(p.a,{}),Object(w.jsx)(P.a,{term:c,updateTerm:a,search:i}),Object(w.jsx)("div",{className:"table-responsive font-size-md",children:Object(w.jsxs)("table",{className:"table table-hover mb-0",children:[Object(w.jsx)("thead",{children:Object(w.jsxs)("tr",{children:[Object(w.jsx)("th",{children:s("frontend.core.date_created")}),Object(w.jsx)("th",{children:s("frontend.account.order.status")}),Object(w.jsxs)("th",{children:[" ",s("frontend.account.order.total")]}),Object(w.jsx)("th",{children:s("frontend.account.order.select_order")})]})}),Object(w.jsx)("tbody",{children:o.isLoaded&&o.data.map((function(e,t){return Object(w.jsx)(N,Object(u.a)({},e),t)}))})]})}),Object(w.jsx)("hr",{className:"pb-4"}),Object(w.jsx)(n.v,{recordsCount:o.data.records,currentPage:o.data.currentPage,totalPages:Math.ceil(o.data.records/20),setPage:i})]})},R=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,164))})),S=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,187))})),T=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,190))})),F=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,162))})),L=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,160))})),_=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,161))})),D=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,185))})),q=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,188))})),C=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,186))})),E=a.a.lazy((function(){return Promise.resolve().then(c.bind(null,189))}));t.default=function(){var e=Object(j.j)(),t=Object(j.h)(),c=Object(s.c)(),a=Object(s.d)((function(e){return e.userReducer}));if(Object(r.useEffect)((function(){!Object(i.c)()||a.isFetching||a.accountID.length||c(Object(b.s)())}),[c,a]),Object(i.c)()&&t.search.includes("redirect=")){var l=h.a.parse(t.search);return Object(w.jsx)(j.a,{to:l.redirect})}var u=t.pathname.split("/").reverse();return Object(w.jsxs)(n.t,{children:[Object(i.c)()&&Object(w.jsxs)(j.d,{children:[Object(w.jsx)(j.b,{path:"".concat(e.path,"/addresses/:id"),children:Object(w.jsx)(_,{path:u[0]})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/addresses"),children:Object(w.jsx)(L,{})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/cards/:id"),children:Object(w.jsx)(E,{path:u[0]})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/cards"),children:Object(w.jsx)(q,{})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/favorites"),children:Object(w.jsx)(F,{})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/orders/:id"),children:Object(w.jsx)(D,{path:u[0],forwardState:t.state})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/orders"),children:Object(w.jsx)(C,{})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/profile"),children:Object(w.jsx)(T,{})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/carts"),children:Object(w.jsx)(k,{})}),Object(w.jsx)(j.b,{path:e.path,children:Object(i.c)()&&Object(w.jsx)(S,{})})]}),!Object(i.c)()&&Object(w.jsxs)(j.d,{children:[Object(w.jsx)(j.b,{path:"".concat(e.path,"/createAccount"),children:Object(w.jsx)(o.a,{})}),Object(w.jsx)(j.b,{path:"".concat(e.path,"/forgotPassword"),children:Object(w.jsx)(d.a,{})}),Object(w.jsx)(j.b,{path:e.path,children:Object(w.jsx)(R,{})})]})]})}}}]);
//# sourceMappingURL=7.88b2a8aa.chunk.js.map