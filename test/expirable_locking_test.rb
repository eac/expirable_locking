require 'helper'

class ExpirableLockingTest < ActiveRecord::TestCase

  class LockableEmail < ActiveRecord::Base
    extend ExpirableLocking
  end

  context "Expirable locks" do
    setup do
      @model  = LockableEmail
      @record = @model.create!
    end

    should "have a lock duration of 10 minutes by default" do
      assert_equal 10.minutes, @model.lock_duration
    end

    context "unlocked scope" do

      should "include records that have never been locked" do
        assert @model.unlocked.include?(@record)
      end

      should "include records with an expired lock" do
        Timecop.freeze(@model.lock_duration.ago - 1.second) do
          @model.touch_lock(@record)
        end

        assert @model.unlocked.include?(@record)
      end

      should "not include records with a lock that isn't expired" do
        Timecop.freeze(@model.lock_duration.ago + 1.second) do
          @model.touch_lock(@record)
        end

        assert_equal false, @model.unlocked.include?(@record)
      end
    end

    context "locking" do

      should "fail for locked records" do
        @model.touch_lock(@record)
        assert_equal false, @record.lock_with_expirey
      end

      should "succeed for unlocked records" do
        assert @model.unlocked.include?(@record)
        assert_equal true, @record.lock_with_expirey
      end

    end

    context "unlocking" do

      should "succeed without querying the database for deleted records" do
        @record.lock_with_expirey
        @record.destroy

        @record.class.connection.expects(:update).never
        assert_equal true, @record.unlock
      end

      should "succeed when the lock hasn't expired" do
        @record.lock_with_expirey
        assert_equal true, @record.unlock
      end

      should "fail when the lock expired and was re-aqcuired by another process" do
        Timecop.freeze(@model.lock_duration.ago - 1.second) do
          @record.lock_with_expirey
        end
        @model.find(@record).lock_with_expirey # Oh hi, other process

        assert_equal false, @record.unlock
      end

      should "remove the record's lock" do
        @model.touch_lock(@record)
        @record.unlock

        assert @model.unlocked.include?(@record)
      end

    end

    context "touching the lock" do

      should "update the record's lock timestamp" do
        Timecop.freeze(Time.now) do
          @model.touch_lock(@record)

          assert_equal Time.current.to_i, @record.locked_at.to_i
          assert_equal Time.current.to_i, @record.reload.locked_at.to_i
        end
      end

    end

  end

end

