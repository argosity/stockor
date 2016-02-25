class Skr.Screens.TimeTracking.EditEntry extends Lanes.React.Component

    dataObjects:
        entry: -> @props.event?.get('entry')

    setDataState: (change) ->
        if change.event
            @entry.fromCalEvent(change.event)
            change.event.set({content: @entry.content}, {silent: true})
        @forceUpdate()

    getTarget: ->
        return null unless @props.wrapper.isMounted()
        _.dom(@props.wrapper).el

    onSave: ->
        event = @props.event
        @entry.save().then (te) =>
            event.set(_.extend({editing: false}, te.toCalEvent()))
            @props.onCancel() unless te.errors

    componentDidMount: ->
        _.defer => _.dom(@).qs('input[name=hours]').focusAndSelect()

    render: ->
        props = {sm:12, editOnly: true, model: @entry}
        <div className="entry-body">
            <LC.NetworkActivityOverlay model={@entry} roundedCorners />
            <BS.Row>
                <LC.SelectField {...props} sm={9}
                    name='customer_project' labelField="code" />
                <LC.Input {...props} sm={3} name='hours' onEnter={@onSave} />
            </BS.Row><BS.Row>
                <LC.DateTime {...props} step={15} name="start_at"/>
            </BS.Row><BS.Row>
                <LC.DateTime {...props} step={15} name="end_at"/>
            </BS.Row><BS.Row>
                <LC.Input sm={12}
                    model={@entry}
                    ref='textarea'
                    onEnter={@onSave}
                    selectOnFocus editOnly
                    name="description"
                    type="textarea"
                    label='Description'
                />
            </BS.Row>
            <BS.Row className="controls">
                <BS.Button tabIndex={-1} onClick={@props.onCancel}>Cancel</BS.Button>
                <BS.Button onClick={@onSave} bsStyle="primary">Save</BS.Button>
            </BS.Row>
        </div>
