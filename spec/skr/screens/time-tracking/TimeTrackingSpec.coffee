describe "Skr.Screens.TimeTracking", ->

    beforeEach (done) ->
        @screen = LT.renderComponent(Skr.Screens.TimeTracking)
        _.defer =>
            @screen.entries.entries.once 'sync', (te) ->
                done()
            Lanes.Models.Sync.restorePerform =>
                _.dom(@screen).qs('input[value=month]').change(target: {value: 'month'})

    it "renders monthly totals", ->
        expect(true).toEqual(true)
        totals = _.pluck _.dom(@screen).qsa('.day.summary'), 'textContent'
        expect(totals).toEqual(["", "3.25", "13.25", "", ""])
