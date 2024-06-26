require "pathname"
require "json"
require "pp"

namespace :data do
  require Rails.root + "config/environment.rb"

  desc "data download url list and data"
  task :download, ["cmd", "searchfile"] do |task, args|
    if args.cmd == nil
      cmd = :ALL
    end

    cmd_downcase = args.cmd.downcase
    case cmd_downcase
    when "all"
      cmd = :ALL
    when "data_json"
      cmd = :DATA_JSON
    when "data_json_show"
      cmd = :DATA_JSON_SHOW
    when "data_json_show_selected"
      cmd = :DATA_JSON_SHOW_SELECTED
    when "data_json_x"
      cmd = :DATA_JSON_X
    when "html"
      cmd = :HTML
    when "fromhtml"
      cmd = :FROM_HTML
    when "fromhtmltojson"
      cmd = :FROM_HTML_TO_JSON
    when "htmlx"
      cmd = :HTMLX
    when "clean_all_files"
      cmd = :CLEAN_ALL_FILES
    else
      cmd = :NOTHING
    end

    if cmd == :NOTHING
      puts "Invalid command(#{cmd_downcase}) is specified!"
      exit(10)
    end

    importer_config_dir_pn = ConfigUtils.importer_config_dir_pn

    search_file_pn = nil
    
    if args.searchfile
      search_file_pn = importer_config_dir_pn + args.searchfile
      unless search_file_pn.exist?
        puts "Can't find #{search_file_pn}"
        exit(11)
      end
    end
    search_file_pn = importer_config_dir_pn + "search.json" unless search_file_pn
    # puts "search_file_pn=#{search_file_pn}"
    # puts "cmd=#{cmd}"
    # exit(0)
    # puts "=======data.download 1"
    dl = DlImporter.new(cmd: cmd, search_file_pn: search_file_pn)
    # puts "=======data.download 2"
    # exit(0)
    dl.get_data
  end

  desc "import data"
  task :import, ["search_file", "datalist_file", "local_file"] do |_, args|
    # puts "search_file=#{args.search_file}"
    # puts "datalist_file=#{args.datalist_file}"
    # puts "local_file=#{args.local_file}"
    ConfigUtils.use_import_date = false

    importer_config_dir_pn = ConfigUtils.importer_config_dir_pn
    output_dir_pn = ConfigUtils.output_dir_pn
    datalist_json_filename = ConfigUtils.datalist_json_filename
    datalist_file_pn = output_dir_pn + datalist_json_filename

    datalist_file_pn = UtilUtils.check_file_exist(args.datalist_file, output_dir_pn, 11) if args.datalist_file
    search_file_pn = UtilUtils.check_file_exist(args.search_file, importer_config_dir_pn, 12) if args.search_file
    local_file_pn  = UtilUtils.check_file_exist(args.local_file,  importer_config_dir_pn, 10) if args.local_file 

    if UtilUtils.nil_or_empty?(search_file_pn)
      search_file_pn = ConfigUtils.search_json_pn
    end
    importertop = TopImporter.new(datalist_file_pn, search_file_pn, local_file_pn)
    importertop.execute()
  end

  desc "import data from file"
  task :importfile, ["search_file", "datalist_file"] do |_, args|
    importer_config_dir_pn = ConfigUtils.importer_config_dir_pn

    datalist_file_pn = UtilUtils.check_file_exist(args.datalist_file, output_dir_pn, 11) if args.datalist_file
    search_file_pn = UtilUtils.check_file_exist(args.search_file, importer_config_dir_pn, 12) if args.search_file

    importer = KindlefileImporter.new(datalist_file_pn, search_file_pn)
    importer.execute()
  end

  desc "data:file test"
  task :file_test do
    sh "rake data:import[search_bf.json,,local_bf.json]"
    sh "rake data:import[search_cf.json,,local_cf.json]"
    sh "rake data:import[search_kf.json,,local_kf.json]"
    sh "rake data:import[search_rf.json,,local_rf.json]"
  end

  desc "data:file test cakubre"
  task :file_test_c do
    sh "rake data:import[search_cf.json,,local_cf.json]"
  end

  desc "data:file test kf"
  task :file_test_kr do
    sh "rake data:import[search_kf.json,,local_kf.json]"
    sh "rake data:import[search_rf.json,,local_rf.json]"
  end

  desc "data:file test kf"
  task :file_test_k do
    sh "rake data:import[search_kf.json,,local_kf.json]"
  end

  desc "data:file test rf"
  task :file_test_r do
    sh "rake data:import[search_rf.json,,local_rf.json]"
  end

  desc "export"
  task :export do
    AllExporter.new(:export)
  end

  desc "export:import"
  task :export_import do
    AllExporter.new(:import)
  end
end
