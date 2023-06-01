require "test_helper"

class Testx < ActiveSupport::TestCase
  def test_add_or_change
    name = "Table 1"
    header = ["話題", "スコア"]
    points = [3, 2, 1, 0]
    names = ["a", "b", "c", "d"]

    AbcsHelper::Choicex.init(points, names)
    votea_result = [1,2,3,0]
    votea = AbcsHelper::Votex.new("a", votea_result)

    voteb_result = [2,3,1, 0]
    voteb = AbcsHelper::Votex.new("b", voteb_result)

    ts = AbcsHelper::TotalScorex.new(header)
    ts.add_or_change(votea)
#    ts.add_or_change(voteb)
#    p ts.data
    p ts.get_sorted_choices

    votec_result = [3,1, 0, 2]
    votec = AbcsHelper::Votex.new("c", votec_result)
    ts.add_or_change(votec)
    p ts.data
    p ts.get_sorted_choices
  end
end

