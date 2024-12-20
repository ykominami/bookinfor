class AllExporter
  def initialize(cmd, search_file_pn = nil, local_file_pn = nil)
    @logger = LoggerUtils.logger()
    @logger.tagged("#{self.class.name}")

    config_pn = ConfigUtils.config_pn
    aux_dbtbl_pn = ConfigUtils.aux_dbtbl_pn
    @logger.debug aux_dbtbl_pn
    # state_pn = ConfigUtils.state_pn

    @datadir = DatadirUtils.new()

    export_or_import(cmd, aux_dbtbl_pn)
    export_or_import(cmd, config_pn)
  end

  def export_or_import(cmd, json_pn)
    configx = ConfigUtils.get_configx(json_pn)
    keys = configx.keys()
    keys.map do |key|
      klass = configx.class(key)
      output_pn = make_file_pn(@datadir.export_pn, key)
      @logger.debug "output_pn=#{output_pn}"
      @logger.debug klass
      if cmd == :export
        export(klass, output_pn)
      else
        import(klass, output_pn)
      end
    end
  end

  def make_file_pn(dir_pn, key)
    file_path = "#{key}.json"
    dir_pn + file_path
  end

  def export(klass, output_pn)
    dump = JSON.generate(klass.all.to_a.map do |item|
      item.attributes
    end)
    File.write(output_pn, dump)
  end

  def import(klass, output_pn)
    content = File.read(output_pn)
    obj = JSON.parse(content)
    @logger.debug output_pn
    klass.insert_all(obj)
    # item.attributes
  end
end
