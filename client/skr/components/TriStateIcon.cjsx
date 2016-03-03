ICON_TYPES =
  all:  'check-square'
  some: 'check-square-o'
  none: 'square-o'

class Skr.Components.TriState extends Lanes.React.Component

    propTypes:
        type: React.PropTypes.oneOf(_.keys(ICON_TYPES)).isRequired

    render: ->
        <LC.Icon type={ICON_TYPES[@props.type]} />
