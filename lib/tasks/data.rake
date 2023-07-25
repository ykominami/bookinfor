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
    when "data"
      cmd = :DATA
    when "data2"
      cmd = :DATA2
    when "datax"
      cmd = :DATAX
    when "html"
      cmd = :HTML
    when "htmlx"
      cmd = :HTMLX
    else
      cmd = :NOTHING
    end

    if cmd == :NOTHING
      puts "Invalid command is specified!"
      exit(10)
    end

    importer_config_dir_pn = Rails.root + "config" + "importers"

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
  task :import, ["kind", "search_file","datalist_file"] do |_, args|
    puts "kind=#{args.kind}"

    puts "datalist_file=#{args.datalist_file}"
    puts "search_file=#{args.search_file}"

    importer_config_dir_pn = Rails.root + "config" + "importers"

    if args.search_file != nil && args.search_file != ""
      search_file_pn = importer_config_dir_pn + args.search_file
      unless search_file_pn.exist?
        puts "Can't find #{search_file_pn}"
        exit(12)
      end
    end

    if args.datalist_file != nil && args.datalist_file != ""
      datalist_file_pn = Pathname.new(args.datalist_file)
      unless datalist_file_pn.exist?
        puts "Can't find #{datalist_file_pn}"
        exit(11)
      end
    end
    
    # importertop = RootImporter::Top.new(datalist_file_pn, search_file_pn)
    importertop = TopImporter.new(datalist_file_pn, search_file_pn)
    importertop.execute()
  end

  desc "data import bookmark"
  task "import:bookmark", [:word] do |_, args|
    puts "data import bookmark"

    # require Rails.root + "config/environment.rb"

    cfg = LogxUtilxes::Logx.config(Rails.root)
    cfg["prefix"] = "ib_"
    logger = LogxUtilxes::Logx.create(cfg)
    fname = args.word
    fname = ENV["YAML_BOOKMARK"] unless fname
    fname = "../datax/bookmarkr/link.yaml" unless fname
    bm = BookmarksImporters::BookmarksImporter.new(fname, logger)
    array = bm.listupx()
    logger.debug array.size
    bm.save_link_by_insert(array) if array.size > 0
  end
end
