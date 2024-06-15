module PaginationMeta
  extend ActiveSupport::Concern

  included do
    def pagination_meta(collection)
      {
        total_count: collection.count
      }
    end
  end
end
