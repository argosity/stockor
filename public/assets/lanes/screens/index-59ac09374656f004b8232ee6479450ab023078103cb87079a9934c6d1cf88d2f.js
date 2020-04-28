!function(e,n,t,s,i,o,r,c){e.Screens.ChangeListener={modelEvents:{"remote-update":"onChange"},domEvents:{"show.bs.dropdown .changes-notification":"onChangesShow"},session:{change_count:["number",!0,0]},derived:{changes:{deps:[],fn:function(){return new e.Models.ChangeSetCollection([],{parent:this})}},changes_visible:{deps:["change_count"],fn:function(){return this.change_count>0}}},bindings:{changes_visible:{selector:".changes-notification",type:"toggle"},change_count:[{selector:".changes-notification .title span",type:"text"},{selector:".changes-notification .dropdown-toggle .badge",type:"text"}]},subviews:{changesDropDown:{hook:"changes-display",view:"Lanes.Views.ModelUpdate",collection:"changes"}},onChange:function(e,n){return this.changes.add(n),this.change_count+=1},bindModel:function(n){return e.Views.Base.prototype.bindModel.call(this,n),this.changes.reset([]),this.change_count=0},onChangesShow:function(e){return this.changes.invoke("updateTimeAgo"),this.$(".changes-notification .scroller").animate({scrollTop:0})}}}(window.Lanes,window.Lanes.Vendor.ld,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes,extension:{name:"Lanes",identifier:"lanes"},path:["lanes","screens","ChangeListener"]},window),function(e,n,t,s,i,o,r,c){var a,l,d,p,u,m,g=[].slice;u=function(){function n(){n.__super__.constructor.apply(this,arguments)}return n.prototype.FILE=o,n.prototype.session={props:"object",screen:"object",model:"state",active:"boolean",id:{type:"string",setOnce:!0,required:!0,"default":function(){return Math.random().toString(36).replace(/[^a-z]+/g,"").substr(0,3)}}},n.prototype.component=function(){return this.screen.getScreen()},n.prototype.title=function(){var e,n,t;return e=(null!=(n=this.model)&&"function"==typeof n.visibleIdentifier?n.visibleIdentifier():void 0)||"",e&&(e="::"+e),t=this.screen.title,t.length>12&&(t=t.slice(0,10)+"\u2026"),t+e},n.prototype.initialize=function(n){return this.props||(this.props={}),this.props.screen=this,e.Screens.Definitions.displaying.add(this)},n.prototype.remove=function(){return e.Screens.Definitions.displaying.remove(this)},n.prototype.historyUrl=function(){var e,n;return e=(null!=(n=this.model)&&"function"==typeof n.visibleIdentifier?n.visibleIdentifier():void 0)||"",{pathname:"/"+this.id+"/"+this.screen.id+"/"+e}},n}(),e.Models.BasicModel.extend(u),d=function(){function t(){t.__super__.constructor.apply(this,arguments)}return t.prototype.FILE=o,t.prototype.session={id:"string",title:"string",url_prefix:"string",description:"string",view:"string",icon:"string",group_id:"string",access:"string",loading:"boolean",extension:"string",model:"string",assets:"array",js:"string",css:"string"},t.prototype.derived={extension_ns:{deps:["extension"],fn:function(){return e[n.classify(this.extension)]}},model_type:{deps:["model"],fn:function(){return e.u.getPath(this.model)||e.u.findObject(this.model,"Models",{namespace:e[this.extension]})}},asset_paths:{deps:["assets"],fn:function(){var e;return e=this.url_prefix?this.url_prefix:this.extension.toLowerCase()+"/screens",this.assets.map(function(n){return e+"/"+n})}},extension_path:{deps:["extension","model"],fn:function(){return n.classify(this.extension)+".Screens."+this.view}},label:{deps:["id","title"],fn:function(){return this.title||n.field2title(this.id)}}},t.prototype.getScreen=function(){return e.u.getPath(this.extension_path)},t.prototype.ensureLoaded=function(){return this.getScreen()?n.Promise.resolve(this):this.loadScreen()},t.prototype.loadScreen=function(){var t;return t=this,new n.Promise(function(s,i){var o,r,c,a;return t.loading=!0,o=0,r=function(){var e;return t.loading=!1,e=t.getScreen(),e?s(t):3>o?(o+=1,n.delay(r,500)):i("Screen "+t.view+" not definied after file retrieval")},c=function(n){return e.warn(n),t.loading=!1,i(n)},(a=e.lib).RequestAssets.apply(a,t.asset_paths).then(r,c)})},t.prototype.display=function(e){return e=n.extend({},e,{screen:this}),this.ensureLoaded().then(function(){var n;return n=new u(e),n.active=!0,n})},t}(),e.Models.BasicModel.extend(d),m=function(){function t(){t.__super__.constructor.apply(this,arguments)}return t.prototype.FILE=o,t.prototype.model=u,t.prototype.active=function(){return this.findWhere({active:!0})},t.prototype.initialize=function(n,t){return null==t&&(t={}),e.current_user.on("change:isLoggedIn",function(n){return function(t){var s,i,o,r,c,a,l;if(t.isLoggedIn){for(r=(null!=(o=e.current_user.options)?o.initial_screens:void 0)||[],a=[],s=0,i=r.length;i>s;s++)l=r[s],a.push(null!=(c=e.Screens.Definitions.all.get(l))?c.display():void 0);return a}return n.reset()}}(this)),this.on("change:active add",this.onActiveChange)},t.prototype.remove=function(e){var s;return s=this.indexOf(e),t.__super__.remove.apply(this,arguments),e.active&&this.length&&(this.at(n.min([s,this.length-1])).active=!0),e.active=!1,this},t.prototype.onActiveChange=function(e,n){return e.active?this.each(function(n){return n!==e?n.set({active:!1}):void 0}):void 0},t.prototype.activateNext=function(){return this._moveActive(1)},t.prototype.activatePrev=function(){return this._moveActive(-1)},t.prototype._moveActive=function(e){var n;if(1!==this.length&&(n=this.findIndexWhere({active:!0}),-1!==n))return e>0&&n===this.length-1&&(n=-1),0>e&&0===n&&(n=this.length),this.at(n+e).active=!0},t.prototype.findInstance=function(e,n){return this.find(function(t){return t.screen.id===e&&t.id===n})},t}(),e.Models.BasicCollection.extend(m),p=function(){function n(){n.__super__.constructor.apply(this,arguments)}return n.prototype.FILE=o,n.prototype.model=d,n.prototype.register=e.emptyFn,n.prototype.addScreen=function(e){return e=this.add(e),e.set({active:!0})},n.prototype.isLoading=function(){return!!e.Screens.Definitions.all.findWhere({loading:!0})},n}(),e.Models.BasicCollection.extend(p),a=function(){function n(){n.__super__.constructor.apply(this,arguments),e.current_user.on("change:isLoggedIn",function(e){return function(){return delete e.cache}}(this))}return n.prototype.FILE=o,n.prototype.session={id:"string",title:"string",description:"string",icon:"string",active:["boolean",!0,!1]},n.prototype.screens=function(){return this.cache||(this.cache=new e.Models.SubCollection(e.Screens.Definitions.all,{filter:function(n){return function(t){return t.group_id===n.id&&(!t.model_type||e.current_user.hasAccess(t.access,t.model_type))}}(this),watched:["group_id"]}))},n}(),e.Models.BasicModel.extend(a),l=function(){function n(){n.__super__.constructor.apply(this,arguments),e.current_user.on("change:isLoggedIn",function(e){return function(){return delete e.cache}}(this))}return n.prototype.FILE=o,n.prototype.model=a,n.prototype.available=function(){return this.cache||(this.cache=new e.Models.SubCollection(this,{filter:function(e){return e.screens().filter(),e.screens().length>0}}))},n}(),e.Models.BasicCollection.extend(l),e.Screens.display_id=function(n){var t;return t=e.Screens.Definitions.all.get(n),t?t.display():e.warn("Unable to find definition for screen "+n)},e.Screens.Definitions={all:new p,displaying:new m([],{single_active_only:!0}),groups:new l,register:function(e){return this.all.add(e)},setBrowserLocation:function(e){var t,s,i,o,r,c;return o=n.compact(e.pathname.split("/")),i=o[0],c=o[1],t=3<=o.length?g.call(o,2):[],c?i&&(s=this.displaying.findInstance(c,i))?s.active=!0:null!=(r=this.all.get(c))?r.display({id:i,props:{args:t}}):void 0:void 0}}}(window.Lanes,window.Lanes.Vendor.ld,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes,extension:{name:"Lanes",identifier:"lanes"},path:["lanes","screens","Definitions"]},window),Lanes.Screens.Definitions.groups.add({id:"system-settings",title:"System Settings",description:"Modify system settings",icon:"wrench"}),Lanes.Screens.Definitions.groups.add({id:"accounting",title:"Accounting",description:"Accounting functions",icon:"line-chart"}),Lanes.Screens.Definitions.groups.add({id:"maint",title:"Maintenance",description:"Maintain records",icon:"pencil-square"}),Lanes.Screens.Definitions.groups.add({id:"customer",title:"Customer",description:"Customer records",icon:"heart"}),Lanes.Screens.Definitions.register({id:"user-preferences",title:"User Preferences",icon:"user-secret",model:"User",view:"UserPreferences",js:"",css:"",assets:[],access:"read",group_id:"system-settings",extension:"Lanes",url_prefix:"lanes/screens",description:"Modify User Profile"}),Lanes.Screens.Definitions.register({id:"system-settings",title:"System Settings",icon:"cogs",model:"User",view:"SystemSettings",js:"",css:"",assets:[],access:"read",group_id:"system-settings",extension:"Lanes",url_prefix:"lanes/screens",description:"Update System Settings"}),Lanes.Screens.Definitions.register({id:"user-management",title:"User Management",icon:"group",model:"User",view:"UserManagement",js:"user-management.js",css:"user-management.css",assets:["user-management.js","user-management.css"],access:"read",group_id:"system-settings",extension:"Access",url_prefix:"lanes/access/screens",description:"Add/Remove/Modify User Accounts"}),Lanes.Screens.Definitions.register({id:"locations",title:"Locations",icon:"globe",model:"Location",view:"Locations",js:"locations.js",css:null,assets:["locations.js"],access:"read",group_id:"system-settings",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"fresh-books-import",title:"Fresh Books Import",icon:"cloud-download",model:"Invoice",view:"FreshBooksImport",js:"fresh-books-import.js",css:"fresh-books-import.css",assets:["fresh-books-import.js","fresh-books-import.css"],access:"read",group_id:"system-settings",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"time-invoicing",title:"Time Invoicing",icon:"hourglass",model:"Invoice",view:"TimeInvoicing",js:"time-invoicing.js",css:"time-invoicing.css",assets:["time-invoicing.js","time-invoicing.css"],access:"write",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"payments",title:"Payments",icon:"file-text-o",model:"Payment",view:"Payments",js:"payments.js",css:null,assets:["payments.js"],access:"read",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"bank-maint",title:"Bank Maint",icon:"bank",model:"BankAccount",view:"BankMaint",js:"bank-maint.js",css:null,assets:["bank-maint.js"],access:"read",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"payment-terms",title:"Payment Terms",icon:"money",model:"PaymentTerm",view:"PaymentTerms",js:"payment-terms.js",css:"payment-terms.css",assets:["payment-terms.js","payment-terms.css"],access:"write",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"payment-category",title:"Payment Categories",icon:"object-group",model:"PaymentCategory",view:"PaymentCategory",js:"payment-category.js",css:"payment-category.css",assets:["payment-category.js","payment-category.css"],access:"read",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"chart-of-accounts",title:"Chart Of Accounts",icon:"list-alt",model:"GlTransaction",view:"ChartOfAccounts",js:"chart-of-accounts.js",css:"chart-of-accounts.css",assets:["chart-of-accounts.js","chart-of-accounts.css"],access:"read",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"gl-transactions",title:"Gl Transactions",icon:"balance-scale",model:"GlTransaction",view:"GlTransactions",js:"gl-transactions.js",css:"gl-transactions.css",assets:["gl-transactions.js","gl-transactions.css"],access:"read",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"customer-projects",title:"Customer Projects",icon:"briefcase",model:"Invoice",view:"CustomerProjects",js:"customer-projects.js",css:"customer-projects.css",assets:["customer-projects.js","customer-projects.css"],access:"write",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"gl-accounts",title:"Gl Accounts",icon:"archive",model:"GlAccount",view:"GlAccounts",js:"gl-accounts.js",css:null,assets:["gl-accounts.js"],access:"write",group_id:"accounting",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"sku-maint",title:"SKU Maintenance",icon:"archive",model:"Sku",view:"SkuMaint",js:"sku-maint.js",css:"sku-maint.css",assets:["sku-maint.js","sku-maint.css"],access:"read",group_id:"maint",extension:"Skr",url_prefix:"skr/screens",description:null}),Lanes.Screens.Definitions.register({id:"customer-maint",title:"Customer Maintenance",icon:"heartbeat",model:"Customer",view:"CustomerMaint",js:"customer-maint.js",css:null,assets:["customer-maint.js"],access:"read",group_id:"maint",extension:"Skr",url_prefix:"skr/screens",description:null}),Lanes.Screens.Definitions.register({id:"vendor-maint",title:"Vendor Maintenance",icon:"truck",model:"Vendor",view:"VendorMaint",js:"vendor-maint.js",css:null,assets:["vendor-maint.js"],access:"read",group_id:"maint",extension:"Skr",url_prefix:"skr/screens",description:null}),Lanes.Screens.Definitions.register({id:"sales-order",title:"Sales Order",icon:"shopping-cart",model:"SalesOrder",view:"SalesOrder",js:"sales-order.js",css:null,assets:["sales-order.js"],access:"read",group_id:"customer",extension:"Skr",url_prefix:"skr/screens",description:""}),Lanes.Screens.Definitions.register({id:"invoice",title:"Invoice",icon:"money",model:"Invoice",view:"Invoice",js:"invoice.js",css:null,assets:["invoice.js"],access:"read",group_id:"customer",extension:"Skr",url_prefix:"skr/screens",description:"Invoices"}),Lanes.Screens.Definitions.register({id:"time-tracking",title:"Time Tracking",icon:"hourglass-start",model:"TimeEntry",view:"TimeTracking",js:"time-tracking.js",css:"time-tracking.css",assets:["time-tracking.js","time-tracking.css"],access:"read",group_id:"customer",extension:"Skr",url_prefix:"skr/screens",description:""}),function(e,n,t,s,i,o,r,c){e.Screens.Commands=function(){function e(e,t){this.screen=e,this.options=null!=t?t:{},n.defaults(this.options,{modelName:"model"}),n.bindAll(this,n.functionsIn(this))}return e.prototype.FILE=o,e.prototype.resetModel=function(){var e;return e=this.getModel(),void this.setModel(new e.constructor)},e.prototype.getModel=function(){return this.screen[this.options.modelName]},e.prototype.setModel=function(e){var n,t,s,i;return"function"==typeof(n=this.options).modelWillRebind&&n.modelWillRebind(e),this.screen.data.rebind((i={},i[""+this.options.modelName]=e,i)),"function"==typeof(t=this.screen).setModelUrl&&t.setModelUrl(e),"function"==typeof(s=this.options).modelDidRebind?s.modelDidRebind(e):void 0},e.prototype.canEditModel=function(){var e;return"function"==typeof(e=this.screen).hasWriteAccess?e.hasWriteAccess():void 0},e.prototype.getSyncOptions=function(){return n.result(this.screen,"syncOptions")||{}},e.prototype.saveModel=function(){return this.getModel().save(this.getSyncOptions())},e.prototype.toggleEdit=function(){return this.screen.setState({isEditing:!this.isEditing()})},e.prototype.isEditing=function(){return!!this.screen.state.isEditing},e}(),e.Models.State.extend(e.Screens.Commands)}(window.Lanes,window.Lanes.Vendor.ld,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes,extension:{name:"Lanes",identifier:"lanes"},path:["lanes","screens","Commands"]},window),function(e,n,t,s,i,o,r,c){e.Screens.CommonComponents=function(){function n(){}return n.prototype.displayName="Lanes.Screens.CommonComponents",n.prototype.FILE=o,n.prototype.propTypes={commands:s.PropTypes.instanceOf(e.Screens.Commands).isRequired,errors:s.PropTypes.bool,networkActivity:s.PropTypes.bool,toolbarProps:s.PropTypes.object},n.prototype.render=function(){var e;return e=this.props.commands.getModel(),s.createElement("div",null,this.networkActivity!==!1?s.createElement(t.NetworkActivityOverlay,Object.assign({model:e},this.props)):void 0,s.createElement(t.Toolbar,Object.assign({},this.props,this.props.toolbarProps),this.props.children),this.errors!==!1?s.createElement(t.ErrorDisplay,Object.assign({model:e},this.props)):void 0)},n}(),e.Screens.CommonComponents=e.React.Component.extend(e.Screens.CommonComponents)}(window.Lanes,window.Lanes.Vendor.ld,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes,extension:{name:"Lanes",identifier:"lanes"},path:["lanes","screens","CommonComponents"]},window),function(e,n,t,s,i,o,r,c){e.Screens.UserPreferences=function(){function r(){}return r.prototype.displayName="Lanes.Screens.UserPreferences",r.prototype.FILE=o,r.prototype.dataObjects={user:function(){return e.current_user}},r.prototype.getInitialState=function(){return{isEditing:!0,commands:new e.Screens.Commands(this,{modelName:"user"})}},r.prototype.setScreens=function(e){return this.user.options=n.extend({},this.user.options,{initial_screens:n.map(e,"id")})},r.prototype.getScreens=function(){var t;return n.map((null!=(t=this.user.options)?t.initial_screens:void 0)||[],function(n){var t;return t=e.Screens.Definitions.all.get(n),{id:n,label:t.label}})},r.prototype.render=function(){var n,o;return s.createElement(t.ScreenWrapper,{identifier:"user-preferences"},s.createElement(e.Screens.CommonComponents,{commands:this.state.commands}),s.createElement(i.Row,null,s.createElement(t.SelectField,{xs:12,multiSelect:!0,fetchWhenOpen:!1,label:"Initial Screens",labelField:"label",name:"options",model:this.user,choices:e.Screens.Definitions.all.models,queryModel:e.Screens.Definitions.all,setSelection:this.setScreens,getSelection:this.getScreens})),function(){var t,s;t=e.Extensions.instances,s=[];for(o in t)n=t[o],n.getPreferenceElement&&s.push(n.getPreferenceElement({key:o}));return s}())},r}(),e.Screens.UserPreferences=e.React.Screen.extend(e.Screens.UserPreferences)}(window.Lanes,window.Lanes.Vendor.ld,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes,extension:{name:"Lanes",identifier:"lanes"},path:["lanes","screens","UserPreferences"]},window),function(e,n,t,s,i,o,r,c){e.Screens.SystemSettings=function(){function r(){}return r.prototype.displayName="Lanes.Screens.SystemSettings",r.prototype.FILE=o,r.prototype.dataObjects={config:function(){return e.config.system_settings}},r.prototype.getInitialState=function(){return{isEditing:!0,commands:new e.Screens.Commands(this,{modelName:"config"})}},r.prototype.onChange=function(e,n){return this.config.settings.lanes[e]=n.target?n.target.value:n,this.forceUpdate()},r.prototype.renderFileOptions=function(){var e;return e=this.config.settings.lanes.storage_dir,s.createElement(t.FieldWrapper,Object.assign({model:this.config,displayComponent:s.createElement("span",null),label:"Store Directory",sm:9},this.props,{value:e}),s.createElement("input",{type:"text",className:"value form-control",placeholder:"Directory to store files",value:e,onChange:n.partial(this.onChange,"storage_dir")}))},r.prototype.renderFogOptions=function(){var e;return e=JSON.stringify(this.config.settings.lanes.fog_credentials,null,2),s.createElement(t.FieldWrapper,Object.assign({label:"Fog Options",sm:9},this.props,{value:e}),s.createElement(i.Input,{type:"textarea",placeholder:"FOG options (as JSON)",value:e,onChange:n.partial(this.onChange,"fog_credentials")}))},r.prototype.saveConfig=function(){var e,n,t,s,i;t=this.refs;for(n in t)e=t[n],"function"==typeof e.onBeforeSave&&e.onBeforeSave();this.config.save({saveAll:!0}),s=this.refs,i=[];for(n in s)e=s[n],i.push("function"==typeof e.onSave?e.onSave():void 0);return i},r.prototype.render=function(){var o,r,c,a,l;return r=["file","fog"],l=(null!=(a=this.config.settings.lanes)?a.storage:void 0)||"file",s.createElement(t.ScreenWrapper,{identifier:"user-preferences"},s.createElement(i.Nav,{bsStyle:"pills",className:"lanes-toolbar"},s.createElement(i.Button,{navItem:!0,componentClass:"button",onClick:this.saveConfig,className:"save navbar-btn control"},s.createElement(t.Icon,{type:"cloud-upload"}),"Save")),s.createElement(i.Row,null,s.createElement(t.FieldWrapper,Object.assign({model:this.config,displayComponent:s.createElement("span",null),label:"File Storage",sm:3},this.props,{value:l}),s.createElement(e.Vendor.ReactWidgets.DropdownList,{data:r,value:l,onChange:n.partial(this.onChange,"storage")})),"file"===l?this.renderFileOptions():this.renderFogOptions()),s.createElement(i.Row,null,s.createElement(t.ImageSaver,{label:"Logo",sm:4,model:this.config,name:"logo",size:"thumb"})),function(){var n,t;n=e.Extensions.instances,t=[];for(c in n)o=n[c],o.getSettingsElement&&t.push(o.getSettingsElement({ref:c,key:c,settings:this.config.settings[c]}));return t}.call(this))},r}(),e.Screens.SystemSettings=e.React.Screen.extend(e.Screens.SystemSettings)}(window.Lanes,window.Lanes.Vendor.ld,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes,extension:{name:"Lanes",identifier:"lanes"},path:["lanes","screens","SystemSettings"]},window);