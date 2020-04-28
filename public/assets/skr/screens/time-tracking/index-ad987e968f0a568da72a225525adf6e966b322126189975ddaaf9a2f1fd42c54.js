!function(e,t,n,r,i,o,s,a,c,p){t.Screens.TimeTracking=function(){function e(){}return e.prototype.displayName="Skr.Screens.TimeTracking",e.prototype.FILE=a,e.prototype.dataObjects={entries:function(){return new t.Screens.TimeTracking.Entries}},e.prototype.onDayClick=function(e,t){return this.showPopup(e,t)},e.prototype.showPopup=function(e,t,r){var i;return null==r&&(r=!1),i=n.dom(this).el.getBoundingClientRect(),this.entries.editing={event:r,date:t,bounds:i,position:{x:e.clientX-i.left,y:e.clientY-i.top}}},e.prototype.onEventClick=function(e,t){return this.showPopup(e,t.start(),t)},e.prototype.stopEdit=function(){return this.entries.editing=!1},e.prototype.onEventResize=function(e,t){var n;return n=t.get("entry"),n.fromCalEvent(t),n.isNew()?void 0:n.save()},e.prototype.renderSummaryDays=function(){var e,n,r;if(!this.entries.isMonth)return null;for(n=[],r=e=1;5>=e;r=++e)n.push(o.createElement(t.Screens.TimeTracking.WeekSummary,{key:r,week:r,entries:this.entries}));return n},e.prototype.renderTotals=function(){return this.entries.isMonth?o.createElement("div",{className:"monthly-totals"},this.entries.totalHours().toFixed(2)):null},e.prototype.render=function(){return o.createElement(i.ScreenWrapper,{identifier:"time-tracking",flexVertical:!0},o.createElement(t.Screens.TimeTracking.Popover,o.__spread({entries:this.entries},this.entries.editing)),o.createElement(i.NetworkActivityOverlay,{visible:this.entries.isLoading,model:this.entries}),o.createElement(t.Screens.TimeTracking.Header,{entries:this.entries}),o.createElement(s.Row,{className:"calendar-panel"},this.renderTotals(),o.createElement(i.Calendar,{ref:"calendar",onDayClick:this.onDayClick,onEventResize:this.onEventResize,onEventClick:this.onEventClick,date:this.entries.date,events:this.entries.calEvents(),display:this.entries.display},this.renderSummaryDays())))},e}(),t.Screens.TimeTracking=t.Screens.Base.extend(t.Screens.TimeTracking)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","time-tracking","TimeTracking"]},window),function(e,t,n,r,i,o,s,a,c,p){t.Screens.TimeTracking.MiniControls=function(){function e(){}return e.prototype.displayName="Skr.Screens.TimeTracking.MiniControls",e.prototype.FILE=a,e.prototype.onEditEvent=function(){return this.props.onEditEvent(this.props.event)},e.prototype.EditButton=function(){return this.props.event?o.createElement(s.Button,{onClick:this.onEditEvent,title:"Edit Time Entry"},o.createElement(i.Icon,{type:"pencil-square-o","2x":!0,flush:!0})):null},e.prototype.render=function(){return o.createElement("div",{className:"mini-controls"},o.createElement("div",{className:"l"},o.createElement("span",null,this.props.date.format("MMM")),o.createElement("span",null,this.props.date.format("Do"))),o.createElement(s.Button,{onClick:this.props.onCancel,title:"Hide Controls"},o.createElement(i.Icon,{type:"ban","2x":!0,flush:!0})),o.createElement(this.EditButton,null),o.createElement(s.Button,{onClick:this.props.onAddEntry,title:"Create Time Entry"},o.createElement(i.Icon,{type:"plus-square","2x":!0,flush:!0})))},e}(),t.Screens.TimeTracking.MiniControls=e.React.Component.extend(t.Screens.TimeTracking.MiniControls)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","time-tracking","PopoverMiniControls"]},window),function(e,t,n,r,i,o,s,a,c,p){t.Screens.TimeTracking.EditEntry=function(){function e(){}return e.prototype.displayName="Skr.Screens.TimeTracking.EditEntry",e.prototype.FILE=a,e.prototype.dataObjects={entry:function(){var e;return null!=(e=this.props.event)?e.get("entry"):void 0}},e.prototype.setDataState=function(e){return e.event&&(this.entry.fromCalEvent(e.event),e.event.set({content:this.entry.content},{silent:!0})),this.forceUpdate()},e.prototype.getTarget=function(){return this.props.wrapper.isMounted()?n.dom(this.props.wrapper).el:null},e.prototype.onSave=function(){var e;return e=this.props.event,this.entry.save().then(function(t){return function(r){return e.set(n.extend({editing:!1},r.toCalEvent())),r.errors?void 0:t.props.onCancel()}}(this))},e.prototype.componentDidMount=function(){return n.defer(function(e){return function(){return n.dom(e).qs("input[name=hours]").focusAndSelect()}}(this))},e.prototype.render=function(){var e;return e={sm:12,editOnly:!0,model:this.entry},o.createElement("div",{className:"entry-body"},o.createElement(i.NetworkActivityOverlay,{model:this.entry,roundedCorners:!0}),o.createElement(s.Row,null,o.createElement(i.SelectField,o.__spread({},e,{sm:8,choices:this.props.entries.available_projects.models,name:"customer_project",labelField:"code"})),o.createElement(i.NumberInput,o.__spread({},e,{sm:4,name:"hours",step:.25,onEnter:this.onSave}))),o.createElement(s.Row,null,o.createElement(i.DateTime,o.__spread({},e,{step:15,name:"start_at"}))),o.createElement(s.Row,null,o.createElement(i.DateTime,o.__spread({},e,{step:15,name:"end_at"}))),o.createElement(s.Row,null,o.createElement(i.Input,{sm:12,model:this.entry,ref:"textarea",onEnter:this.onSave,selectOnFocus:!0,editOnly:!0,name:"description",type:"textarea",label:"Description"})),o.createElement(s.Row,{className:"controls"},o.createElement(s.Button,{tabIndex:-1,onClick:this.props.onCancel},"Cancel"),o.createElement(s.Button,{onClick:this.onSave,bsStyle:"primary"},"Save")))},e}(),t.Screens.TimeTracking.EditEntry=e.React.Component.extend(t.Screens.TimeTracking.EditEntry)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","time-tracking","EditEntry"]},window),function(e,t,n,r,i,o,s,a,c,p){t.Screens.TimeTracking.Popover=function(){function e(){}return e.prototype.displayName="Skr.Screens.TimeTracking.Popover",e.prototype.FILE=a,e.prototype.componentWillReceiveProps=function(e){return this.state.editing&&e.editing===!1?this.onCancel():this.setState({isCanceled:!1})},e.prototype.onCancel=function(){var e;return(null!=(e=this.state.editing)?e.get("entry").isNew():void 0)&&this.state.editing.remove(),this.props.entries.stopEditing(),this.setState({isCanceled:!0,editing:null})},e.prototype.onAddEntry=function(){var e;return e=this.props.entries.addEvent(this.props.date),this.setState({editing:e})},e.prototype.onEditEvent=function(e){return this.setState({editing:e})},e.prototype.EditEntry=function(){return this.state.editing?o.createElement(t.Screens.TimeTracking.EditEntry,{event:this.state.editing,entries:this.props.entries,date:this.props.date,onCancel:this.onCancel}):null},e.prototype.MiniControls=function(){return this.state.editing?null:o.createElement(t.Screens.TimeTracking.MiniControls,{date:this.props.date,event:this.props.event,onCancel:this.onCancel,onAddEntry:this.onAddEntry,onEditEvent:this.onEditEvent})},e.prototype.render=function(){var e,t,r,i,a,c,p,d;return this.state.isCanceled||!this.props.date?null:(e=n.classnames("edit-control","in"),i=this.props.position,p=i.x,d=i.y,a=this.state.editing?[320,400]:[175,60],c=a[0],t=a[1],this.props.event&&!this.state.editing&&(c+=60),r=p>this.props.bounds.width/2?"left":"right","left"===r&&(p-=c),o.createElement(s.Popover,{className:e,style:{width:c,height:t},id:"edit-controls",placement:r,positionLeft:p,positionTop:d-t/2},o.createElement(this.MiniControls,null),o.createElement(this.EditEntry,null)))},e}(),t.Screens.TimeTracking.Popover=e.React.Component.extend(t.Screens.TimeTracking.Popover)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","time-tracking","Popover"]},window),function(e,t,n,r,i,o,s,a,c,p){t.Screens.TimeTracking.WeekSummary=function(){function t(){}return t.prototype.displayName="Skr.Screens.TimeTracking.WeekSummary",t.prototype.FILE=a,t.prototype.color=function(e){var t,n;return t=this.props.entries.available_projects.get(e),(null!=t&&null!=(n=t.options)?n.color:void 0)||0},t.prototype.render=function(){var t,n,r,i;return t=7*this.props.week-1,i=this.props.entries.totalsForWeek(this.props.week),o.createElement("div",{className:"day summary",style:{order:t}},function(){var t;t=[];for(n in i)r=i[n],t.push(o.createElement("div",{key:n,className:"color-"+this.color(n)},e.u.format.currency(r)));return t}.call(this))},t}(),t.Screens.TimeTracking.WeekSummary=e.React.BaseComponent.extend(t.Screens.TimeTracking.WeekSummary)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","time-tracking","WeekSummary"]},window),function(e,t,n,r,i,o,s,a,c,p){var d;d=function(){function e(t){this.projects=t,e.__super__.constructor.call(this)}return e.prototype.FILE=a,e.prototype.projectForEntry=function(e){return this.projects.get(e.customer_project_id)},e.prototype.loadEntries=function(e,t){return null==t&&(t={}),t.end_at={op:"gt",value:e.start.toISOString()},t.start_at={op:"lt",value:e.end.toISOString()},this.fetch({query:t,reset:!0})},e.prototype.resetEntries=function(e,t){var n;return this.projectId=e,n=this.projectId&&-1!==this.projectId?{customer_project_id:this.projectId}:{},this.loadEntries(t,n)},e}(),t.Models.TimeEntry.Collection.extend(d),t.Screens.TimeTracking.Entries=function(){function r(){r.__super__.constructor.apply(this,arguments),this.available_projects=new t.Models.CustomerProject.Collection,this.listenTo(this.available_projects,"sync",this.onProjectsRequest),this.available_projects.ensureLoaded(),this.entries=new d(this.available_projects),this.listenTo(this.entries,"request",this.onRequest),this.listenTo(this.entries,"sync",this.onLoad)}return r.prototype.FILE=a,r.prototype.session={date:{type:"object",required:!0,"default":function(){return n.moment()}},display:{type:"string",values:["day","week","month"],"default":"week"},isLoading:{type:"boolean","default":!1},customer_project_id:"integer",editing:"any"},r.prototype.derived={project:{deps:["customer_project_id"],fn:function(){return this.available_projects.get(this.customer_project_id)}},isMonth:{deps:["display"],fn:function(){return"month"===this.display}},range:{deps:["date","isMonth"],fn:function(){return n.moment.range(this.date.clone().startOf(this.display),this.date.clone().endOf(this.display))}},calLegend:{deps:["range","display"],fn:function(){return"month"===this.display?this.date.format("MMMM YYYY"):"week"===this.display?this.range.start.format("MMM Do")+" - "+this.range.end.format("MMM Do"):"day"===this.display?this.date.format("MMMM Do YYYY"):void 0}}},r.prototype.events={"change:range":"fetchEvents","change:display":"onDisplayChange","change:customer_project_id":"fetchEvents"},r.prototype.onProjectsRequest=function(){return this.available_projects.add({id:-1,code:"ALL",options:{color:1}},{at:0}),this.set({customer_project_id:e.current_user.options.project_id||-1}),this.trigger("change",this)},r.prototype.startEditing=function(e){var t,n,r,i,o;for(i=this.calEvents().events,o=[],n=0,r=i.length;r>n;n++)t=i[n],o.push(t.setEditing(t===e));return o},r.prototype.stopEditing=function(){var e,t,n,r,i,o;for(i=this.calEvents().events,o=[],n=0,r=i.length;r>n;n++)t=i[n],t.isEditing()&&(e=t.get("entry"),e.isNew()?o.push(t.remove()):o.push(e.setEditing(!1)));return o},r.prototype.addEvent=function(e){var t,n;return e=e.clone(),n=15*Math.round(e.minute()/15),e.minute(n).second(0),t=this.entries.add({start_at:e.subtract(1,"hour"),end_at:e.clone().add(2,"hour"),customer_project:-1!==this.project.id?this.project:void 0}),this.calEvents().add(t.toCalEvent())},r.prototype.onRequest=function(){return this.isLoading=!!this.entries.requestInProgress,this.trigger("change",this)},r.prototype.onLoad=function(){return this.entries.requestInProgress||delete this._cachedEvents,this.isLoading=!!this.entries.requestInProgress,this.trigger("change",this)},r.prototype.reset=function(){return this.entries.loadEntries(this.range.clone())},r.prototype.fetchEvents=function(){return this.entries.resetEntries(this.customer_project_id,this.range)},r.prototype.calEvents=function(){return this._cachedEvents||(this._cachedEvents=new i.Calendar.Events(this.entries.invoke("toCalEvent")))},r.prototype.back=function(){return this.set({editing:!1,date:this.date.clone().subtract(1,this.display)})},r.prototype.forward=function(){return this.set({editing:!1,date:this.date.clone().add(1,this.display)})},r.prototype.onDisplayChange=function(){return this.editing=!1},r.prototype.totalHours=function(){return this.entries.reduce(function(e){return function(t,n){return t.add(n.lengthInRange(e.range,"hours"))}}(this),n.bigDecimal("0"))},r.prototype.totalsForWeek=function(e){var t,r,i,o;return o=this.range.start.clone().add(e-1,"week").startOf("week"),r=n.moment.range(o,o.clone().endOf("week")),i=this.entries.filter(function(e){return r.overlaps(e.range)}),t=n.groupBy(i,function(e){return e.customer_project_id}),n.mapValues(t,function(e,t){return n.reduce(e,function(e,t){return e.plus(t.lengthInRange(r,"hours"))},n.bigDecimal("0"))})},r}(),e.Models.Base.extend(t.Screens.TimeTracking.Entries)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","time-tracking","Entries"]},window),function(e,t,n,r,i,o,s,a,c,p){t.Screens.TimeTracking.Header=function(){function t(){}return t.prototype.displayName="Skr.Screens.TimeTracking.Header",t.prototype.FILE=a,t.prototype.back=function(){return this.props.entries.back()},t.prototype.forward=function(){return this.props.entries.forward()},t.prototype.changeDisplay=function(e){return this.props.entries.display=e.target.value},t.prototype.setProject=function(e){return this.props.entries.set({customer_project_id:e.id})},t.prototype.ProjectOption=function(e){var t,n;return t=(null!=(n=e.item.options)?n.color:void 0)||0,o.createElement("div",{className:"color-"+t},e.item.code)},t.prototype.getProjects=function(){return this.props.entries.available_projects.models},t.prototype.onProjectsToggle=function(e){return e&&!this.props.entries.available_projects.requestInProgress?(this.props.entries.available_projects.fetch(),this.forceUpdate()):void 0},t.prototype.render=function(){return o.createElement(s.Row,{className:"calendar-header"},o.createElement("div",{className:"paging"},o.createElement("span",{className:"legend"},this.props.entries.calLegend),o.createElement(s.ButtonGroup,null,o.createElement(s.Button,{bsSize:"small",onClick:this.back},o.createElement(i.Icon,{size:"2x",type:"caret-left"})),o.createElement(s.Button,{bsSize:"small",onClick:this.forward},o.createElement(i.Icon,{size:"2x",type:"caret-right"})))),o.createElement("div",{className:"display"},o.createElement(s.ButtonGroup,null,o.createElement(s.Button,{value:"month",onClick:this.changeDisplay,active:"month"===this.props.entries.display},"Month"),o.createElement(s.Button,{value:"week",onClick:this.changeDisplay,active:"week"===this.props.entries.display},"Week"),o.createElement(s.Button,{value:"day",onClick:this.changeDisplay,active:"day"===this.props.entries.display},"Day"))),o.createElement("div",{className:"select"},o.createElement(e.Vendor.ReactWidgets.DropdownList,{data:this.getProjects(),busy:!!this.props.entries.available_projects.requestInProgress,onToggle:this.onProjectsToggle,valueField:"id",textField:"code",value:this.props.entries.project,onChange:this.setProject,valueComponent:this.ProjectOption,itemComponent:this.ProjectOption})))},t}(),t.Screens.TimeTracking.Header=e.React.BaseComponent.extend(t.Screens.TimeTracking.Header)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","time-tracking","Header"]},window);