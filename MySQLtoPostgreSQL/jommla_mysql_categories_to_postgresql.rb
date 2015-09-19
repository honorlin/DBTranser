require 'rubygems'  
require 'active_record'  
require 'yaml'

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  encoding: "unicode" ,
  database: "",
  pool: 5
)  



  # create_table "categories", force: :cascade do |t|
  #   t.string  "title"
  #   t.integer "parent_id"
  #   t.integer "lft",                          null: false
  #   t.integer "rgt",                          null: false
  #   t.text    "content"
  #   t.text    "secret_field"
  #   t.integer "depth",            default: 0, null: false
  #   t.integer "children_count",   default: 0, null: false
  #   t.integer "hits"
  #   t.string  "path"
  #   t.string  "extention"
  #   t.string  "alias"
  #   t.integer "state"
  #   t.string  "mata_description"
  #   t.string  "mata_keyword"
  # end
  
# CREATE TABLE IF NOT EXISTS `qn6u7_categories` (
#   `id` int(11) NOT NULL,
#   `asset_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'FK to the #__assets table.',
#   `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
#   `lft` int(11) NOT NULL DEFAULT '0',
#   `rgt` int(11) NOT NULL DEFAULT '0',
#   `level` int(10) unsigned NOT NULL DEFAULT '0',
#   `path` varchar(255) NOT NULL DEFAULT '',
#   `extension` varchar(50) NOT NULL DEFAULT '',
#   `title` varchar(255) NOT NULL,
#   `alias` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
#   `note` varchar(255) NOT NULL DEFAULT '',
#   `description` mediumtext,
#   `published` tinyint(1) NOT NULL DEFAULT '0',
#   `checked_out` int(11) unsigned NOT NULL DEFAULT '0',
#   `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
#   `access` int(10) unsigned DEFAULT NULL,
#   `params` text NOT NULL,
#   `metadesc` varchar(1024) NOT NULL COMMENT 'The meta description for the page.',
#   `metakey` varchar(1024) NOT NULL COMMENT 'The meta keywords for the page.',
#   `metadata` varchar(2048) NOT NULL COMMENT 'JSON encoded metadata properties.',
#   `created_user_id` int(10) unsigned NOT NULL DEFAULT '0',
#   `created_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
#   `modified_user_id` int(10) unsigned NOT NULL DEFAULT '0',
#   `modified_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
#   `hits` int(10) unsigned NOT NULL DEFAULT '0',
#   `language` char(7) NOT NULL,
#   `version` int(10) unsigned NOT NULL DEFAULT '1'
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;



class Qn6u7Category < ActiveRecord::Base  
  @dbconfig = YAML.load(File.read('database.yml'))
  establish_connection(@dbconfig["source_db"])
  self.table_name = "qn6u7_categories"

end 

class Category < ActiveRecord::Base
  @dbconfig = YAML.load(File.read('database.yml'))
  establish_connection(@dbconfig["destination_db"])
end

count = 0

ActiveRecord::Base.transaction do
  Qn6u7Category.where(extension: "com_content").find_each(batch_size: 10) do |c|    
    category = Category.new
    category.id = c.id
    category.title = c.title
    category.parent_id = c.parent_id  
    category.lft = c.lft
    category.rgt = c.rgt
    category.content = c.description
    category.depth = c.level
    category.hits = c.hits
    category.path = c.path
    category.extension = c.extension
    category.alias = c.alias
    category.state = c.published
    category.mata_description = c.metadesc
    category.mata_keyword = c.metakey
    category.save!
    count += 1
    puts "第#{count}筆: id #{c.id}, title: #{c.title}"
  end
end