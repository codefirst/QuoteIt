# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
require 'quoteit/parser'

x = Quoteit::Parser.load_from_file(Rails.root + './config/quote_it.json')
x[:thumbnails].each(&:save!)
x[:htmls].each(&:save!)
