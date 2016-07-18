describe "Skr.Screens.TimeTracking", ->

    beforeEach (done) ->
        @screen = LT.renderComponent(Skr.Screens.TimeTracking)
        _.defer =>
            @screen.entries.entries.once 'sync', (te) -> done()
            Lanes.Models.Sync.restorePerform =>
                _.dom(@screen).qs('button[value=month]').click()


    it "renders monthly totals", ->
        _.dom(@screen).qs('button[value=month]').click()
        totals = _.map _.dom(@screen).qsa('.day.summary'), 'textContent'
        expect(totals).toEqual(['', '', '30.25', '', ''])
