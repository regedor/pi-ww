class LogEntry < ApplicationRecord
    before_update :prevent_update
  
    def self.create_log(info)
        caller_class = caller_locations(1,1)[0].to_s.match(/\/([^\/]+_controller)\.rb/)[1]
        create(
            controller_name: caller_class,
            info: info
        )
    end

    private

    def prevent_update
      errors.add(:base, "Cannot update log entries")
      throw(:abort)
    end
end
