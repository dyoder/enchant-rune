import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import assert from "@dashkite/assert"

import { getSecret } from "@dashkite/dolores/secrets"
import * as Runes from "@dashkite/runes"
import * as Actions from "@dashkite/enchant/actions"

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

  print await test "@dashkite/enchant-rune-authorizer", [

    test "valid rune", ->
      { rune, nonce } = await Credentials.Runes.valid
      context =
        request:
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

      assert await Actions.authorize schemes, context
    
    test "invalid rune"

  ]

  process.exit success