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
    # puts args.file
    case args.file
    when :all
      puts ":all"
      ret_all = true
    when ":all"
      puts ":all 2"
      ret_all = true
    else
      puts "etc #{args.file}"
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
      puts "json.size=#{json.size}"
      case json.size
      when 0 | 1
        puts json
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

    cmd_downcase = cmd.downcase
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
    search_file_pn ||= importer_config_dir_pn + "search.json"
    # p "search_file_pn=#{search_file_pn}"
    # p "cmd=#{cmd}"
    # exit(0)
    # puts "=======data.download 1"
    dl = DlImporter.new(cmd: cmd, search_file_pn: search_file_pn)
     # puts "=======data.download 2"
    # exit(0)
    dl.data
  end

  desc "import data"
  task :import, ["search_file", "datalist_file", "local_file"] do |_, args|
    # puts "0 args.search_file=#{args.search_file}"
    # puts "datalist_file=#{args.datalist_file}"
    # puts "local_file=#{args.local_file}"
    ConfigUtils.use_import_date = false

    importer_config_dir_pn = ConfigUtils.importer_config_dir_pn
    # p "importer_config_dir_pn=#{importer_config_dir_pn}"

    output_dir_pn = ConfigUtils.output_dir_pn
    datalist_json_filename = ConfigUtils.datalist_json_filename
    datalist_file_pn = output_dir_pn + datalist_json_filename

    datalist_file_pn = UtilUtils.check_file_exist(args.datalist_file, output_dir_pn, 11) if args.datalist_file
    # p "args.search_file=#{args.search_file}|"
    search_file_pn = UtilUtils.check_file_exist(args.search_file, importer_config_dir_pn, 12) unless UtilUtils.nil_or_empty_string?(args.search_file)
    local_file_pn  = UtilUtils.check_file_exist(args.local_file,  importer_config_dir_pn, 10) if args.local_file

    # p "import data 1 search_file_pn=#{search_file_pn}"
    search_file_pn = ConfigUtils.search_json_pn if UtilUtils.nil_or_empty?(search_file_pn)
    # p "import data 2 search_file_pn=#{search_file_pn}"
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
