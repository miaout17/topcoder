module Topcoder
  class DataConverter
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def coder_basic_data
      int :coder_id
      str :handle
      str :country_name
    end

    def coder_rating_data(type)
      int "#{type}_rating"
      int "#{type}_vol"
      int "#{type}_num_ratings"
    end

    def dd_coder_list
      coder_basic_data
      %w{alg des dev mar}.each { |t| coder_rating_data(t) }
    end

    def dd_active_algorithm_list
      coder_basic_data
      coder_rating_data(:alg)
    end

    def dd_round_list
      int :round_id
      time :date
    end

    def dd_rating_history
      int :coder_id
      int :round_id
      time :date
      int :old_rating
      int :new_rating
      int :volatility
      int :rank
      float :percentile
      int :rating_order
    end

    def dd_round_results
      int :room_id
      int :coder_id
      int :old_rating
      int :new_rating
      int :new_vol
      int :num_ratings
      int :room_placed
      int :division_placed
      float :challenge_points
      float :system_test_points
      float :defense_points
      float :submission_points
      float :final_points
      int :division
      int :problems_presented
      int :problems_submitted
      int :problems_correct
      int :problems_failed_by_system_test
      int :problems_failed_by_challenge
      int :problems_opened
      int :problems_left_open
      int :challenge_attempts_made
      int :challenges_made_successful
      int :challenges_made_failed
      int :challenge_attempts_received
      int :challenges_received_successful
      int :challenges_received_failed
      int :rated_flag

      %w{one two three}.each do |level|
        int "level_#{level}_problem_id"
        float "level_#{level}_submission_points"
        float "level_#{level}_final_points"
        int "level_#{level}_time_elapsed"
        int "level_#{level}_placed"
      end
    end

    # Data conversion helper methods

    def self.converter(*methods)
      methods.each do |method|
        origin_method = "origin_#{method}"
        alias_method origin_method, method
        class_eval <<-RUBY
          def #{method}(key)
            key = key.to_sym
            raise "Key not found \#{key}" unless data[key]
            #{origin_method}(key)
          end
        RUBY
      end
    end

    def str(key)
      # Just ensuare the key exists
    end

    def int(key)
      data[key] = data[key].to_i
    end

    def float(key)
      data[key] = data[key].to_f
    end

    def time(key)
      # TODO: Convert Eastern Time to GMT
      data[key] = DateTime.parse(data[key])
    end

    converter :str, :int, :float, :time

  end
end
