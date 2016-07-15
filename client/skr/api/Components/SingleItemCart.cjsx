class Skr.Api.Components.SingleItemCart extends Skr.Api.Components.Base

    modelBindings:
        cart: 'props'

    item: -> @cart.skus.first()

    setQty: (ev) ->
        @item().qty = ev.target.value

    render: ->
        item = @item()
        return null unless item

        <table className="cart">
          <tbody>
            <tr>
              <td colSpan="4">{item.sku.description}</td>
              <td>{item.sku.display_price}</td>
            </tr>
            <tr>
              <th>Qty:</th>
              <td>
                  <input type="number" value={item.qty} onChange={@setQty} />
              </td>
              <th>Total:</th>
              <th colSpan="2">{item.display_total}</th>
            </tr>
          </tbody>
        </table>
