class Skr.Screens.Events extends Skr.Screens.Base

    syncOptions:
        include: [ 'sku', 'photo', 'presents_logo' ]

    modelBindings:
        event: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.Event
                prop: 'event', attribute: 'code'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'event')

    render: ->

        <LC.ScreenWrapper identifier="events">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>
                <SC.EventChooser label='Code' editOnly displayFinder
                    syncOptions={@syncOptions}
                    commands={@state.commands} model={@event} name="code" />

                <SC.SkuFinder sm=3 model={@event}
                    parentModel={@event} associationName='sku' />

                <LC.Input sm=6 name='title' model={@event} />
            </BS.Row>
            <BS.Row>
                <LC.Input sm=7 name='sub_title' model={@event} />
                <LC.NumberInput sm=1 name='max_qty' model={@event} format='#' />
                <LC.DateTime sm=4 name="starts_at" model={@event} />
            </BS.Row>
            <BS.Row>
                <LC.TextArea sm=12 name='info' model={@event} />
            </BS.Row>
            <BS.Row>
                <LC.TextArea sm=12 name='post_purchase_message' model={@event} />
            </BS.Row>
            <BS.Row>
                <LC.TextArea sm=12 name='email_signature' model={@event} />
            </BS.Row>
            <BS.Row>
                <LC.Input sm=12 name='venue' model={@event} />
            </BS.Row>
            <BS.Row>
                <LC.FieldSet title="Logos" sm=12>
                    <LC.ImageAsset sm=6 asset={@event.photo}
                        label='Photo' size='thumb' />
                    <LC.ImageAsset sm=6 asset={@event.presents_logo}
                        label='Presents Logo' size='thumb' />
                </LC.FieldSet>
            </BS.Row>

        </LC.ScreenWrapper>
