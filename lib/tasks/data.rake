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

    if args.searchfile
      search_file_pn = importer_config_dir_pn + args.searchfile
      unless search_file_pn.exist?
        puts "Can't find #{search_file_pn}"
        exit(11)
      end
    end

    dl = DlImporter.new(cmd: cmd, search_file_pn: search_file_pn)
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

    if args.search_file != nil && args.search_file != ""
      search_file_pn = importer_config_dir_pn + args.search_file
      unless search_file_pn.exist?
        puts "Can't find #{search_file_pn}"
        exit(12)
      end
    end

    if args.datalist_file != nil && args.datalist_file != ""
      datalist_file_pn = output_dir_pn + args.datalist_file
      unless datalist_file_pn.exist?
        puts "Can't find #{datalist_file_pn}"
        exit(11)
      end
    end

    if args.local_file != nil && args.local_file != ""
      local_file_pn = importer_config_dir_pn + args.local_file
      unless local_file_pn.exist?
        puts "Can't find #{local_file_pn}"
        exit(10)
      end
    end
    importertop = TopImporter.new(datalist_file_pn, search_file_pn, local_file_pn)
    importertop.execute()
  end

  desc "import data from file"
  task :importfile, ["search_file", "datalist_file"] do |_, args|
    importer_config_dir_pn = ConfigUtils.importer_config_dir_pn

    if args.search_file != nil && args.search_file != ""
      search_file_pn = importer_config_dir_pn + args.search_file
      unless search_file_pn.exist?
        puts "Can't find search_file=#{search_file_pn}"
        exit(12)
      end
    end

    if args.datalist_file != nil && args.datalist_file != ""
      datalist_file_pn = Pathname.new(args.datalist_file)
      unless datalist_file_pn.exist?
        puts "Can't find datalist_file=#{datalist_file_pn}"
        exit(11)
      end
    end

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
