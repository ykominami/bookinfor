require "test_helper"

class Testx < ActiveSupport::TestCase
  def test_totalscore_init
    @abcs = Abc.all
    name = "Table 1"
    header = ["話題", "スコア"]
    choice_names = {4 => "ch_a", 5 => "ch_b", 6 => "ch_c", 7 => "ch_d"}
    points = [3, 2, 1, 0]

    AbcsHelper::Choicex.init(points, choice_names)
    ts = AbcsHelper::TotalScorex.new(header)
    votea_result = [4,5,6,7]
    votea = AbcsHelper::Votex.new("a", votea_result)

    p ts.data
    ts.add_or_change(votea)
    p ts.data
  end

  def test_add_or_change
    @abcs = Abc.all
    name = "Table 1"
    header = ["話題", "スコア"]
    choice_names = {4 => "ch_a", 5 => "ch_b", 6 => "ch_c", 7 => "ch_d"}
    points = [3, 2, 1, 0]

    AbcsHelper::Choicex.init(points, choice_names)
    # p AbcsHelper::Choicex.get_name_values

    ts = AbcsHelper::TotalScorex.new(header)

    votea_result = [4,5,6,7]
    votea = AbcsHelper::Votex.new("a", votea_result)

    voteb_result = [6,7,5, 4]
    voteb = AbcsHelper::Votex.new("b", voteb_result)

    votec_result = [7,5, 4, 6]
    votec = AbcsHelper::Votex.new("c", votec_result)

    ts.add_or_change(votea)
    ts.add_or_change(voteb)
    ts.add_or_change(votec)
  end
end

