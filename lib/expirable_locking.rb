module ExpirableLocking

  def self.extended(base)
    base.class_eval do
      named_scope :unlocked, lambda {
        { :conditions => [ "locked_at IS NULL OR locked_at < ?", base.lock_duration.ago ] }
      }

      include InstanceMethods
    end
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

    new_attributes = unlock_attributes
    if result = (1 == update_all(new_attributes, { :id => record, :locked_at => record.locked_at }))

      new_attributes.each do |key, value|
        record.write_attribute_without_dirty(key, value)
      end

    end

    result
  end

  # Updates lock timestamp without triggering validations/callbacks.
  def touch_lock(record)
    new_attributes = lock_attributes
    result = update_all(new_attributes, { :id => record })

    if result == 1
      new_attributes.each do |key, value|
        record.write_attribute_without_dirty(key, value)
      end
    end

    result
  end

  def unlock_attributes
    lock_attributes.tap do |attributes|
      attributes.keys.each { |key| attributes[key] = nil }
    end
  end

  def lock_attributes
    locked_at = default_timezone == :utc ? Time.now.utc : Time.now

    Hash.new.tap do |attributes|
      attributes[:locked_at] = locked_at
      attributes[:locked_by] = lock_name if method_defined?(:locked_by)
    end
  end

  def lock_name
    "#{`hostname`.chomp}:#{Process.pid}"
  end

end

