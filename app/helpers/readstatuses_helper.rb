module ReadstatusesHelper

  def get_list
    Hash[ Readstatus.all.map{ |x| [x.name, x.id] } ]
  end

  module_function :get_list
  
end
