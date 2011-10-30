QuoteIt: quote from any web resource
====================================

Overview
------------------------------
QutoteIt provides API to get the thumbnail image and the clip of a web resource. This reduce a boilerplate code from some URL expanding plugin(e.g. wiki macro, grease monkey, and others).

Requirement
----------------

 * Ruby 1.9.2
 * Bundler 1.0.7 or later
 * MongoDB 1.8.1 or later
 * memcached 1.4.9 or later

Install and start
------------------------------

QuoteIt needs mongod and memcached.

    $ mongod --dbpath <dir_name>
    $ memcached -vv

And run QuoteIt.

    $ bundle install --path vendor/bundle
    $ bundle exec padrino start

access to http://localhost:3000

Test
------------------------------

    $ bundle exec padrino rake spec

Author
------------------------------
 * @mzp