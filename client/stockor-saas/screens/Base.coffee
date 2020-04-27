StockorSaas.Screens.Base = {

    # An extension point to modify the prototypes for screens
    extend: (klass) ->
        # Extend screen component with Lanes defaults,
        # which will eventually call React.createClass
        Lanes.React.Screen.extend(klass)

}
