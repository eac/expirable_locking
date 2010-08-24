module ExpirableLocking

  def self.extended(base)
    base.named_scope :unlocked, lambda {
      { :conditions => [ "locked_at IS NULL OR locked_at < ?", base.lock_duration.ago ] }
    }
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def lock_with_expiry
      self.class.lock(self)
    end

    def unlock
      self.class.unlock(self)
    end

  end

  def lock_duration
    10.minutes
  end

  def lock(record)
    1 == unlocked.touch_lock(record)
  end

  def unlock(record)
    return true if record.destroyed?

    1 == update_all({ :locked_at => nil }, { :id => record, :locked_at => record.locked_at })
  end

  # Updates lock timestamp without triggering validations/callbacks.
  def touch_lock(record)
    locked_at = default_timezone == :utc ? Time.now.utc : Time.now
    result    = update_all({ :locked_at => locked_at }, { :id => record })

    if result == 1
      record.write_attribute_without_dirty(:locked_at, locked_at)
    end

    result
  end

end

