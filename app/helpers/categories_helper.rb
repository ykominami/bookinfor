module CategoriesHelper

  def get_list
    Hash[ Category.all.map{ |x| [x.name, x.id] } ]
  end
  
  module_function :get_list
end
