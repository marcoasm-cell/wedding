class Photo < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 400, 400 ], preprocessed: true
    attachable.variant :large, resize_to_limit: [ 1600, 1600 ]
  end

  validates :image, presence: { message: "tem de ser selecionada" }
  validate :acceptable_image

  scope :recent_first, -> { order(created_at: :desc) }

  private

  def acceptable_image
    return unless image.attached?

    if image.blob.byte_size > 50.megabytes
      errors.add(:image, "é demasiado grande (máximo 50 MB)")
    end

    unless image.blob.content_type.to_s.start_with?("image/")
      errors.add(:image, "tem de ser uma fotografia")
    end
  end
end
