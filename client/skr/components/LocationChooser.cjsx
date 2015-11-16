SHARED_COLLECTION = new Skr.Models.Location.Collection

class Skr.Components.LocationChooser extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        name:       React.PropTypes.string

    getDefaultProps: ->
        label: 'Location', name: 'location'

    componentWillMount: ->
        SHARED_COLLECTION.ensureLoaded()

    render: ->
        props = _.clone(@props)
        s = SHARED_COLLECTION

        <LC.SelectField
            {...props}
            collection={SHARED_COLLECTION}
            labelField='code'
            fetchWhenOpen={false}
            model={@props.model} />


        # if props.selectField
        #     <LC.SelectField sm=2
        #         labelField="code"
        #         setSelection={@selectSetCustomer}
        #         getSelection={@selectGetSelection}
        #         {...props}
        #         model={@props.model}
        #     />
