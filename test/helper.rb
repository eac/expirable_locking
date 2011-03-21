require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'activerecord'
require 'mocha'
require 'timecop'
require 'activesupport'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'expirable_locking'

class Test::Unit::TestCase
end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => '/tmp/expirable_locking.sqlite')

ActiveRecord::Schema.define do

  create_table :lockable_emails, :force => true do |table|
    table.string :from
    table.string :to
    table.text   :mail
    table.timestamps

    table.datetime :locked_at
    table.string   :locked_by
  end

end

