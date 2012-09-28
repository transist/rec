# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require :default

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Rec'
  app.frameworks += ['AVFoundation', 'CoreAudio']
  app.vendor_project 'vendor/UIButton-Glossy', :static
end