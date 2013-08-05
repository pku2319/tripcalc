require 'test_helper'

class HotwireTest < ActiveSupport::TestCase
  test "should find minimum hotel in each class" do
    VCR.use_cassette("hotwire/minimum") do
      min_price = Hotwire.get_hotels("US, San Francisco, CA", 1, 1, 0, "11/11/2013", "11/13/2013")
      assert_equal ({:moderate=>162.8, :economic=>108.4, :luxury=>565.99}), min_price
    end
  end
end