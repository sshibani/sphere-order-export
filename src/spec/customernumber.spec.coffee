CustomerNumber = require '../lib/customernumber'
SphereClient = require 'sphere-node-client'
config = require '../config'

describe 'CustomerNumber', ->
  beforeEach ->
    @cn = new CustomerNumber config
  
  it 'should return UNKOWN for non existing customer', (done) ->
    @cn.getCustomerNumberById('not-existing-id').then (customerNumber) ->
      expect(customerNumber).toBe 'UNKOWN'
      done()

  it 'should return the customer number', (done) ->
    unique = new Date().getTime()
    customerService = new SphereClient(config).customers
    customer =
      firstName: 'John'
      lastName: 'Doe'
      email: "john.doe+#{unique}@example.com"
      password: 'foobar'
      externalId: 'ext123'
    customerService.save(customer).then (res) =>
      @cn.getCustomerNumberById(res.customer.id).then (customerNumber) ->
        expect(customerNumber).toBe 'ext123'
        done()

