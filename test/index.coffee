import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import assert from "@dashkite/assert"

import { getSecret } from "@dashkite/dolores/secrets"
import { expand } from "@dashkite/polaris"

# import * as Runes from "@dashkite/runes"
import { Actions } from "@dashkite/enchant/actions"

# MUT - registers the Rune authorizer
import "../src"

import "./fetch"
import makeRune from "./runes"
import scenarios from "./scenarios"

do ->

  secret = await getSecret "guardian"

  print await test "@dashkite/enchant-rune", [

    test "valid rune", ->
      # scenario = scenarios[ "valid rune" ]
      # { rune, nonce } = await makeRune secret, "valid"
      # context = expand scenario, { rune, nonce }
      # assert await Actions.authorize [ "rune" ], context
    
    test "invalid rune"

    test "issue rune"

    test "bind runes" , ->
      scenario = scenarios[ "bind runes" ]
      { rune, nonce } = await makeRune secret, "valid"
      context = expand scenario, { rune, nonce }
      console.log await Actions["bind runes"] { secret:  "guardian" }, context

  ]

  process.exit success