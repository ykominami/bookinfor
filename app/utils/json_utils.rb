require "json"

class JsonUtils
  def self.parse(file)
    content = File.read(file)
    JSON.parse(content)
  end

  def self.output(fio, obj)
    json_str = JSON.pretty_generate(obj)
    pn = Pathname.new(fio)
    # p "json_str=#{json_str}"
    pn.write(json_str)
  end
end
