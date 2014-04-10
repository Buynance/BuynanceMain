module API
  module V1
    class Businesses < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :businesses do
        desc "Return list of businesses"
        get do
          Business.all # obviously you never want to call #all here
        end
      end
    end
  end
end