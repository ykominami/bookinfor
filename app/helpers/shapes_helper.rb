module ShapesHelper
  def get_list
    Hash[Shape.all.map { |x| [x.name, x.id] }]
  end

  module_function :get_list
end
