module API
  module V1
    class Businesses < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :businesses do
        desc "Returns business count"
        get :count do
          Business.all.size
        end
      end
    end
  end
end