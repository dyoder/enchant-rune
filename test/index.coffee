import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import assert from "@dashkite/assert"

import { getSecret } from "@dashkite/dolores/secrets"
import * as Runes from "@dashkite/runes"
import { Actions } from "@dashkite/enchant/actions"

# MUT - registers the Rune authorizer
import "../src"

# rune authorization
import authorization from "./authorization"

# mock fetch that just runs locally
globalThis.Sky =
  fetch: ( request ) ->

do ->

  secret = await getSecret "guardian"

  Credentials =
    Runes:
      valid: 
        Runes.issue { authorization, secret }

  print await test "@dashkite/enchant-rune", [

    test "valid rune", ->
      { rune, nonce } = await Credentials.Runes.valid
      context =
        request:
          origin: "acme.io"
          resource:
            name: "foo"
            bindings:
              bar: "abc"
          method: "get"
          authorization:
            scheme: "rune"
            credential: rune
            parameters:
              nonce: nonce
      schemes = [ "rune" ]

      # assert await Actions.authorize schemes, context
      console.log await Actions.authorize schemes, context
    
    test "invalid rune"

    test "issue rune"

    # TODO need to add faux resolvers to Rune
    # TODO we probably also need to update the Runes used here?
    # maybe just copy the over from the Runes module?
    test "bind runes", ->
      { rune, nonce } = await Credentials.Runes.valid
      context =
        request:
          origin: "acme.io"
          resource:
            name: "foo"
            bindings:
              bar: "abc"
          method: "get"
          authorization: [
            scheme: "rune"
            credential: rune
            parameters:
              nonce: nonce
          ]
      console.log await Actions["bind runes"] { secret:  "guardian" }, context

  ]

  process.exit success