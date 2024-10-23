require "pathname"
require "json"

namespace :data do
  require Rails.root + "config/environment.rb"

  desc "Readinglist.all"
  task :size_rl_all do
    p Readinglist.all.size
  end

  desc "Booklist.all"
  task :size_bk_all do
    p Booklist.all.size
  end

  desc "Calibrelist.all"
  task :size_ca_all do
    p Calibrelist.all.size
  end

  desc "Kindlelist.dall"
  task :size_ki_all do
    p Kindlelist.all.size
  end

  desc "Readinglist.all"
  task :rl_all do
    p Readinglist.all
  end

  desc "Booklist.all"
  task :bk_all do
    p Booklist.all
  end

  desc "Calibrelist.all"
  task :ca_all do
    p Calibrelist.all
  end

  desc "Kindlelist.dall"
  task :ki_all do
    p Kindlelist.all
  end

  desc "Readinglist.destroy_all"
  task :rl_dall do
    Readinglist.destroy_all
  end

  desc "Booklist.destroy_all"
  task :bk_dall do
    Booklist.destroy_all
  end

  desc "Calibrelist.destroy_all"
  task :ca_dall do
    Calibrelist.destroy_all
  end

  desc "Kindlelist.destroy_all"
  task :ki_dall do
    Kindlelist.destroy_all
  end

  desc "All destroy_all"
  task :all_dall do
    Booklist.destroy_all
    Calibrelist.destroy_all
    Kindlelist.destroy_all
    Readinglist.destroy_all
  end

  # desc "data download url list and data"
  # task :download, ["cmd", "searchfile"] do |task, args|
  desc "get"
  task :get, ["file"] do |_task, args|
    case args.file
    when :all
      LoggerUtsil.log_info_p ":all"
      ret_all = true
    when ":all"
      LoggerUtsil.log_info_p ":all 2"
      ret_all = true
    else
      LoggerUtsil.log_info_p "etc #{args.file}"
      ret_all = false
    end
    input_dir_pn = ConfigUtils.input_dir_pn
    data_dir_pn = input_dir_pn.join("api")

    files_pn = if ret_all
                 data_dir_pn.children
               else
                 [data_dir_pn.join(args.file)]
               end

    files_pn.each do |input_file_pn|
      content = input_file_pn.read
      json = JSON.parse(content)
      LoggerUtils.log_info_p "json.size=#{json.size}"
      case json.size
      when 0 | 1
        LoggerUtils.log_info_p json
      else
        json.each do |item|
          # p "item=#{item}"
          item.each_with_index do |obj, index|
            k, v = obj
            break if index.zero? && (v.nil? || (v.instance_of?(String) && v =~ /\s+/))
            next if v.nil?

          end
        end
      end
    end
  end

  desc "data download url list and data"
  task :download, ["cmd", "searchfile"] do |_task, args|
    cmd = args.cmd
    cmd = "all" if cmd.nil?
    cmd = DlImporter.fix_cmd(cmd)

    importer_config_dir_pn = ConfigUtils.importer_config_dir_pn

    search_file_pn = nil

    if args.searchfile
      search_file_pn = importer_config_dir_pn + args.searchfile
      unless search_file_pn.exist?
        LoggerUtils.log_info_p "Can't find #{search_file_pn}"
        exit(11)
      end
    end
    search_file_pn ||= importer_config_dir_pn + "search.json"
    dl = DlImporter.new(cmd: cmd, search_file_pn: search_file_pn)
    dl.execute_data_op
  end

  desc "import data"
  task :import, ["search_file", "datalist_file", "local_file"] do |_, args|
    ConfigUtils.use_import_date = false

    importer_config_dir_pn = ConfigUtils.importer_config_dir_pn

    output_dir_pn = ConfigUtils.output_dir_pn
    datalist_json_filename = ConfigUtils.datalist_json_filename

    datalist_file_pn = UtilUtils.check_file_exist(args.datalist_file, output_dir_pn, 11) unless UtilUtils.nil_or_empty?(args.search_file)
    datalist_file_pn = output_dir_pn + datalist_json_filename unless datalist_file_pn

    search_file_pn = UtilUtils.check_file_exist(args.search_file, importer_config_dir_pn, 12) unless UtilUtils.nil_or_empty?(args.search_file)
    search_file_pn = ConfigUtils.search_json_pn unless search_file_pn
    
    local_file_pn  = UtilUtils.check_file_exist(args.local_file,  importer_config_dir_pn, 10) unless UtilUtils.nil_or_empty?(args.local_file)

    importertop = TopImporter.new(datalist_file_pn, search_file_pn, local_file_pn)
    importertop.execute()
  end

  desc "import data from file"
  task :importfile, ["search_file", "datalist_file"] do |_, args|
    importer_config_dir_pn = ConfigUtils.importer_config_dir_pn

    if args.search_file != nil && args.search_file != ""
      search_file_pn = importer_config_dir_pn + args.search_file
      unless search_file_pn.exist?
        LoggerUtils.log_fatal_p "Can't find search_file=#{search_file_pn}"
        exit(12)
      end
    end

    if args.datalist_file != nil && args.datalist_file != ""
      datalist_file_pn = Pathname.new(args.datalist_file)
      unless datalist_file_pn.exist?
        LoggerUtils.log_fatal_p "Can't find datalist_file=#{datalist_file_pn}"
        exit(11)
      end
    end
    importer = TopImporter.new(datalist_file_pn, search_file_pn)
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
  task :file_test_cf do
    sh "rake data:import[search_cf.json,,local_cf.json]"
  end

  desc "data:file test kr"
  task :file_test_kr_rf do
    sh "rake data:import[search_kf.json,,local_kf.json]"
    sh "rake data:import[search_rf.json,,local_rf.json]"
  end

  desc "data:file test kf"
  task :file_test_kf do
    sh "rake data:import[search_kf.json,,local_kf.json]"
  end

  desc "data:file test rf"
  task :file_test_rf do
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
