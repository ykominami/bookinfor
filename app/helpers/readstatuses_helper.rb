module ReadstatusesHelper
  def list
    Hash[Readstatus.all.map { |x| [x.name, x.id] }]
  end

  module_function :list
end
