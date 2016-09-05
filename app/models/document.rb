class Document < ApplicationRecord

  validates :uri, presence: true,
            length: { maximum: 15 },
            exclusion: { in: %w(admin) },
            format: { with: /\A[a-z0-9_\s]+\z/ }, 
            uniqueness: { case_sensitive: false }

  def to_param
    uri
  end

end
