module Topcoder
  module API
    def algorithm_round_list
      get('', :c => 'dd_round_list')
    end
  end
end
