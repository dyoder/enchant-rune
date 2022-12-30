import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import assert from "@dashkite/assert"

import { getSecret } from "@dashkite/dolores/secrets"
import { expand } from "@dashkite/polaris"
import { convert } from "@dashkite/bake"

import * as Runes from "@dashkite/runes"
import { Actions } from "@dashkite/enchant/actions"

# MUT - registers the Rune authorizer
import "../src"

import "./fetch"
import makeRune from "./runes"
import scenarios from "./scenarios"

import authorization from "./authorization"
import bound from "./bound"

do ->

  secret = await getSecret "guardian"

  print await test "@dashkite/enchant-rune", [

    test "valid rune", ->
      scenario = scenarios[ "valid rune" ]
      { rune, nonce } = await makeRune secret, "valid"
      context = expand scenario, { rune, nonce }
      assert await Actions.authorize [ "rune" ], context
    
    test "invalid rune"

    test "issue rune", ->
      result = await Actions["issue rune"] { 
        authorization: authorization
        secret:  "guardian" 
      }, {}
      credentials = JSON.parse convert from: "base64", to: "utf8", result
      [ issued ] = Runes.decode credentials.rune
      # remove the escaped characters for comparison
      _authorization = expand authorization, {}
      assert.deepEqual issued.grants, _authorization.grants

    test "bind runes" , ->
      scenario = scenarios[ "bind runes" ]
      { rune, nonce } = await makeRune secret, "valid"
      context = expand scenario, { rune, nonce }
      result = await Actions["bind runes"] { secret:  "guardian" }, context
      credentials = JSON.parse convert from: "base64", to: "utf8", result
      [ _bound ] = Runes.decode credentials[0].rune
      assert !(rune.resolvers?)
      assert.deepEqual bound.grants, _bound.grants
      
  ]

  process.exit success