!function(e,t,n,o,s,r,i,a,l,u){t.Screens.SkuMaint=function(){function e(){}return e.prototype.displayName="Skr.Screens.SkuMaint",e.prototype.FILE=a,e.prototype.syncOptions={include:["default_vendor","uoms"]},e.prototype.modelBindings={sku:function(){return this.loadOrCreateModel({syncOptions:this.syncOptions,klass:t.Models.Sku,prop:"sku",attribute:"code"})}},e.prototype.getInitialState=function(){return{commands:new t.Screens.Commands(this,{modelName:"sku"})}},e.prototype.modelForAccess="sku",e.prototype.render=function(){return r.createElement(s.ScreenWrapper,{identifier:"sku-maint"},r.createElement(o.ScreenControls,{commands:this.state.commands}),r.createElement(i.Row,null,r.createElement(o.SkuFinder,{model:this.sku,sm:4,label:"Code",editOnly:!0,autoFocus:!0,syncOptions:this.syncOptions,model:this.sku,name:"code",commands:this.state.commands}),r.createElement(s.Input,{sm:8,name:"description",model:this.sku})),r.createElement(i.Row,null,r.createElement(o.VendorFinder,{model:this.sku,name:"default_vendor",selectField:!0}),r.createElement(o.GlAccountChooser,{sm:3,label:"Asset Account",name:"gl_asset_account",model:this.sku}),r.createElement(t.Screens.SkuMaint.SkuUomList,{label:"UOMs",model:this.sku,name:"uoms",sm:4})),r.createElement(i.Row,null,r.createElement(s.ToggleField,{sm:2,label:"Is Public?",name:"is_public",model:this.sku}),r.createElement(s.ToggleField,{sm:2,label:"Other Charge?",name:"is_other_charge",model:this.sku}),r.createElement(s.ToggleField,{sm:2,label:"Track Inventory?",name:"does_track_inventory",model:this.sku}),r.createElement(s.ToggleField,{sm:2,label:"Can Backorder?",name:"can_backorder",model:this.sku})))},e}(),t.Screens.SkuMaint=t.Screens.Base.extend(t.Screens.SkuMaint)}(window.Lanes=window.Lanes||{},window.Lanes?window.Lanes.Skr:null,(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","sku-maint","SkuMaint"]},window),function(e,t,n,o,s,r,i,a,l,u){var p,c,m,d;d=function(){function e(t,n){this.sku=t,e.__super__.constructor.call(this),this.uoms=this.sku.uoms.clone(),this["default"]=this.uoms.findWhere({code:this.sku.default_uom_code}),this.expanded=n||this.uoms.first()}return e.prototype.FILE=a,e.prototype.session={"default":"state",expanded:"state"},e.prototype.save=function(){return this.sku.associations.replace(this.sku,"uoms",this.uoms),this.sku.default_uom_code=this["default"].code},e.prototype.add=function(){return this.uoms.add({}),1===this.uoms.length&&(this["default"]=this.uoms.first()),this.trigger("change",this.uoms)},e.prototype.map=function(e){return this.uoms.map(e)},e.prototype.isDefault=function(e){return e===this["default"]},e.prototype.setDefault=function(e){return this.trigger("change"),this["default"]=e},e}(),e.Models.State.extend(d),m=function(){function e(){}return e.prototype.displayName="UomEdit",e.prototype.FILE=a,e.prototype.propTypes={list:r.PropTypes.instanceOf(d).isRequired,uom:r.PropTypes.instanceOf(t.Models.Uom).isRequired},e.prototype.modelBindings={list:"props",uom:"props"},e.prototype.onHeaderClick=function(e){return"I"!==e.target.tagName?this.list.expanded=this.uom:void 0},e.prototype.onCheckboxChange=function(e){return"I"===e.target.tagName?this.props.list.setDefault(this.props.uom):void 0},e.prototype.render=function(){var e;return e=r.createElement("div",{className:"cursor-pointer",onClick:this.onHeaderClick},r.createElement(s.Icon,{type:""}),this.props.uom.combined,r.createElement("span",{className:"pull-right"},r.createElement(t.Components.Currency,{amount:this.props.uom.price}),r.createElement(s.Icon,{style:{marginLeft:"0.5em"},onClick:this.onCheckboxChange,type:this.props.list.isDefault(this.props.uom)?"check-square-o":"square-o"}))),r.createElement(i.Panel,{ref:"panel",collapsible:!0,expanded:this.list.expanded===this.uom,header:e},r.createElement(i.Row,null,r.createElement(s.Input,{type:"text",label:"Code",name:"code",model:this.props.uom,xs:4}),r.createElement(s.NumberInput,{type:"number",label:"Size",name:"size",format:"#,###",model:this.props.uom,xs:3}),r.createElement(s.NumberInput,{type:"text",label:"Price",name:"price",model:this.props.uom,xs:5})))},e}(),m=e.React.Component.extend(m),p=function(){function n(){}return n.prototype.displayName="EditBody",n.prototype.FILE=a,n.prototype.propTypes={selected:r.PropTypes.instanceOf(t.Models.Uom),uoms:e.PropTypes.Collection.isRequired},n.prototype.modelBindings={uoms:"props"},n.prototype.add=function(){return this.props.uoms.add()},n.prototype.render=function(){return r.createElement(i.Accordion,null,r.createElement(i.Panel,{className:"sku-uom-edit"},this.props.uoms.map(function(e){return function(t){return r.createElement(m,{key:t.cid,list:e.props.uoms,uom:t})}}(this))))},n}(),p=e.React.Component.extend(p),c=function(){function e(){}return e.prototype.displayName="UOMToken",e.prototype.FILE=a,e.prototype.propTypes={uom:r.PropTypes.instanceOf(t.Models.Uom)},e.prototype.onClick=function(e){return e.preventDefault(),this.props.onEdit(this.props.uom)},e.prototype.render=function(){return r.createElement("li",{onClick:this.onClick,className:"cursor-pointer"},this.props.uom.combined,r.createElement(t.Components.Currency,{style:{marginLeft:"0.5rem"},amount:this.props.uom.price}))},e}(),c=e.React.BaseComponent.extend(c),t.Screens.SkuMaint.SkuUomList=function(){function e(){}return e.prototype.displayName="Skr.Screens.SkuMaint.SkuUomList",e.prototype.FILE=a,e.prototype.mixins=[s.Form.FieldMixin],e.prototype.getInitialState=function(){return{editing:!1}},e.prototype.onEdit=function(e){return null==e&&(e=this.model.uoms.first()),this.setState({editing:new d(this.model),selected:e})},e.prototype.onAdd=function(){return this.refs.body.add()},e.prototype.onOk=function(){return this.state.editing.save(),this.setState({editing:!1})},e.prototype.onCancel=function(){return this.setState({editing:!1})},e.prototype.renderEditingPopup=function(){var e;return this.state.editing?(e=r.createElement("div",null,r.createElement("span",null,"UOMs"),r.createElement(s.Icon,{type:"plus",className:"pull-right",onClick:this.onAdd})),r.createElement(i.Popover,{ref:"popover",className:"sm",id:"sku-edit-uoms",className:"sku-uoms-editing",title:e,placement:"left"},r.createElement(p,{ref:"body",uoms:this.state.editing,selected:this.state.selected}),r.createElement("div",{className:"panel-footer"},r.createElement(i.Button,{onClick:this.onCancel},"Cancel"),r.createElement(i.Button,{style:{marginLeft:10},bsStyle:"primary",onClick:this.onOk},"OK")))):r.createElement("span",null)},e.prototype.renderDisplay=function(){var e;return e=this.model.uoms.map(function(e){return e.combined}),r.createElement("span",null,e.join(", "))},e.prototype.renderEdit=function(e){var t;return t=n.classnames("sku-uom-list",e.className),r.createElement("div",{className:t},r.createElement("ul",{className:"form-control"},this.model.uoms.map(function(e){return function(t){return r.createElement(c,{key:t.cid,uom:t,onEdit:e.onEdit})}}(this))),r.createElement("span",{className:"input-group-btn"},r.createElement(i.OverlayTrigger,{classNames:t,trigger:"click",ref:"overlay",rootClose:!0,arrowOffsetTop:"130px",container:this,onExit:this.onCancel,placement:"left",overlay:this.renderEditingPopup()},r.createElement(i.Button,{ref:"addButton",onClick:function(e){return function(){return e.onEdit(e.model.uoms.first())}}(this)},r.createElement(s.Icon,{type:"gear"})))))},e}(),t.Screens.SkuMaint.SkuUomList=e.React.Component.extend(t.Screens.SkuMaint.SkuUomList)}(window.Lanes=window.Lanes||{},window.Lanes?window.Lanes.Skr:null,(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","sku-maint","SkuUomList"]},window);