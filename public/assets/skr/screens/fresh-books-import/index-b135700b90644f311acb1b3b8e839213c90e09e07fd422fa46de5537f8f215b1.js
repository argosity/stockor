!function(e,t,o,r,n,s,i,l,a,c){t.Screens.FreshBooksImport=function(){function e(){}return e.prototype.displayName="Skr.Screens.FreshBooksImport",e.prototype.FILE=l,e.prototype.modelForAccess="invoice",e.prototype.getInitialState=function(){return{isEditing:!0}},e.prototype.modelBindings={"import":function(){return new t.Screens.FreshBooksImport.Import}},e.prototype.JobStatus=function(){var e;return this["import"].job.isExecuting?(e="complete"===this["import"].stage?"Importing records from Fresh Books":"Loading record summaries from Fresh Books",s.createElement(n.JobStatus,{job:this["import"].job,onlyExecuting:!0,message:e})):null},e.prototype.render=function(){return s.createElement(n.ScreenWrapper,{identifier:"fresh-books-import"},s.createElement(n.ErrorDisplay,{model:this["import"]}),s.createElement(t.Screens.FreshBooksImport.ApiInfo,{"import":this["import"]}),s.createElement(this.JobStatus,null),s.createElement(t.Screens.FreshBooksImport.ChooseRecords,{"import":this["import"]}),s.createElement(t.Screens.FreshBooksImport.ViewRecords,{"import":this["import"]}))},e}(),t.Screens.FreshBooksImport=t.Screens.Base.extend(t.Screens.FreshBooksImport)}(window.Lanes=window.Lanes||{},window.Lanes?window.Lanes.Skr:null,(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","fresh-books-import","FreshBooksImport"]},window),function(e,t,o,r,n,s,i,l,a,c){t.Screens.FreshBooksImport.Import=function(){function e(){e.__super__.constructor.apply(this,arguments)}return e.prototype.FILE=l,e.prototype.modelTypeIdentifier=function(){return"fresh-books-import"},e.prototype.props={domain:"string",api_key:"string",stage:{type:"string","default":"fetch"},ignored_ids:"object",user_mappings:"object",customer_codes:"object"},e.prototype.associations={job:{model:"Lanes.Models.JobStatus"}},e.prototype.hasPendingRecords=function(){var e;return"fetch"===this.stage&&this.hasRecords()&&!(null!=(e=this.job)?e.isActive:void 0)},e.prototype.hasImportedRecords=function(){var e;return"complete"===this.stage&&this.hasRecords()&&!(null!=(e=this.job)?e.isActive:void 0)},e.prototype.hasRecords=function(){var e;return!o.isEmpty(null!=(e=this.job.data)?e.output:void 0)},e.prototype.recordTypes=["clients","projects","invoices","time_entries","staff"],e.prototype.recordsForType=function(e){return this.job.data.output[e]||[]},e.prototype.isComplete=function(){return"complete"===this.stage},e.prototype.complete=function(){var e,t,r,n,s,i,l,a,c,p,d,m,u,h,w,f,y;for(this.ignored_ids={},m=this.recordTypes,e=0,l=m.length;l>e;e++)for(y=m[e],this.ignored_ids[y]=r=[],t=o.singularize(y)+"_id",u=this.recordsForType(y),n=0,a=u.length;a>n;n++)d=u[n],d.selected===!1&&r.push(d[t]);for(this.user_mappings={},h=this.recordsForType("staff"),s=0,c=h.length;c>s;s++)f=h[s],f.mapped_user_id&&(this.user_mappings[f.staff_id]=f.mapped_user_id);for(this.customer_codes={},w=this.recordsForType("clients"),i=0,p=w.length;p>i;i++)f=w[i],f.customer_code&&(this.customer_codes[f.client_id]=f.customer_code);return this.stage="complete",this.save({excludeAssociations:!0})},e}(),t.Models.Base.extend(t.Screens.FreshBooksImport.Import)}(window.Lanes=window.Lanes||{},window.Lanes?window.Lanes.Skr:null,(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","fresh-books-import","Import"]},window),function(e,t,o,r,n,s,i,l,a,c){t.Screens.FreshBooksImport.ApiInfo=function(){function e(){}return e.prototype.displayName="Skr.Screens.FreshBooksImport.ApiInfo",e.prototype.FILE=l,e.prototype.listenNetworkEvents=!0,e.prototype.modelBindings={"import":"props"},e.prototype.startImport=function(){return this["import"].save()},e.prototype.render=function(){return this["import"].isComplete()||this["import"].job.isSubmitted?null:s.createElement("div",{className:"api-info"},s.createElement(n.NetworkActivityOverlay,{model:this["import"]}),s.createElement(i.Row,null,s.createElement(i.Col,{sm:12},s.createElement("h3",null,"Freshbooks Account Information"),s.createElement("p",null,"The importer will download a summary of all Clients,\nProjects, Invoices, and time entries from Fresh Books\nand allow you to choose which ones to import."),s.createElement("p",null,"Your access information will not be stored and is only used to download records"))),s.createElement(i.Row,{className:"api-info"},s.createElement(n.Input,{name:"api_key",label:"API Key",sm:7,model:this["import"]}),s.createElement(n.Input,{name:"domain",label:"Company",sm:3,model:this["import"]}),s.createElement(i.Col,{sm:2,className:"domain"},".freshbooks.com")),s.createElement(i.Row,null,s.createElement(i.Col,{smOffset:9,sm:2},s.createElement(i.Button,{bsStyle:"primary",bsSize:"large",onClick:this.startImport},"Start Import"))))},e}(),t.Screens.FreshBooksImport.ApiInfo=e.React.Component.extend(t.Screens.FreshBooksImport.ApiInfo)}(window.Lanes=window.Lanes||{},window.Lanes?window.Lanes.Skr:null,(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","fresh-books-import","ApiInfo"]},window),function(e,t,o,r,n,s,i,l,a,c){var p,d,m,u,h;u=new e.Models.User.Collection,u.ensureLoaded(),p=["selected","mapped_user_id","customer_code"],m=function(){function e(){}return e.prototype.displayName="TextInput",e.prototype.FILE=l,e.prototype.setCode=function(e){return this.props.row.customer_code=e.target.value.toUpperCase(),this.forceUpdate()},e.prototype.render=function(){return s.createElement("input",{value:this.props.row.customer_code||"",onChange:this.setCode})},e}(),m=e.React.Component.extend(m),h=function(){function t(){}return t.prototype.displayName="UserSelect",t.prototype.FILE=l,t.prototype.modelBindings={user:function(){return new e.Models.User}},t.prototype.getUser=function(){return this.props.row.mapped_user_id?u.get(this.props.row.mapped_user_id):null},t.prototype.setUser=function(e){return this.props.row.mapped_user_id=e.id,this.forceUpdate()},t.prototype.render=function(){return s.createElement(n.SelectField,{editOnly:!0,unlabeled:!0,model:this.user,name:"user",labelField:"login",queryModel:e.Models.User,getSelection:this.getUser,setSelection:this.setUser,choices:u.models})},t}(),h=e.React.Component.extend(h),d=function(){function e(){}return e.prototype.displayName="RecordRow",e.prototype.FILE=l,e.prototype.isChecked=function(){return null==this.props.row.selected||this.props.row.selected},e.prototype.onChange=function(e){return this.props.row.selected=e.target.checked,this.forceUpdate()},e.prototype.onRowClick=function(e){return"INPUT"!==e.target.tagName?(this.props.row.selected=null!=this.props.row.selected?!this.props.row.selected:!1,this.forceUpdate()):void 0},e.prototype.render=function(){var e,t,r;return s.createElement("tr",{onClick:this.onRowClick},s.createElement("td",null,s.createElement("input",{type:"checkbox",onChange:this.onChange,checked:this.isChecked()})),function(){var e,n;e=o.omit(this.props.row,p),n=[];for(t in e)r=e[t],n.push(s.createElement("td",{key:t},r));return n}.call(this),function(){var t,o,r,n;for(r=this.props.xtra||[],n=[],t=0,o=r.length;o>t;t++)e=r[t],n.push(s.createElement("td",{key:e.label},s.createElement(e.control,{row:this.props.row})));return n}.call(this))},e}(),d=e.React.BaseComponent.extend(d),t.Screens.FreshBooksImport.ChooseRecords=function(){function e(){}return e.prototype.displayName="Skr.Screens.FreshBooksImport.ChooseRecords",e.prototype.FILE=l,e.prototype.listenNetworkEvents=!0,e.prototype.modelBindings={"import":"props",job:function(){return this.props["import"].job}},e.prototype.RecordTable=function(e){var t,r,n,l,a,c,u;return a=this["import"].recordsForType(e.type),l=o.without(o.keys(o.first(a)),p),u=[],"staff"===e.type&&u.push({label:"Reassign To",control:h}),"clients"===e.type&&u.push({label:"Customer Code",control:m}),s.createElement(i.Table,{responsive:!0,striped:!0,bordered:!0,condensed:!0,hover:!0,className:e.type},s.createElement("thead",null,s.createElement("tr",null,s.createElement("th",null,"Select"),function(){var e,t,i;for(i=[],r=e=0,t=l.length;t>e;r=++e)n=l[r],i.push(s.createElement("th",{key:r},o.titleize(o.humanize(n))));return i}(),function(){var e,o,r;for(r=[],e=0,o=u.length;o>e;e++)t=u[e],r.push(s.createElement("th",{key:t.label},t.label));return r}())),s.createElement("tbody",null,function(){var e,t,o;for(o=[],r=e=0,t=a.length;t>e;r=++e)c=a[r],o.push(s.createElement(d,{key:r,row:c,xtra:u}));return o}()))},e.prototype.startImport=function(){return this["import"].complete()},e.prototype.renderHeader=function(){var e;return e=this["import"].job.isExecuting?void 0:s.createElement(i.Button,{bsStyle:"primary",bsSize:"large",onClick:this.startImport},"Start Import"),s.createElement("div",{className:"header"},s.createElement("h3",null,"Select Records for Import"),e)},e.prototype.render=function(){var e,t;return this["import"].hasPendingRecords()?s.createElement("div",{className:"import-records"},this.renderHeader(),s.createElement(i.Tabs,{id:"choose-records"},function(){var r,n,l,a;for(l=this["import"].recordTypes,a=[],e=r=0,n=l.length;n>r;e=++r)t=l[e],this["import"].recordsForType(t)&&a.push(s.createElement(i.Tab,{eventKey:e,key:e,title:o.titleize(t),animation:!1},s.createElement(this.RecordTable,{type:t})));return a}.call(this))):null},e}(),t.Screens.FreshBooksImport.ChooseRecords=e.React.Component.extend(t.Screens.FreshBooksImport.ChooseRecords)}(window.Lanes=window.Lanes||{},window.Lanes?window.Lanes.Skr:null,(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","fresh-books-import","ChooseRecords"]},window),function(e,t,o,r,n,s,i,l,a,c){t.Screens.FreshBooksImport.ViewRecords=function(){function e(){}return e.prototype.displayName="Skr.Screens.FreshBooksImport.ViewRecords",e.prototype.FILE=l,e.prototype.listenNetworkEvents=!0,e.prototype.modelBindings={"import":"props",job:function(){return this.props["import"].job}},e.prototype.getCustomer=function(e){return o.find(this["import"].recordsForType("clients"),function(t){return t.id===e})},e.prototype.Staff=function(e){var t,o;return s.createElement(i.Table,{responsive:!0,striped:!0,bordered:!0,condensed:!0,hover:!0},s.createElement("thead",null,s.createElement("tr",null,s.createElement("th",null,"Login"),s.createElement("th",null,"Name"),s.createElement("th",null,"Email"))),s.createElement("tbody",null,function(){var r,n,i,l;for(i=e.records,l=[],t=r=0,n=i.length;n>r;t=++r)o=i[t],l.push(s.createElement("tr",{key:t},s.createElement("td",null,o.login),s.createElement("td",null,o.name),s.createElement("td",null,o.email)));return l}()))},e.prototype.Clients=function(e){var o,n,l;return s.createElement(i.Table,{responsive:!0,striped:!0,bordered:!0,condensed:!0,hover:!0},s.createElement("thead",null,s.createElement("tr",null,s.createElement("th",null,"Code"),s.createElement("th",null,"Name"),s.createElement("th",null,"Notes"))),s.createElement("tbody",null,function(){var i,a,c,p;for(c=e.records,p=[],n=i=0,a=c.length;a>i;n=++i)l=c[n],o=new t.Models.Customer(l),p.push(s.createElement("tr",{key:n},s.createElement("td",null,s.createElement(r.CustomerLink,{customer:o})),s.createElement("td",null,l.name),s.createElement("td",null,l.notes)));return p}()))},e.prototype.Projects=function(e){var t,o;return s.createElement(i.Table,{responsive:!0,striped:!0,bordered:!0,condensed:!0,hover:!0},s.createElement("thead",null,s.createElement("tr",null,s.createElement("th",null,"Code"),s.createElement("th",null,"Description"),s.createElement("th",null,"Customer"))),s.createElement("tbody",null,function(){var r,n,i,l,a;for(i=e.records,a=[],t=r=0,n=i.length;n>r;t=++r)o=i[t],a.push(s.createElement("tr",{key:t},s.createElement("td",null,o.code),s.createElement("td",null,o.description),s.createElement("td",null,null!=(l=this.getCustomer(o.customer_id))?l.code:void 0)));return a}.call(this)))},e.prototype.Invoices=function(e){var o,n,l;return s.createElement(i.Table,{responsive:!0,striped:!0,bordered:!0,condensed:!0,hover:!0},s.createElement("thead",null,s.createElement("tr",null,s.createElement("th",null,"ID"),s.createElement("th",null,"Customer"),s.createElement("th",null,"Date"),s.createElement("th",null,"Notes"))),s.createElement("tbody",null,function(){var i,a,c,p,d;for(c=e.records,d=[],o=i=0,a=c.length;a>i;o=++i)l=c[o],n=new t.Models.Invoice(l),d.push(s.createElement("tr",{key:o},s.createElement("td",null,s.createElement(r.InvoiceLink,{invoice:n})),s.createElement("td",null,null!=(p=this.getCustomer(l.customer_id))?p.code:void 0),s.createElement("td",null,l.invoice_date),s.createElement("td",null,l.notes)));return d}.call(this)))},e.prototype.Time_entries=function(e){var t,o;return s.createElement(i.Table,{responsive:!0,striped:!0,bordered:!0,condensed:!0,hover:!0},s.createElement("thead",null,s.createElement("tr",null,s.createElement("th",null,"Start At"),s.createElement("th",null,"End At"),s.createElement("th",null,"Description"))),s.createElement("tbody",null,function(){var r,n,i,l;for(i=e.records,l=[],t=r=0,n=i.length;n>r;t=++r)o=i[t],l.push(s.createElement("tr",{key:t},s.createElement("td",null,o.start_at),s.createElement("td",null,o.end_at),s.createElement("td",null,o.description)));return l}()))},e.prototype.BlankTable=function(e){return s.createElement("span",null)},e.prototype.render=function(){var e,t,r;return this["import"].hasImportedRecords()?(s.createElement("h3",null,"Import Success!"),s.createElement(i.Tabs,{id:"view-records"},function(){var n,l,a,c;for(a=this["import"].recordTypes,c=[],t=n=0,l=a.length;l>n;t=++n)r=a[t],e=this[o.capitalize(r)]||this.BlankTable,c.push(s.createElement(i.Tab,{eventKey:t,key:t,title:o.titleize(r),animation:!1},s.createElement(e,{type:r,records:this["import"].recordsForType(r)})));return c}.call(this))):null},e}(),t.Screens.FreshBooksImport.ViewRecords=e.React.Component.extend(t.Screens.FreshBooksImport.ViewRecords)}(window.Lanes=window.Lanes||{},window.Lanes?window.Lanes.Skr:null,(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","fresh-books-import","ViewRecords"]},window);