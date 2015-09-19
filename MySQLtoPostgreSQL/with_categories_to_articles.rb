require 'rubygems'  
require 'active_record'  
require 'yaml'

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  encoding: "unicode" ,
  database: "",
  pool: 5
)  


# CREATE TABLE IF NOT EXISTS `qn6u7_content` (
              #   `id` int(10) unsigned NOT NULL,
              #   `asset_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'FK to the #__assets table.',
# title       #   `title` varchar(255) NOT NULL DEFAULT '',
              #   `alias` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
# summary     #   `introtext` mediumtext NOT NULL,
# content     #   `fulltext` mediumtext NOT NULL,
# state       #   `state` tinyint(3) NOT NULL DEFAULT '0',
# categories  #   `catid` int(10) unsigned NOT NULL DEFAULT '0',
# created_at  #   `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
# created_by  #   `created_by` int(10) unsigned NOT NULL DEFAULT '0',
              #   `created_by_alias` varchar(255) NOT NULL DEFAULT '',
              #   `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
# modified_by #   `modified_by` int(10) unsigned NOT NULL DEFAULT '0',
              #   `checked_out` int(10) unsigned NOT NULL DEFAULT '0',
              #   `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
# start_date  #   `publish_up` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
# end_date    #   `publish_down` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
# images      #   `images` text NOT NULL,
              #   `urls` text NOT NULL,
              #   `attribs` varchar(5120) NOT NULL,
              #   `version` int(10) unsigned NOT NULL DEFAULT '1',
              #   `ordering` int(11) NOT NULL DEFAULT '0',
              #   `metakey` text NOT NULL,
              #   `metadesc` text NOT NULL,
              #   `access` int(10) unsigned NOT NULL DEFAULT '0',
# hits        #   `hits` int(10) unsigned NOT NULL DEFAULT '0',
              #   `metadata` text NOT NULL,
              #   `featured` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Set if article is featured.',
              #   `language` char(7) NOT NULL COMMENT 'The language code for the article.',
              #   `xreference` varchar(50) NOT NULL COMMENT 'A reference to enable linkages to external data sets.'
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


  # create_table "articles", force: :cascade do |t|
  #   t.string   "title"
  #   t.text     "content"
  #   t.string   "keywords"
  #   t.string   "categories"
  #   t.string   "tags"
  #   t.integer  "created_by"
  #   t.integer  "approve"
  #   t.integer  "public"
  #   t.integer  "data_type"
  #   t.datetime "start_date"
  #   t.datetime "end_date"
  #   t.datetime "created_at",  null: false
  #   t.datetime "updated_at",  null: false
  #   t.text     "summary"
  #   t.text     "images"
  #   t.integer  "modified_by"
  # end

class Qn6u7Content < ActiveRecord::Base  
  @dbconfig = YAML.load(File.read('database.yml'))
  establish_connection(@dbconfig["source_db"])
  self.table_name = "qn6u7_content"

end 

class Article < ActiveRecord::Base
  @dbconfig = YAML.load(File.read('database.yml'))
  establish_connection(@dbconfig["destination_db"])

  has_many :categories, through: :article_categories_relationships
  has_many :article_categories_relationships
end

class ArticleCategoriesRelationship < ActiveRecord::Base
  @dbconfig = YAML.load(File.read('database.yml'))
  establish_connection(@dbconfig["destination_db"])
  belongs_to :article
  belongs_to :category
end

class Category < ActiveRecord::Base
  @dbconfig = YAML.load(File.read('database.yml'))
  establish_connection(@dbconfig["destination_db"])

  has_many :articles, through: :article_categories_relationships
  has_many :article_categories_relationships
end

count = 0

ActiveRecord::Base.transaction do
  Article.find_each(batch_size: 5000) do |article|



    category = Category.find_by(title: article.categories_text)
    article.categories << category
   

    article.save!
    count += 1
    puts "第#{count}筆: id #{article.id}, Category: #{article.categories_text}"
  end
end



  