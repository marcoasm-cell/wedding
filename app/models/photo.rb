class Photo < ApplicationRecord
  # Guardamos e servimos a fotografia original, sem gerar variantes (evita o
  # processamento de imagem no servidor, que estava a provocar erros 500).
  has_one_attached :image

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
