module ShapesHelper
  def list
    Hash[Shape.all.map { |x| [x.name, x.id] }]
  end

  module_function :list
end
