class Attachments extends Lanes.React.Component
    modelBindings:
        attachments: 'props'

    render: ->
        <LC.FieldSet
             title={"Attachments (#{@attachments.length-1})"}
         >
             <LC.AssetsListing assets={@attachments}
                 name='attachments' size="thumb" />
         </LC.FieldSet>

class Skr.Screens.ExpenseEntry.Form extends Lanes.React.Component

    propTypes:
        onEntrySave: React.PropTypes.func.isRequired

    modelBindings:
        entry: 'props'

    getInitialState: ->
        isEditing: true

    mixins: [
        Lanes.React.Mixins.RelayEditingState
    ]

    focus: ->
        _.defer => @refs.name.focus()

    render: ->
        <div className="form">
            <LC.NetworkActivityOverlay model={@entry} />
            <BS.Row>
                <LC.Input sm=8 name='name' ref="name" model={@entry} />
                <Skr.Screens.ExpenseEntry.Categories
                    categories={@props.categories}
                    entry={@entry} sm={4} />
            </BS.Row>

            <BS.Row>
                <Attachments attachments={@entry.attachments} />
            </BS.Row>

            <BS.Row>
                <LC.Input sm=10 name='memo' model={@entry} />
                <LC.FormGroup className='controls' sm=2>
                    <BS.ButtonGroup>
                        <BS.Button tabIndex={-1} onClick={@props.onEntryReset}>Reset</BS.Button>
                        <BS.Button onClick={@props.onEntrySave}>Save</BS.Button>
                    </BS.ButtonGroup>
                </LC.FormGroup>
            </BS.Row>
        </div>
