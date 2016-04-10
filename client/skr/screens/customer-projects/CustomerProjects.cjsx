class Skr.Screens.CustomerProjects extends Skr.Screens.Base

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'project')

    dataObjects:
        project: ->
            @loadOrCreateModel({
                klass: Skr.Models.CustomerProject,
                prop: 'project', attribute: 'code'
            })

    modelForAccess: 'customer-project'

    getHourlyRate: -> @project.rates?.hourly
    setHourlyRate: (value) ->
        @project.rates = _.extend({}, @project.rates, {hourly: value.replace(/[^0-9.]/g, '')})
    ColorOption: (props) ->
        <div className={"color-#{props.item.id}"}>{props.item.name}</div>

    setColor: (value) ->
        @project.options = _.extend({}, @project.options, {color: value.id})
        @forceUpdate()
    getColorReadOnly: ->
        index = @getColor()
        color = _.find(Skr.Models.CustomerProject.COLORS, id: index)
        <div className={"ro color-#{index}"}>{color?.name}</div>

    getColor: ->
        @project.options?.color

    render: ->
        <LC.ScreenWrapper identifier="customer-projects">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>
                <SC.CustomerProjectFinder ref='finder' commands={@state.commands}
                    model={@project} autoFocus editOnly sm=3 />

                <SC.CustomerFinder selectField sm=3
                    label='Customer' model={@project} name='customer' />

                <SC.SkuFinder selectField sm=3 model={@project} name='sku' />
                <LC.Input name="po_num" model={@project} sm=3 />
            </BS.Row>
            <BS.Row>
                <LC.Input sm=2 name="rates" label='Hourly Rate' model={@project}
                    setValue={@setHourlyRate} getValue={@getHourlyRate} />

                <LC.FieldWrapper sm=2
                    label="Entry Color"
                    className="color-selection"
                    value={@getColorReadOnly()}
                >
                    <Lanes.Vendor.ReactWidgets.DropdownList
                        className='colors'
                        data={Skr.Models.CustomerProject.COLORS}
                        valueField='id' textField='name'
                        value={@getColor()} onChange={@setColor}
                        valueComponent={@ColorOption}
                        disabled={!@state.commands.isEditing()}
                        itemComponent={@ColorOption} />
                </LC.FieldWrapper>

                <LC.Input name="name" model={@project} sm=8 />
            </BS.Row>
            <BS.Row>
                <LC.Input name="description" model={@project} sm=12 />
            </BS.Row>

        </LC.ScreenWrapper>
