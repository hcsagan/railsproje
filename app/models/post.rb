class Post < ActiveRecord::Base
    has_attached_file :image, :styles => { :large => "640x640#", :little => "100x100#", :thumb => "240x240#" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    belongs_to :user
    has_many :likes
    has_many :comments
end
