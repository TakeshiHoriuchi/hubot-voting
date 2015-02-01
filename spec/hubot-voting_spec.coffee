path = require('path')
Robot = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage
should = require('chai').should()

describe 'hubot-voting', ->
  robot = null
  user = null
  adapter = null

  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'testhubot')
    robot.adapter.on 'connected', ->
      robot.loadFile path.resolve('.', 'src', 'scripts'), 'voting.coffee'
      user = robot.brain.userForId '1', {
        name: 'testuser'
        room: '#testroom'
      }
      adapter = robot.adapter
      done()
    robot.run()

  afterEach -> robot.shutdown()

  msg = 'testhubot start vote first item, second item, third item'
  describe msg, ->
    it 'should send message', (done) ->
      adapter.on 'send', (envelope, strs) ->
        try
          envelope.user.room.should.equal '#testroom'
          if strs[0] == 'Vote started'
            strs[0].should.equal 'Vote started'
          else
            strs[0].should.include 'first item'
            done()
        catch err
          done(err)
      adapter.receive new TextMessage(user, msg)
