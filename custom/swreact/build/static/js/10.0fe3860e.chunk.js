(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[10],{539:function(a,e,t){"use strict";t.r(e);var r=t(2),s=t(5),i=t(28),c=t(0),n=function(a){var e=a.brandName,t=a.imageFile,r=a.brandDescription;return Object(c.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(c.jsx)(i.H,{style:{maxHeight:"150px",marginRight:"50px"},customPath:"/custom/assets/images/brand/logo/",src:t,alt:e}),Object(c.jsx)("p",{dangerouslySetInnerHTML:{__html:r}})]})},d=t(143),o=t(13),b=t(34),l=t(3),j=t(25),p=t.n(j),u=t(1),h=t(144);e.default=function(a){var e,t=a.location.pathname.split("/").reverse(),j=Object(o.h)(),g=p.a.parse(j.search,{arrayFormat:"separator",arrayFormatSeparator:","}),m={brand:t[0]},O=Object(o.g)(),y=Object(b.b)(),f=Object(s.a)(y,2),F=f[0],x=f[1],T=Object(b.g)(),L=Object(s.a)(T,2),k=L[0],v=L[1],w=Object(l.d)((function(a){return a.configuration.filtering.productTypeBase})),D=g.key||w;return Object(u.useEffect)((function(){k.isFetching||k.isLoaded||v(Object(r.a)(Object(r.a)({},k),{},{isFetching:!0,isLoaded:!1,params:{urlTitle:D},makeRequest:!0})),F.isFetching||F.isLoaded||x(Object(r.a)(Object(r.a)({},F),{},{isFetching:!0,isLoaded:!1,entity:"brand",params:{"f:urlTitle":t[0]},makeRequest:!0}))}),[k,v,D,x,F,t]),!k.isFetching&&k.isLoaded&&0===Object.keys(k.data).length?Object(c.jsx)(o.a,{to:"/404"}):(O.listen((function(a){g=p.a.parse(a.search,{arrayFormat:"separator",arrayFormatSeparator:","}),v(Object(r.a)(Object(r.a)({},k),{},{data:{},isFetching:!0,isLoaded:!1,params:{urlTitle:g.key||w},makeRequest:!0}))})),Object(c.jsxs)(i.s,{children:[F.isLoaded&&F.data.length>0&&Object(c.jsx)(h.a,{title:F.data[0].settings.brandHTMLTitleString}),(null===(e=k.data.childProductTypes)||void 0===e?void 0:e.length)>0&&Object(c.jsx)(i.D,{data:k.data,onSelect:function(a){g.key=a,O.push("".concat(j.pathname,"?").concat(p.a.stringify(g,{arrayFormat:"comma"})))}}),k.data.showProducts&&Object(c.jsxs)(d.a,{preFilter:Object(r.a)(Object(r.a)({},m),{},{productType_id:k.data.productTypeID}),hide:["productType","brands"],children:[F.isLoaded&&F.data.length>0&&Object(c.jsx)(n,{brandName:F.data[0].brandName,imageFile:F.data[0].imageFile,brandDescription:F.data[0].brandDescription})," "]})]}))}}}]);
//# sourceMappingURL=10.0fe3860e.chunk.js.map