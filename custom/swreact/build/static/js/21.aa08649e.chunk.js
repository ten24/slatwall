(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[21],{513:function(a,t,e){"use strict";e.r(t);var r=e(2),c=e(5),s=e(121),o=e(21),i=e(120),n=e(11),d=e(27),p=e(3),u=e(18),j=e.n(u),h=e(1),b=e(0);t.default=function(){var a,t=Object(n.h)(),e=j.a.parse(t.search,{arrayFormat:"separator",arrayFormatSeparator:","}),u=Object(n.g)(),l=Object(d.g)(),y=Object(c.a)(l,2),O=y[0],f=y[1],m=Object(p.d)((function(a){return a.configuration.filtering.productTypeBase})),g=e.key||m;return Object(h.useEffect)((function(){O.isFetching||O.isLoaded||f(Object(r.a)(Object(r.a)({},O),{},{isFetching:!0,isLoaded:!1,params:{urlTitle:g},makeRequest:!0}))}),[O,f,g]),!O.isFetching&&O.isLoaded&&0===Object.keys(O.data).length?Object(b.jsx)(n.a,{to:"/404"}):(u.listen((function(a){var t=j.a.parse(a.search,{arrayFormat:"separator",arrayFormatSeparator:","});f(Object(r.a)(Object(r.a)({},O),{},{data:{},isFetching:!0,isLoaded:!1,params:{urlTitle:t.key||m},makeRequest:!0}))})),Object(b.jsxs)(o.o,{children:[Object(b.jsx)(s.a,{title:"Search - ".concat(e.keyword)}),(null===(a=O.data.childProductTypes)||void 0===a?void 0:a.length)>0&&Object(b.jsx)(o.w,{data:O.data,onSelect:function(a){e.key=a,u.push("".concat(t.pathname,"?").concat(j.a.stringify(e,{arrayFormat:"comma"})))}}),O.data.showProducts&&Object(b.jsx)(i.a,{preFilter:{productType_id:O.data.productTypeID},hide:["productType"]})]}))}}}]);
//# sourceMappingURL=21.aa08649e.chunk.js.map