class Program < ApplicationRecord

    # associations
    has_and_belongs_to_many :clients, class_name: "User", join_table: "clients_programs", optional: true
    has_many :reviews_to_receive, class_name: "Review", foreign_key: "program_id", dependent: :destroy
    has_one_attached :image, dependent: :destroy
    belongs_to :coach, class_name: "User"
    belongs_to :category

    # validations
    validates :title, presence: true, length: { maximum: 50 }
    validates :description, presence: true, length: { maximum: 50 }
    validates :duration, presence: true, numericality: { greater_than: 3, less_than_or_equal_to: 52 }
    validates :content, presence: true, length: { maximum: 10000 }
    validates :price, numericality: { less_than: 10000, message: "of the program is too high" }
    validates :category_id, presence: true
    validate :image_format

    # scope method defined to query results in the model and be used in the controllers(suggestions controller)
    scope :suggested_programs, -> (categories) { where(category: categories) }

    private
    # custom validation method on the image paramater for file upload
    def image_format
        if image.attached? && !image.content_type.in?(%w(image/jpeg image/jpg image/png))
            errors.add(:image, 'must be of the type: JPEG, JPG or PNG')
        elsif image.attached? == false 
            errors.add(:image, 'must be uploaded')            
        end
    end
end
