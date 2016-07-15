class Skr.Components.UserPreferences extends Lanes.React.Component
    modelBindings:
        user: -> Lanes.current_user
        projects: -> new Skr.Models.CustomerProject.Collection

    componentWillMount: -> @projects.ensureLoaded()

    setProject: (project) ->
        @user.options = _.extend({}, @user.options, {project_id: project.id})

    getProject: ->
        return unless @user.options?.project_id
        { id: @user.options.project_id, label: @projects.get(@user.options.project_id)?.code }

    render: ->
        <BS.Row className="skr-preferences">

            <LC.SelectField xs=4
                fetchWhenOpen={false}
                label='Default Customer Project'
                labelField='code'
                model={@user}
                name='options'
                choices={@projects.models}
                setSelection={@setProject}
                getSelection={@getProject}
                queryModel={Skr.Models.CustomerProject}
            />

        </BS.Row>
