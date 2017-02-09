#!/usr/bin/env ruby

APP_ROOT = File.dirname(__FILE__)
require_relative('lib/sugarcrm')

sugarcrm = Sugarcrm.new()
sugarcrm.launch!