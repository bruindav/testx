_ = require 'lodash'
{get, getAll, getAttribute} = require './api'
assert = require '../assert'

check = (condition, positive = true) -> (args, ctx) ->
  for key, val of args
    if typeof val is 'object'
      for attr, expected of val
        cond = expect await getAttribute key, attr
        cond = cond.not if not positive
        await cond[condition] expected
    else
      cond = expect await get key
      cond = cond.not if not positive
      await cond[condition] val

module.exports =
  'check equals': check 'toEqual'
  'check not equals': check 'toEqual', false
  'check matches': check 'toMatch'
  'check not matches': check 'toMatch', false
  'check exists': (args, ctx) ->
    for key, val of args
      values = await getAll key
      if val or val is ''
        expect(values?.length).toBeTruthy()
      else
        expect(values?.length).toBeFalsy()
  'check enabled': (args, ctx) ->
    for key, val of args
      el = await testx.element key
      expect(await el.isEnabled()).toBe val
  'check readonly': (args, ctx) ->
    for key, val of args
      expected = if val then val else null
      el = await testx.element key
      actual = await el.getAttribute('readonly')
      expect(actual).toBe expected
