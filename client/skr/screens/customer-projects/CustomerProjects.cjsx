class Skr.Screens.CustomerProjects extends Skr.Screens.Base

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'project')

    dataObjects:
        project: ->
            @props.project || new Skr.Models.CustomerProject


    modelForAccess: 'customer-project'

    getHourlyRate: -> @project.rates?.hourly
    setHourlyRate: (value) ->
        @project.rates = _.extend({}, @project.rates, {hourly: value.replace(/[^0-9.]/g, '')})

    render: ->
        <LC.ScreenWrapper identifier="customer-projects">
            <Lanes.Screens.CommonComponents activity={@state}
                commands={@state.commands} model={@project} />
            <BS.Row>
                <SC.CustomerProjectFinder commands={@state.commands}
                model={@project} autoFocus editOnly sm=3 />

                <SC.CustomerFinder selectField sm=3
                    label='Customer' model={@project} />

                <SC.SkuFinder selectField sm=3 model={@project} />

                <LC.Input sm=3 name="rates" label='Hourly Rate' model={@project}
                    setValue={@setHourlyRate} getValue={@getHourlyRate} />
            </BS.Row>
            <BS.Row>
                <LC.Input name="po_num" model={@project} sm=3 />
                <LC.Input name="description" model={@project} sm=9 />
            </BS.Row>

        </LC.ScreenWrapper>
