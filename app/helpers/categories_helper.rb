module CategoriesHelper
  def list
    Hash[Category.all.map { |x| [x.name, x.id] }]
  end

  module_function :list
end
